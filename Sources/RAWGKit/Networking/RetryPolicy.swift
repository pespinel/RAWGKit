//
// RetryPolicy.swift
// RAWGKit
//

import Foundation

/// Configuration for retry behavior
public struct RetryPolicy: Sendable {
    /// Maximum number of retry attempts
    public let maxRetries: Int

    /// Base delay between retries (will be exponentially increased)
    public let baseDelay: TimeInterval

    /// Maximum delay between retries
    public let maxDelay: TimeInterval

    /// Whether to use exponential backoff
    public let useExponentialBackoff: Bool

    public init(
        maxRetries: Int = RAWGConstants.defaultMaxRetries,
        baseDelay: TimeInterval = 1.0,
        maxDelay: TimeInterval = 60.0,
        useExponentialBackoff: Bool = true
    ) {
        self.maxRetries = maxRetries
        self.baseDelay = baseDelay
        self.maxDelay = maxDelay
        self.useExponentialBackoff = useExponentialBackoff
    }

    /// Calculate delay for a given attempt
    func delay(for attempt: Int) -> TimeInterval {
        guard useExponentialBackoff else {
            return baseDelay
        }

        let exponentialDelay = baseDelay * pow(2.0, Double(attempt))
        return min(exponentialDelay, maxDelay)
    }

    /// Check if an error should be retried
    func shouldRetry(_ error: NetworkError, attempt: Int) -> Bool {
        guard attempt < maxRetries else { return false }

        // Check if error type matches any retryable error
        switch error {
        case .timeout, .noInternetConnection:
            return true
        case let .serverError(code):
            return code >= 500 && code < 600 // 5xx errors are retryable
        case .rateLimitExceeded:
            return true // Rate limit is retryable with backoff
        case .unknown:
            return true // Unknown errors might be transient
        default:
            return false
        }
    }
}

extension NetworkError: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .invalidURL:
            hasher.combine("invalidURL")
        case .invalidResponse:
            hasher.combine("invalidResponse")
        case .decodingError:
            hasher.combine("decodingError")
        case .unauthorized:
            hasher.combine("unauthorized")
        case .notFound:
            hasher.combine("notFound")
        case let .apiError(message):
            hasher.combine("apiError")
            hasher.combine(message)
        case .rateLimitExceeded:
            hasher.combine("rateLimitExceeded")
        case .noInternetConnection:
            hasher.combine("noInternetConnection")
        case .timeout:
            hasher.combine("timeout")
        case let .serverError(code):
            hasher.combine("serverError")
            hasher.combine(code)
        case .unknown:
            hasher.combine("unknown")
        }
    }

    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.invalidResponse, .invalidResponse),
             (.decodingError, .decodingError),
             (.unauthorized, .unauthorized),
             (.notFound, .notFound),
             (.rateLimitExceeded, .rateLimitExceeded),
             (.noInternetConnection, .noInternetConnection),
             (.timeout, .timeout),
             (.unknown, .unknown):
            true
        case let (.apiError(msg1), .apiError(msg2)):
            msg1 == msg2
        case let (.serverError(code1), .serverError(code2)):
            code1 == code2
        default:
            false
        }
    }
}
