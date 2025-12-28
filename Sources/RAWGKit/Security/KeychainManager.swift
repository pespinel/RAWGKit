//
// KeychainManager.swift
// RAWGKit
//

import Foundation
import Security

/// Manages secure storage of sensitive data using the iOS Keychain.
///
/// `KeychainManager` provides thread-safe methods for storing, retrieving, and deleting
/// sensitive information like API keys in the iOS Keychain. This ensures that credentials
/// are encrypted at rest and protected from unauthorized access.
///
/// ## Features
///
/// - **Secure Storage**: API keys encrypted using iOS Keychain
/// - **Thread Safety**: Actor isolation ensures safe concurrent access
/// - **Error Handling**: Comprehensive error types for all operations
/// - **Automatic Cleanup**: Methods to delete stored credentials
///
/// ## Usage
///
/// ```swift
/// // Save an API key
/// try await KeychainManager.shared.saveAPIKey("your-api-key-here")
///
/// // Retrieve the saved API key
/// let apiKey = try await KeychainManager.shared.loadAPIKey()
///
/// // Delete the API key
/// try await KeychainManager.shared.deleteAPIKey()
/// ```
///
/// - Note: The Keychain is only available on Apple platforms (iOS, macOS, tvOS, watchOS).
///   Data persists across app launches and is backed up (when device backup is enabled).
public actor KeychainManager {
    /// Shared singleton instance
    public static let shared = KeychainManager()

    /// Service identifier for keychain items
    private let service = "com.rawgkit.apikey"

    /// Account identifier for the API key
    private let account = "rawg_api_key"

    private init() {}

    /// Saves an API key to the Keychain.
    ///
    /// If a key already exists, it will be updated with the new value.
    ///
    /// - Parameter apiKey: The API key to store securely
    /// - Throws: `KeychainError` if the save operation fails
    public func saveAPIKey(_ apiKey: String) throws {
        guard let data = apiKey.data(using: .utf8) else {
            throw KeychainError.invalidData
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]

        // Delete existing item (if any)
        SecItemDelete(query as CFDictionary)

        // Add new item
        var addQuery = query
        addQuery[kSecValueData as String] = data
        addQuery[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock

        let status = SecItemAdd(addQuery as CFDictionary, nil)

        guard status == errSecSuccess else {
            throw KeychainError.saveFailed(status: status)
        }
    }

    /// Loads the API key from the Keychain.
    ///
    /// - Returns: The stored API key string
    /// - Throws: `KeychainError` if the key cannot be retrieved or doesn't exist
    public func loadAPIKey() throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                throw KeychainError.itemNotFound
            }
            throw KeychainError.loadFailed(status: status)
        }

        guard let data = result as? Data,
              let apiKey = String(data: data, encoding: .utf8) else {
            throw KeychainError.invalidData
        }

        return apiKey
    }

    /// Deletes the API key from the Keychain.
    ///
    /// - Throws: `KeychainError` if the deletion fails
    public func deleteAPIKey() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteFailed(status: status)
        }
    }

    /// Checks if an API key exists in the Keychain.
    ///
    /// - Returns: `true` if an API key is stored, `false` otherwise
    public func hasAPIKey() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: false,
        ]

        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }
}

/// Errors that can occur during Keychain operations.
public enum KeychainError: Error, LocalizedError {
    /// The data format is invalid
    case invalidData

    /// The requested item was not found in the Keychain
    case itemNotFound

    /// Failed to save the item to the Keychain
    case saveFailed(status: OSStatus)

    /// Failed to load the item from the Keychain
    case loadFailed(status: OSStatus)

    /// Failed to delete the item from the Keychain
    case deleteFailed(status: OSStatus)

    public var errorDescription: String? {
        switch self {
        case .invalidData:
            "Invalid data format for Keychain storage"
        case .itemNotFound:
            "API key not found in Keychain"
        case let .saveFailed(status):
            "Failed to save API key to Keychain (status: \(status))"
        case let .loadFailed(status):
            "Failed to load API key from Keychain (status: \(status))"
        case let .deleteFailed(status):
            "Failed to delete API key from Keychain (status: \(status))"
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .invalidData:
            "Ensure the API key is a valid UTF-8 string"
        case .itemNotFound:
            "Save an API key to the Keychain before attempting to load it"
        case .saveFailed:
            "Check app entitlements and Keychain access permissions"
        case .loadFailed:
            "Ensure the API key was previously saved to the Keychain"
        case .deleteFailed:
            "Check app entitlements and Keychain access permissions"
        }
    }
}
