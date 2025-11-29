//
// NetworkError.swift
// RAWGKit
//

import Foundation

/// Network-related errors
public enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case unauthorized
    case apiError(String)
    case serverError(Int)
    case decodingError
    case rateLimitExceeded(String)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            "Invalid URL"
        case .invalidResponse:
            "Invalid response from server"
        case .unauthorized:
            "Unauthorized. Please check your API key"
        case let .apiError(message):
            "API Error: \(message)"
        case let .serverError(code):
            "Server error with code: \(code)"
        case .decodingError:
            "Failed to decode response"
        case let .rateLimitExceeded(message):
            message
        }
    }
}
