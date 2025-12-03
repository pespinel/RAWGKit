//
// RetryPolicyTests.swift
// RAWGKit
//

import Foundation
@testable import RAWGKit
import Testing

@Suite("RetryPolicy Tests")
struct RetryPolicyTests {
    @Test("Default retry policy configuration")
    func defaultConfiguration() {
        let policy = RetryPolicy()

        #expect(policy.maxRetries == 3)
        #expect(policy.baseDelay == 1.0)
        #expect(policy.maxDelay == 60.0)
        #expect(policy.useExponentialBackoff == true)
    }

    @Test("Custom retry policy configuration")
    func customConfiguration() {
        let policy = RetryPolicy(
            maxRetries: 5,
            baseDelay: 2.0,
            maxDelay: 120.0,
            useExponentialBackoff: false
        )

        #expect(policy.maxRetries == 5)
        #expect(policy.baseDelay == 2.0)
        #expect(policy.maxDelay == 120.0)
        #expect(policy.useExponentialBackoff == false)
    }

    @Test("Exponential backoff delay calculation")
    func exponentialBackoff() {
        let policy = RetryPolicy(
            maxRetries: 5,
            baseDelay: 1.0,
            maxDelay: 60.0,
            useExponentialBackoff: true
        )

        // attempt 0: 1 * 2^0 = 1
        #expect(policy.delay(for: 0) == 1.0)

        // attempt 1: 1 * 2^1 = 2
        #expect(policy.delay(for: 1) == 2.0)

        // attempt 2: 1 * 2^2 = 4
        #expect(policy.delay(for: 2) == 4.0)

        // attempt 3: 1 * 2^3 = 8
        #expect(policy.delay(for: 3) == 8.0)

        // attempt 10: 1 * 2^10 = 1024, but capped at maxDelay (60)
        #expect(policy.delay(for: 10) == 60.0)
    }

    @Test("Linear backoff delay calculation")
    func linearBackoff() {
        let policy = RetryPolicy(
            maxRetries: 5,
            baseDelay: 2.0,
            maxDelay: 60.0,
            useExponentialBackoff: false
        )

        // All delays should be the same (baseDelay)
        #expect(policy.delay(for: 0) == 2.0)
        #expect(policy.delay(for: 1) == 2.0)
        #expect(policy.delay(for: 2) == 2.0)
        #expect(policy.delay(for: 10) == 2.0)
    }

    @Test("Should retry timeout errors")
    func shouldRetryTimeout() {
        let policy = RetryPolicy(maxRetries: 3)

        #expect(policy.shouldRetry(.timeout, attempt: 0))
        #expect(policy.shouldRetry(.timeout, attempt: 1))
        #expect(policy.shouldRetry(.timeout, attempt: 2))
        #expect(!policy.shouldRetry(.timeout, attempt: 3))
    }

    @Test("Should retry no internet connection errors")
    func shouldRetryNoInternet() {
        let policy = RetryPolicy(maxRetries: 3)

        #expect(policy.shouldRetry(.noInternetConnection, attempt: 0))
        #expect(policy.shouldRetry(.noInternetConnection, attempt: 1))
        #expect(!policy.shouldRetry(.noInternetConnection, attempt: 3))
    }

    @Test("Should retry server errors (5xx)")
    func shouldRetryServerErrors() {
        let policy = RetryPolicy(maxRetries: 3)

        #expect(policy.shouldRetry(.serverError(500), attempt: 0))
        #expect(policy.shouldRetry(.serverError(502), attempt: 1))
        #expect(policy.shouldRetry(.serverError(503), attempt: 2))
        #expect(!policy.shouldRetry(.serverError(500), attempt: 3))
    }

    @Test("Should retry rate limit errors")
    func shouldRetryRateLimit() {
        let policy = RetryPolicy(maxRetries: 3)

        #expect(policy.shouldRetry(.rateLimitExceeded(retryAfter: 60), attempt: 0))
        #expect(policy.shouldRetry(.rateLimitExceeded(retryAfter: nil), attempt: 1))
        #expect(!policy.shouldRetry(.rateLimitExceeded(retryAfter: 60), attempt: 3))
    }

    @Test("Should not retry client errors (4xx)")
    func shouldNotRetryClientErrors() {
        let policy = RetryPolicy(maxRetries: 3)

        #expect(!policy.shouldRetry(.notFound, attempt: 0))
        #expect(!policy.shouldRetry(.unauthorized, attempt: 0))
        #expect(!policy.shouldRetry(.apiError("Bad Request"), attempt: 0))
    }

    @Test("Should not retry decoding errors")
    func shouldNotRetryDecodingErrors() {
        let policy = RetryPolicy(maxRetries: 3)

        #expect(!policy.shouldRetry(.decodingError, attempt: 0))
        #expect(!policy.shouldRetry(.invalidResponse, attempt: 0))
        #expect(!policy.shouldRetry(.invalidURL, attempt: 0))
    }

    @Test("NetworkError equality")
    func networkErrorEquality() {
        // swiftlint:disable:next identical_operands
        #expect(NetworkError.timeout == NetworkError.timeout)
        // swiftlint:disable:next identical_operands
        #expect(NetworkError.notFound == NetworkError.notFound)
        // swiftlint:disable:next identical_operands
        #expect(NetworkError.serverError(500) == NetworkError.serverError(500))
        #expect(NetworkError.serverError(500) != NetworkError.serverError(502))
        #expect(NetworkError.timeout != NetworkError.notFound)
    }

    @Test("NetworkError hashability")
    func networkErrorHashability() {
        let errors: Set<NetworkError> = [
            .timeout,
            .notFound,
            .noInternetConnection,
            .serverError(500),
            .serverError(502),
        ]

        #expect(errors.count == 5)
        #expect(errors.contains(.timeout))
        #expect(errors.contains(.notFound))
    }
}
