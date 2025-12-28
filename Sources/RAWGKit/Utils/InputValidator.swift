//
// InputValidator.swift
// RAWGKit
//

import Foundation

/// Validates and sanitizes user input to prevent injection attacks and ensure API compliance.
///
/// `InputValidator` provides static methods for validating and sanitizing various types of user input
/// before they are used in API requests. This prevents potential security vulnerabilities such as
/// URL injection, parameter pollution, and malformed requests.
///
/// ## Features
///
/// - **Search Query Validation**: Length and character validation for search strings
/// - **Numeric Range Validation**: Page numbers, page sizes, and rating values
/// - **ID Validation**: Game IDs, creator IDs, and other resource identifiers
/// - **URL Encoding**: Automatic percent-encoding of validated inputs
///
/// ## Usage
///
/// ```swift
/// // Validate search query
/// let query = try InputValidator.validateSearchQuery("The Witcher 3")
///
/// // Validate page parameters
/// let page = try InputValidator.validatePageNumber(1)
/// let pageSize = try InputValidator.validatePageSize(20)
///
/// // Validate rating range
/// let rating = try InputValidator.validateMetacriticScore(85)
/// ```
///
/// - Note: All validation methods throw `NetworkError.apiError` with descriptive messages
///   when validation fails. Always handle these errors appropriately in your application.
public enum InputValidator {
    // MARK: - Search Query Validation

    /// Validates and sanitizes a search query string.
    ///
    /// Ensures the query:
    /// - Is not empty after trimming whitespace
    /// - Does not exceed 100 characters (API limit)
    /// - Contains only alphanumeric characters, spaces, hyphens, and underscores
    /// - Is properly URL-encoded
    ///
    /// - Parameter query: The search query to validate
    /// - Returns: The validated and URL-encoded query string
    /// - Throws: `NetworkError.apiError` if validation fails
    public static func validateSearchQuery(_ query: String) throws -> String {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            throw NetworkError.apiError("Search query cannot be empty")
        }

        guard trimmed.count <= 100 else {
            throw NetworkError.apiError("Search query exceeds maximum length of 100 characters")
        }

        // Allow alphanumerics, spaces, hyphens, underscores, apostrophes, and common punctuation
        let allowedCharacters = CharacterSet.alphanumerics
            .union(.whitespaces)
            .union(CharacterSet(charactersIn: "-_'\":.!?&"))

        guard trimmed.unicodeScalars.allSatisfy({ allowedCharacters.contains($0) }) else {
            throw NetworkError.apiError(
                """
                Search query contains invalid characters. \
                Only letters, numbers, spaces, and common punctuation are allowed
                """
            )
        }

