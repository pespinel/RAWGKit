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
    case notFound
    case apiError(String)
    case serverError(Int)
    case decodingError
    case rateLimitExceeded(retryAfter: Int?)
    case noInternetConnection
    case timeout
    case unknown(any Error)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .unauthorized:
            return "Unauthorized. Please check your API key"
        case .notFound:
            return "Resource not found"
        case let .apiError(message):
            return "API Error: \(message)"
        case let .serverError(code):
            return "Server error with code: \(code)"
        case .decodingError:
            return "Failed to decode response"
        case let .rateLimitExceeded(retryAfter):
            if let seconds = retryAfter {
                return "Rate limit exceeded. Retry after \(seconds) seconds"
            }
            return "Rate limit exceeded. Please try again later"
        case .noInternetConnection:
            return "No internet connection available"
        case .timeout:
            return "Request timed out"
        case let .unknown(error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .unauthorized:
            "Verify your API key is correct and active at https://rawg.io/apidocs"
        case .rateLimitExceeded:
            "Wait a few moments before making another request"
        case .noInternetConnection:
            "Check your internet connection and try again"
        case .timeout:
            "Check your internet connection or try again later"
        case .notFound:
            "Verify the resource ID is correct"
        default:
            nil
        }
    }
}
