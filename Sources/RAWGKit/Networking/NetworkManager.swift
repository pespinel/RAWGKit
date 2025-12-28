//
// NetworkManager.swift
// RAWGKit
//

import Foundation
import os.log

/// Actor responsible for managing HTTP networking operations with caching and retry logic.
///
/// `NetworkManager` is the core networking component of RAWGKit that handles all HTTP requests
/// to the RAWG API. It provides thread-safe network operations using Swift's actor isolation,
/// automatic request deduplication, in-memory caching with TTL, and configurable retry policies.
///
/// ## Features
///
/// - **Thread Safety**: Actor isolation ensures safe concurrent access
/// - **Request Deduplication**: Prevents duplicate simultaneous requests to the same URL
/// - **In-Memory Caching**: Optional caching with configurable TTL (default: 5 minutes)
/// - **Automatic Retries**: Configurable retry policy with exponential backoff
/// - **Structured Logging**: Uses `os.Logger` for debugging and error tracking
/// - **Cancellation Support**: All active requests can be cancelled via `cancelAllRequests()`
///
/// ## Usage
///
/// NetworkManager is typically instantiated internally by `RAWGClient` and not used directly:
///
/// ```swift
/// // Internal usage by RAWGClient
/// let manager = NetworkManager(cacheEnabled: true)
/// let response: GamesResponse = try await manager.fetch(from: url, as: GamesResponse.self)
/// ```
///
/// - Note: This actor uses `URLSession` for HTTP requests and `NSCache` for caching.
///   All network operations are performed asynchronously and can throw `NetworkError`.
actor NetworkManager: NetworkManaging {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let cache: CacheManager
    private let cacheEnabled: Bool
    private let retryPolicy: RetryPolicy?
    private let certificatePinning: CertificatePinning?
    private var activeTasks: [URL: Task<Data, any Error>] = [:]

    /// Creates a new NetworkManager instance.
    ///
    /// - Parameters:
    ///   - session: Custom URLSession for requests. If nil, creates a default session
    ///     with no cache policy (uses internal `CacheManager` instead)
    ///   - cacheEnabled: Whether to use in-memory caching (default: true)
    ///   - retryPolicy: Policy for retrying failed requests (default: 3 retries with exponential backoff)
    ///   - requestTimeout: Timeout for requests in seconds (default: 30)
    ///   - certificatePinning: Optional certificate pinning for enhanced security.
    ///     When provided, the network manager will validate server certificates against
    ///     the pinned public keys to prevent man-in-the-middle attacks.
    init(
        session: URLSession? = nil,
        cacheEnabled: Bool = true,
        retryPolicy: RetryPolicy? = RetryPolicy(),
        requestTimeout: TimeInterval = RAWGConstants.defaultRequestTimeout,
        certificatePinning: CertificatePinning? = nil
    ) {
        self.certificatePinning = certificatePinning

        if let session {
            self.session = session
        } else {
            let configuration = URLSessionConfiguration.default
            configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
            configuration.urlCache = nil // We use our own CacheManager
            configuration.timeoutIntervalForRequest = requestTimeout

            // Create session with certificate pinning delegate if configured
            if let pinning = certificatePinning {
                let delegate = CertificatePinningDelegate(certificatePinning: pinning)
                self.session = URLSession(
                    configuration: configuration,
                    delegate: delegate,
                    delegateQueue: nil
                )
            } else {
                self.session = URLSession(configuration: configuration)
            }
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

                    RAWGLogger.network.debug("Retry attempt \(attempt + 1)/\(policy.maxRetries) after \(delay)s delay")

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
        // Check if there's already a request in flight
        if let existingTask = activeTasks[url] {
            let data = try await existingTask.value
            return try decoder.decode(T.self, from: data)
        }

        // Create and track new task
        let task = Task<Data, any Error> {
            let (data, response) = try await session.data(from: url)
            try validateResponse(response)
            return data
        }

        activeTasks[url] = task

        do {
            let data = try await task.value
            activeTasks.removeValue(forKey: url)
            return try await decodeAndCache(data, for: url, useCache: useCache)
        } catch let error as NetworkError {
            activeTasks.removeValue(forKey: url)
            throw error
        } catch let urlError as URLError {
            activeTasks.removeValue(forKey: url)
            throw mapURLError(urlError)
        } catch {
            activeTasks.removeValue(forKey: url)
            throw NetworkError.unknown(error)
        }
    }

    /// Validate HTTP response status code
    private func validateResponse(_ response: URLResponse) throws {
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
    }

    /// Decode data and cache if enabled
    private func decodeAndCache<T: Decodable>(_ data: Data, for url: URL, useCache: Bool) async throws -> T {
        do {
            let decoded = try decoder.decode(T.self, from: data)
            if cacheEnabled, useCache {
                await cache.set(data, for: url)
            }
            return decoded
        } catch {
            #if DEBUG
                RAWGLogger.network.error("Decoding error: \(error.localizedDescription)")
                if let json = try? JSONSerialization.jsonObject(with: data),
                   let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                   let prettyString = String(data: prettyData, encoding: .utf8) {
                    RAWGLogger.network.debug("Response JSON: \(prettyString)")
                }
            #else
                RAWGLogger.network.error("Decoding error occurred")
            #endif
            throw NetworkError.decodingError
        }
    }

    /// Map URLError to NetworkError
    private func mapURLError(_ error: URLError) -> NetworkError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost:
            .noInternetConnection
        case .timedOut:
            .timeout
        default:
            .unknown(error)
        }
    }

    /// Cancel all active requests
    func cancelAllRequests() {
        for (_, task) in activeTasks {
            task.cancel()
        }
        activeTasks.removeAll()
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
