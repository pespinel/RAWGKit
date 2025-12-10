//
// RAWGKitTests.swift
// RAWGKitTests
//

@testable import RAWGKit
import Testing

@Suite("RAWGKit Basic Tests")
struct RAWGKitTests {
    @Test("Package imports correctly")
    func packageImport() {
        _ = RAWGClient(apiKey: "test-key")
    }

    @Test("Network error descriptions are not nil")
    func networkErrorDescription() {
        let invalidURLError = NetworkError.invalidURL
        #expect(invalidURLError.errorDescription != nil)

        let unauthorizedError = NetworkError.unauthorized
        #expect(unauthorizedError.errorDescription != nil)

        let decodingError = NetworkError.decodingError
        #expect(decodingError.errorDescription != nil)
    }
}
