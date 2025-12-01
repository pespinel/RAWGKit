//
// RAWGResponse+Extensions.swift
// RAWGKit
//

import Foundation

public extension RAWGResponse {
    /// Returns the current page number (estimated from next/previous)
    var currentPage: Int? {
        if let next, let components = URLComponents(string: next),
           let pageItem = components.queryItems?.first(where: { $0.name == "page" }),
           let pageString = pageItem.value,
           let nextPage = Int(pageString) {
            return nextPage - 1
        }

        if let previous, let components = URLComponents(string: previous),
           let pageItem = components.queryItems?.first(where: { $0.name == "page" }),
           let pageString = pageItem.value,
           let prevPage = Int(pageString) {
            return prevPage + 1
        }

        return nil
    }

    /// Returns true if there's a previous page
    var hasPreviousPage: Bool {
        previous != nil
    }

    /// Estimated total number of pages
    var estimatedTotalPages: Int? {
        guard currentPage != nil else { return nil }
        let pageSize = results.count
        guard pageSize > 0 else { return nil }
        return (count + pageSize - 1) / pageSize
    }

    /// Progress through all results (0.0 to 1.0)
    var progress: Double {
        guard count > 0 else { return 1.0 }
        guard let current = currentPage else { return 0.0 }
        let itemsProcessed = (current - 1) * results.count + results.count
        return min(Double(itemsProcessed) / Double(count), 1.0)
    }
}