        guard let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw NetworkError.apiError("Failed to encode search query")
        }

        return encoded
    }

    // MARK: - Pagination Validation

    /// Validates a page number for pagination.
    ///
    /// Ensures the page number is within a reasonable range (1 to 10,000).
    ///
    /// - Parameter page: The page number to validate
    /// - Returns: The validated page number
    /// - Throws: `NetworkError.apiError` if the page number is invalid
    public static func validatePageNumber(_ page: Int) throws -> Int {
        guard (1 ... 10000).contains(page) else {
            throw NetworkError.apiError("Page number must be between 1 and 10,000")
        }
        return page
    }

    /// Validates a page size for pagination.
    ///
    /// Ensures the page size is within the API's allowed range (1 to 40).
    ///
    /// - Parameter pageSize: The page size to validate
    /// - Returns: The validated page size
    /// - Throws: `NetworkError.apiError` if the page size is invalid
    public static func validatePageSize(_ pageSize: Int) throws -> Int {
        guard (1 ... 40).contains(pageSize) else {
            throw NetworkError.apiError("Page size must be between 1 and 40")
        }
        return pageSize
    }

    // MARK: - ID Validation

    /// Validates a resource ID (game, creator, developer, etc.).
    ///
    /// Ensures the ID is a positive integer within a reasonable range.
    ///
    /// - Parameter id: The resource ID to validate
    /// - Returns: The validated ID
    /// - Throws: `NetworkError.apiError` if the ID is invalid
    public static func validateResourceID(_ id: Int) throws -> Int {
        guard id > 0, id < Int.max else {
            throw NetworkError.apiError("Resource ID must be a positive integer")
        }
        return id
    }

    /// Validates a slug string (used for developers, publishers, creators, etc.).
    ///
    /// Slugs should only contain lowercase letters, numbers, and hyphens.
    ///
    /// - Parameter slug: The slug string to validate
    /// - Returns: The validated and URL-encoded slug
    /// - Throws: `NetworkError.apiError` if the slug is invalid
    public static func validateSlug(_ slug: String) throws -> String {
        let trimmed = slug.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            throw NetworkError.apiError("Slug cannot be empty")
        }

        guard trimmed.count <= 200 else {
            throw NetworkError.apiError("Slug exceeds maximum length of 200 characters")
        }

        // Slugs typically contain only lowercase letters, numbers, and hyphens
        let slugPattern = "^[a-z0-9-]+$"
        let regex = try? NSRegularExpression(pattern: slugPattern, options: [])
        let range = NSRange(location: 0, length: trimmed.utf16.count)

        guard regex?.firstMatch(in: trimmed, range: range) != nil else {
            throw NetworkError.apiError("Slug must contain only lowercase letters, numbers, and hyphens")
        }

        guard let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw NetworkError.apiError("Failed to encode slug")
        }

        return encoded
    }

    // MARK: - Rating & Score Validation

    /// Validates a Metacritic score.
    ///
    /// Ensures the score is within the valid range (0 to 100).
    ///
    /// - Parameter score: The Metacritic score to validate
    /// - Returns: The validated score
    /// - Throws: `NetworkError.apiError` if the score is invalid
    public static func validateMetacriticScore(_ score: Int) throws -> Int {
        guard (0 ... 100).contains(score) else {
            throw NetworkError.apiError("Metacritic score must be between 0 and 100")
        }
        return score
    }

    // MARK: - Date Validation

    /// Validates a year for date-based queries.
    ///
    /// Ensures the year is within a reasonable range (1970 to 5 years in the future).
    ///
    /// - Parameter year: The year to validate
    /// - Returns: The validated year
    /// - Throws: `NetworkError.apiError` if the year is invalid
    public static func validateYear(_ year: Int) throws -> Int {
        let currentYear = Calendar.current.component(.year, from: Date())
        let maxYear = currentYear + 5

        guard (1970 ... maxYear).contains(year) else {
            throw NetworkError.apiError("Year must be between 1970 and \(maxYear)")
        }

        return year
    }

    /// Validates a date string in ISO 8601 format (YYYY-MM-DD).
    ///
    /// - Parameter dateString: The date string to validate
    /// - Returns: The validated date string
    /// - Throws: `NetworkError.apiError` if the date format is invalid
    public static func validateDateString(_ dateString: String) throws -> String {
        let trimmed = dateString.trimmingCharacters(in: .whitespacesAndNewlines)

        // Check format: YYYY-MM-DD
        let datePattern = "^\\d{4}-\\d{2}-\\d{2}$"
        let regex = try? NSRegularExpression(pattern: datePattern, options: [])
        let range = NSRange(location: 0, length: trimmed.utf16.count)

        guard regex?.firstMatch(in: trimmed, range: range) != nil else {
            throw NetworkError.apiError("Date must be in YYYY-MM-DD format")
        }

        // Verify it's a valid date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard formatter.date(from: trimmed) != nil else {
            throw NetworkError.apiError("Invalid date: \(trimmed)")
        }

        return trimmed
    }

    // MARK: - Array Validation

    /// Validates an array of integers (used for platforms, genres, stores, etc.).
    ///
    /// Ensures:
    /// - Array is not empty
    /// - Does not exceed a reasonable size
    /// - All IDs are positive
    ///
    /// - Parameter ids: The array of IDs to validate
    /// - Returns: The validated array of IDs
    /// - Throws: `NetworkError.apiError` if validation fails
    public static func validateIDArray(_ ids: [Int]) throws -> [Int] {
        guard !ids.isEmpty else {
            throw NetworkError.apiError("ID array cannot be empty")
        }

        guard ids.count <= 50 else {
            throw NetworkError.apiError("ID array cannot exceed 50 items")
        }

        guard ids.allSatisfy({ $0 > 0 }) else {
            throw NetworkError.apiError("All IDs must be positive integers")
        }

        return ids
    }

    /// Validates a comma-separated string of values.
    ///
    /// - Parameter values: The comma-separated string to validate
    /// - Returns: The validated string
    /// - Throws: `NetworkError.apiError` if validation fails
    public static func validateCommaSeparatedValues(_ values: String) throws -> String {
        let trimmed = values.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            throw NetworkError.apiError("Comma-separated values cannot be empty")
        }

        let components = trimmed.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }

        guard components.count <= 50 else {
            throw NetworkError.apiError("Comma-separated values cannot exceed 50 items")
        }

        // Ensure valid characters (alphanumerics, hyphens, underscores)
        let allowedCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-_,"))

        guard trimmed.unicodeScalars.allSatisfy({ allowedCharacters.contains($0) }) else {
            throw NetworkError.apiError("Comma-separated values contain invalid characters")
        }

        guard let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw NetworkError.apiError("Failed to encode comma-separated values")
        }

        return encoded
    }
}
