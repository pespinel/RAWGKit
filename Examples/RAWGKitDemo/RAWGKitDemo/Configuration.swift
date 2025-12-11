//
// Configuration.swift
// RAWGKitDemo
//
// Reads build configuration values.
//

import Foundation

enum Configuration {
    /// RAWG API Key from build settings
    static var apiKey: String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "RAWG_API_KEY") as? String,
              !apiKey.isEmpty,
              apiKey != "YOUR_API_KEY_HERE" else {
            fatalError("""
            Missing RAWG API Key!

            Please configure your API key:
            1. Copy Config.xcconfig to Config.local.xcconfig
            2. Add your API key to Config.local.xcconfig
            3. Rebuild the project

            Get your free API key at: https://rawg.io/apidocs
            """)
        }
        return apiKey
    }

    /// Optional API key for preview contexts (returns nil if not configured)
    static var apiKeyIfAvailable: String? {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "RAWG_API_KEY") as? String,
              !apiKey.isEmpty,
              apiKey != "YOUR_API_KEY_HERE" else {
            return nil
        }
        return apiKey
    }
}
