//
// NetworkErrorTests.swift
// RAWGKitTests
//

import Foundation
@testable import RAWGKit
import Testing

@Suite("NetworkError Tests")
struct NetworkErrorTests {
    @Test("NetworkError.invalidURL has correct description")
    func invalidURLDescription() {
        let error = NetworkError.invalidURL
        #expect(error.errorDescription == "Invalid URL")
        #expect(error.recoverySuggestion == nil)
    }

    @Test("NetworkError.invalidResponse has correct description")
    func invalidResponseDescription() {
        let error = NetworkError.invalidResponse
        #expect(error.errorDescription == "Invalid response from server")
        #expect(error.recoverySuggestion == nil)
    }

    @Test("NetworkError.unauthorized has correct description and recovery")
    func unauthorizedDescription() {
        let error = NetworkError.unauthorized
        #expect(error.errorDescription == "Unauthorized. Please check your API key")
        #expect(error.recoverySuggestion == "Verify your API key is correct and active at https://rawg.io/apidocs")
    }

    @Test("NetworkError.notFound has correct description and recovery")
    func notFoundDescription() {
        let error = NetworkError.notFound
        #expect(error.errorDescription == "Resource not found")
        #expect(error.recoverySuggestion == "Verify the resource ID is correct")
    }

    @Test("NetworkError.apiError has correct description")
    func apiErrorDescription() {
        let error = NetworkError.apiError("Bad request")
        #expect(error.errorDescription == "API Error: Bad request")
    }

    @Test("NetworkError.serverError has correct description")
    func serverErrorDescription() {
        let error = NetworkError.serverError(500)
        #expect(error.errorDescription == "Server error with code: 500")
    }

    @Test("NetworkError.decodingError has correct description")
    func decodingErrorDescription() {
        let error = NetworkError.decodingError
        #expect(error.errorDescription == "Failed to decode response")
    }

    @Test("NetworkError.rateLimitExceeded without retryAfter")
    func rateLimitExceededWithoutRetryAfter() {
        let error = NetworkError.rateLimitExceeded(retryAfter: nil)
        #expect(error.errorDescription == "Rate limit exceeded. Please try again later")
        #expect(error.recoverySuggestion == "Wait a few moments before making another request")
    }

    @Test("NetworkError.rateLimitExceeded with retryAfter")
    func rateLimitExceededWithRetryAfter() {
        let error = NetworkError.rateLimitExceeded(retryAfter: 60)
        #expect(error.errorDescription == "Rate limit exceeded. Retry after 60 seconds")
        #expect(error.recoverySuggestion == "Wait a few moments before making another request")
    }

    @Test("NetworkError.noInternetConnection has correct description and recovery")
    func noInternetConnectionDescription() {
        let error = NetworkError.noInternetConnection
        #expect(error.errorDescription == "No internet connection available")
        #expect(error.recoverySuggestion == "Check your internet connection and try again")
    }

    @Test("NetworkError.timeout has correct description and recovery")
    func timeoutDescription() {
        let error = NetworkError.timeout
        #expect(error.errorDescription == "Request timed out")
        #expect(error.recoverySuggestion == "Check your internet connection or try again later")
    }

    @Test("NetworkError.unknown has correct description")
    func unknownErrorDescription() {
        struct TestError: Error, LocalizedError {
            var errorDescription: String? { "Test error" }
        }

        let error = NetworkError.unknown(TestError())
        #expect(error.errorDescription?.contains("Test error") == true)
    }
}
