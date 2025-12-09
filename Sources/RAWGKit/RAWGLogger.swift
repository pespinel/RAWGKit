//
// RAWGLogger.swift
// RAWGKit
//

import Foundation
import os.log

/// Centralized logging for RAWGKit
enum RAWGLogger {
    /// Logger for networking operations
    static let network = Logger(subsystem: "com.rawgkit", category: "networking")

    /// Logger for cache operations
    static let cache = Logger(subsystem: "com.rawgkit", category: "cache")

    /// Logger for general operations
    static let general = Logger(subsystem: "com.rawgkit", category: "general")
}
