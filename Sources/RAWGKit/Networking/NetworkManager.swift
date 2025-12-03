//
// NetworkManager.swift
// RAWGKit
//

import Foundation

/// Handles HTTP networking operations
actor NetworkManager {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let cache: CacheManager
    private let cacheEnabled: Bool
    private let retryPolicy: RetryPolicy?

    /// Creates a new NetworkManager
    /// - Parameters:
    ///   - session: Custom URLSession for requests. If nil, creates a default session.
    ///   - cacheEnabled: Whether to use in-memory caching (default: true)
    ///   - retryPolicy: Policy for retrying failed requests (default: 3 retries with exponential backoff)
    ///   - requestTimeout: Timeout for requests in seconds (default: 30)
    init(
        session: URLSession? = nil,
        cacheEnabled: Bool = true,
        retryPolicy: RetryPolicy? = RetryPolicy(),
        requestTimeout: TimeInterval = 30.0
    ) {
        if let session {
            self.session = session
        } else {
            let configuration = URLSessionConfiguration.default
            configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
            configuration.urlCache = nil // We use our own CacheManager
            configuration.timeoutIntervalForRequest = requestTimeout
            self.session = URLSession(configuration: configuration)
        }

        self.decoder = JSONDecoder()
        self.cache = CacheManager()
        self.cacheEnabled = cacheEnabled
        self.retryPolicy = retryPolicy
    }

    /// Fetches and decodes data from a URL with optional caching
    func fetch<T: Decodable>(from url: URL, as _: T.Type, useCache: Bool = true) async throws -> T {
        // Check cache first
        if cacheEnabled, useCache, let cachedData = await cache.get(for: url) {
            do {
                return try decoder.decode(T.self, from: cachedData)
            } catch {
                // If cached data is corrupted, fetch fresh
            }
        }

        // Try with retry logic if enabled
        if let policy = retryPolicy {
            return try await fetchWithRetry(from: url, as: T.self, policy: policy, useCache: useCache)
        }

        // Single attempt without retry
        return try await performFetch(from: url, as: T.self, useCache: useCache)
    }

    /// Perform fetch with retry logic
    private func fetchWithRetry<T: Decodable>(
        from url: URL,
        as _: T.Type,
        policy: RetryPolicy,
        useCache: Bool
    ) async throws -> T {
        var attempt = 0
        var lastError: NetworkError?

        while attempt < policy.maxRetries {
            do {
                return try await performFetch(from: url, as: T.self, useCache: useCache)
            } catch let error as NetworkError {
                lastError = error

                if policy.shouldRetry(error, attempt: attempt) {
                    let delay = policy.delay(for: attempt)

                    #if DEBUG
                        print("⚠️ RAWGKit: Retry attempt \(attempt + 1)/\(policy.maxRetries) after \(delay)s delay")
                    #endif

                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    attempt += 1
                } else {
                    throw error
                }
            }
        }

        throw lastError ?? NetworkError.unknown(URLError(.unknown))
    }

    /// Perform a single fetch attempt
    private func performFetch<T: Decodable>(from url: URL, as _: T.Type, useCache: Bool) async throws -> T {
        do {
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            switch httpResponse.statusCode {
            case 200 ... 299:
                break
            case 401:
                throw NetworkError.unauthorized
            case 404:
                throw NetworkError.notFound
            case 429:
                let retryAfter = httpResponse.value(forHTTPHeaderField: "Retry-After")
                let seconds = retryAfter.flatMap(Int.init)
                throw NetworkError.rateLimitExceeded(retryAfter: seconds)
            case 400 ... 499:
                throw NetworkError.apiError("Client error: \(httpResponse.statusCode)")
            case 500 ... 599:
                throw NetworkError.serverError(httpResponse.statusCode)
            default:
                throw NetworkError.invalidResponse
            }

            do {
                let decoded = try decoder.decode(T.self, from: data)
                // Cache successful responses
                if cacheEnabled, useCache {
                    await cache.set(data, for: url)
                }
                return decoded
            } catch {
                #if DEBUG
                    print("❌ RAWGKit Decoding error: \(error)")
                    if
                        let json = try? JSONSerialization.jsonObject(with: data),
                        let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                        let prettyString = String(data: prettyData, encoding: .utf8)
                        print("📄 Response JSON:\n\(prettyString ?? "")")
                    }
                #endif
                throw NetworkError.decodingError
            }
        } catch let error as NetworkError {
            throw error
        } catch let urlError as URLError {
            // Map URLError to NetworkError
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                throw NetworkError.noInternetConnection
            case .timedOut:
                throw NetworkError.timeout
            default:
                throw NetworkError.unknown(urlError)
            }
        } catch {
            throw NetworkError.unknown(error)
        }
    }

    /// Clear cache
    func clearCache() async {
        await cache.clear()
    }

    /// Get cache statistics
    func cacheStats() async -> CacheManager.CacheStats {
        await cache.stats
    }

    /// Builds a URL with query parameters
    nonisolated func buildURL(
        baseURL: String,
        path: String,
        queryItems: [String: String]
    ) throws -> URL {
        guard var components = URLComponents(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }

        components.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        return url
    }
}
