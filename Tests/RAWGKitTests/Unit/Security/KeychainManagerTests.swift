//
// KeychainManagerTests.swift
// RAWGKitTests
//

import Foundation
@testable import RAWGKit
import Testing

@Suite("KeychainManager Tests", .serialized)
struct KeychainManagerTests {
    // Use a unique service name for tests to avoid conflicts
    private let testAPIKey = "test-api-key-12345"

    // MARK: - Save Tests

    @Test("Save API key successfully")
    func saveAPIKeySuccessfully() async throws {
        let manager = KeychainManager.shared

        // Clean up before test
        try? await manager.deleteAPIKey()

        // Save the key
        try await manager.saveAPIKey(testAPIKey)

        // Verify it was saved
        let hasKey = await manager.hasAPIKey()
        #expect(hasKey == true)

        // Clean up after test
        try? await manager.deleteAPIKey()
    }

    @Test("Update existing API key")
    func updateExistingAPIKey() async throws {
        let manager = KeychainManager.shared

        // Clean up before test
        try? await manager.deleteAPIKey()

        // Save initial key
        try await manager.saveAPIKey("initial-key")

        // Update with new key
        try await manager.saveAPIKey(testAPIKey)

        // Verify updated key was saved
        let loadedKey = try await manager.loadAPIKey()
        #expect(loadedKey == testAPIKey)

        // Clean up after test
        try? await manager.deleteAPIKey()
    }

    // MARK: - Load Tests

    @Test("Load saved API key")
    func loadSavedAPIKey() async throws {
        let manager = KeychainManager.shared

        // Clean up before test
        try? await manager.deleteAPIKey()

        // Save a key
        try await manager.saveAPIKey(testAPIKey)

        // Load the key
        let loadedKey = try await manager.loadAPIKey()
        #expect(loadedKey == testAPIKey)

        // Clean up after test
        try? await manager.deleteAPIKey()
    }

    @Test("Load API key throws when not found")
    func loadAPIKeyThrowsWhenNotFound() async throws {
        let manager = KeychainManager.shared

        // Ensure no key exists (with retry to handle race conditions)
        for _ in 0 ..< 3 {
            try? await manager.deleteAPIKey()
            try? await Task.sleep(nanoseconds: 10_000_000) // 10ms
        }

        // Attempt to load should throw
        do {
            _ = try await manager.loadAPIKey()
            Issue.record("Expected KeychainError to be thrown but operation succeeded")
        } catch is KeychainError {
            // Expected error - test passes
        } catch {
            Issue.record("Expected KeychainError but got \(type(of: error)): \(error)")
        }
    }

    // MARK: - Delete Tests

    @Test("Delete API key successfully")
    func deleteAPIKeySuccessfully() async throws {
        let manager = KeychainManager.shared

        // Clean up before test
        try? await manager.deleteAPIKey()

        // Save a key
        try await manager.saveAPIKey(testAPIKey)

        // Verify it exists
        var hasKey = await manager.hasAPIKey()
        #expect(hasKey == true)

        // Delete the key
        try await manager.deleteAPIKey()

        // Verify it no longer exists
        hasKey = await manager.hasAPIKey()
        #expect(hasKey == false)
    }

    @Test("Delete non-existent key does not throw")
    func deleteNonExistentKeyDoesNotThrow() async throws {
        let manager = KeychainManager.shared

        // Ensure no key exists
        try? await manager.deleteAPIKey()

        // Deleting again should not throw
        try await manager.deleteAPIKey()
    }

    // MARK: - Has API Key Tests

    @Test("hasAPIKey returns true when key exists")
    func hasAPIKeyReturnsTrueWhenExists() async throws {
        let manager = KeychainManager.shared

        // Clean up before test
        try? await manager.deleteAPIKey()

        // Save a key
        try await manager.saveAPIKey(testAPIKey)

        // Check existence
        let hasKey = await manager.hasAPIKey()
        #expect(hasKey == true)

        // Clean up after test
        try? await manager.deleteAPIKey()
    }

    @Test("hasAPIKey returns false when key does not exist")
    func hasAPIKeyReturnsFalseWhenNotExists() async throws {
        let manager = KeychainManager.shared

        // Ensure no key exists
        try? await manager.deleteAPIKey()

        // Check existence
        let hasKey = await manager.hasAPIKey()
        #expect(hasKey == false)
    }

    // MARK: - RAWGClient Integration Tests

    @Test("RAWGClient can be initialized with Keychain")
    func rawgClientInitWithKeychain() async throws {
        // Clean up before test
        try? await KeychainManager.shared.deleteAPIKey()

        // Save API key
        try await RAWGClient.saveAPIKeyToKeychain(testAPIKey)

        // Create client from Keychain
        let client = try await RAWGClient.initWithKeychain()

        // Verify client was created (if we got here without throwing, the test passes)
        _ = client // Suppress unused variable warning

        // Clean up after test
        try? await RAWGClient.deleteAPIKeyFromKeychain()
    }

