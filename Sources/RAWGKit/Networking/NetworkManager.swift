//
// NetworkManager.swift
// RAWGKit
//

import Foundation

/// Handles HTTP networking operations
actor NetworkManager {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session _: URLSession = .shared) {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = URLCache(
            memoryCapacity: 50 * 1024 * 1024, // 50 MB
            diskCapacity: 200 * 1024 * 1024 // 200 MB
        )

        self.session = URLSession(configuration: configuration)
        self.decoder = JSONDecoder()
    }

    /// Fetches and decodes data from a URL
    func fetch<T: Decodable>(from url: URL, as _: T.Type) async throws -> T {
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200 ... 299:
            break
        case 401:
            throw NetworkError.unauthorized
        case 400 ... 499:
            throw NetworkError.apiError("Client error: \(httpResponse.statusCode)")
        case 500 ... 599:
            throw NetworkError.serverError(httpResponse.statusCode)
        default:
            throw NetworkError.invalidResponse
        }

        do {
            return try decoder.decode(T.self, from: data)
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