    @Test("RAWGClient.initWithKeychain throws when no key stored")
    func rawgClientInitWithKeychainThrowsWhenNoKey() async throws {
        // Ensure no key exists (with multiple attempts to handle race conditions)
        for _ in 0 ..< 3 {
            try? await KeychainManager.shared.deleteAPIKey()
            try? await Task.sleep(nanoseconds: 10_000_000) // 10ms
        }

        // Attempt to create client should throw
        do {
            _ = try await RAWGClient.initWithKeychain()
            Issue.record("Expected KeychainError to be thrown but RAWGClient was created")
        } catch is KeychainError {
            // Expected error - test passes
        } catch {
            Issue.record("Expected KeychainError but got \(type(of: error)): \(error)")
        }
    }

    @Test("RAWGClient.saveAPIKeyToKeychain saves successfully")
    func rawgClientSaveAPIKeyToKeychain() async throws {
        // Clean up before test - ensure clean state
        for _ in 0 ..< 3 {
            try? await KeychainManager.shared.deleteAPIKey()
            try? await Task.sleep(nanoseconds: 10_000_000)
        }

        // Save via RAWGClient convenience method
        try await RAWGClient.saveAPIKeyToKeychain(testAPIKey)

        // Wait a bit for save to complete
        try? await Task.sleep(nanoseconds: 50_000_000) // 50ms

        // Verify it was saved
        let loadedKey = try await KeychainManager.shared.loadAPIKey()
        #expect(loadedKey == testAPIKey)

        // Clean up after test
        try? await RAWGClient.deleteAPIKeyFromKeychain()
        try? await Task.sleep(nanoseconds: 10_000_000)
    }

    @Test("RAWGClient.deleteAPIKeyFromKeychain deletes successfully")
    func rawgClientDeleteAPIKeyFromKeychain() async throws {
        // Clean up first
        try? await KeychainManager.shared.deleteAPIKey()
        try? await Task.sleep(nanoseconds: 10_000_000)

        // Save a key first
        try await KeychainManager.shared.saveAPIKey(testAPIKey)
        try? await Task.sleep(nanoseconds: 50_000_000) // 50ms

        // Delete via RAWGClient convenience method
        try await RAWGClient.deleteAPIKeyFromKeychain()
        try? await Task.sleep(nanoseconds: 50_000_000) // 50ms

        // Verify it was deleted
        let hasKey = await KeychainManager.shared.hasAPIKey()
        #expect(hasKey == false)
    }

    // MARK: - Error Description Tests

    @Test("KeychainError provides descriptive messages")
    func keychainErrorProvidesDescriptiveMessages() {
        let invalidDataError = KeychainError.invalidData
        #expect(invalidDataError.errorDescription != nil)
        #expect(invalidDataError.recoverySuggestion != nil)

        let notFoundError = KeychainError.itemNotFound
        #expect(notFoundError.errorDescription != nil)
        #expect(notFoundError.recoverySuggestion != nil)

        let saveFailedError = KeychainError.saveFailed(status: -25300)
        #expect(saveFailedError.errorDescription != nil)
        #expect(saveFailedError.recoverySuggestion != nil)

        let loadFailedError = KeychainError.loadFailed(status: -25300)
        #expect(loadFailedError.errorDescription != nil)
        #expect(loadFailedError.recoverySuggestion != nil)

        let deleteFailedError = KeychainError.deleteFailed(status: -25300)
        #expect(deleteFailedError.errorDescription != nil)
        #expect(deleteFailedError.recoverySuggestion != nil)
    }

    // MARK: - Concurrent Access Tests

    @Test("Concurrent save and load operations are thread-safe")
    func concurrentOperationsAreThreadSafe() async throws {
        let manager = KeychainManager.shared

        // Clean up before test
        try? await manager.deleteAPIKey()

        // Save initial key
        try await manager.saveAPIKey("initial-key")

        // Perform concurrent operations
        await withTaskGroup(of: Void.self) { group in
            // Multiple saves
            for index in 0 ..< 5 {
                group.addTask {
                    try? await manager.saveAPIKey("key-\(index)")
                }
            }

            // Multiple loads
            for _ in 0 ..< 5 {
                group.addTask {
                    _ = try? await manager.loadAPIKey()
                }
            }

            // Multiple has checks
            for _ in 0 ..< 5 {
                group.addTask {
                    _ = await manager.hasAPIKey()
                }
            }
        }

        // Verify a key still exists after concurrent operations
        let hasKey = await manager.hasAPIKey()
        #expect(hasKey == true)

        // Clean up after test
        try? await manager.deleteAPIKey()
    }
}
