# Security

Protect your app and users with RAWGKit's comprehensive security features.

## Overview

RAWGKit includes multiple layers of security to protect your application and user data. This guide covers API key storage, certificate pinning, TLS enforcement, and input validation.

## API Key Security

### Keychain Storage

Never hardcode API keys in your app. Use the iOS Keychain for secure storage:

```swift
import RAWGKit

// Save API key to Keychain
let client = RAWGClient(apiKey: "YOUR_API_KEY_HERE")
try await client.saveAPIKeyToKeychain()

// Later, initialize from Keychain
let client = try await RAWGClient.initWithKeychain()
```

### Environment Variables (Development)

During development, use environment variables or `.xcconfig` files:

```swift
// In your .xcconfig file
RAWG_API_KEY = your_api_key_here

// In your code
guard let apiKey = ProcessInfo.processInfo.environment["RAWG_API_KEY"] else {
    fatalError("API key not found")
}

let client = RAWGClient(apiKey: apiKey)
```

### Keychain Operations

The ``KeychainManager`` provides thread-safe Keychain operations:

```swift
// Save to Keychain
try await KeychainManager.shared.save("YOUR_API_KEY_HERE", forKey: "rawg_api_key")

// Load from Keychain
let apiKey = try await KeychainManager.shared.load(forKey: "rawg_api_key")

// Delete from Keychain
try await KeychainManager.shared.delete(forKey: "rawg_api_key")

// Check if key exists
let exists = try await KeychainManager.shared.exists(forKey: "rawg_api_key")
```

## Certificate Pinning

Prevent man-in-the-middle attacks with SSL certificate pinning.

### What is Certificate Pinning?

Certificate pinning validates that the server's SSL certificate matches a known, trusted certificate. This prevents attackers from intercepting HTTPS traffic even with a compromised Certificate Authority.

### Enabling Certificate Pinning

```swift
import RAWGKit

// Create certificate pinning configuration
let pinning = CertificatePinning()

// Add pinned public key hash for your domain
await pinning.addPin(
    forDomain: "api.rawg.io",
    publicKeyHash: "sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
)

// Create network manager with pinning
let networkManager = NetworkManager(
    apiKey: "YOUR_API_KEY_HERE",
    certificatePinning: pinning
)

let client = RAWGClient(networkManager: networkManager)
```

### Obtaining Public Key Hashes

Extract the public key hash from a server certificate:

```bash
# macOS/Linux
openssl s_client -connect api.rawg.io:443 | \
openssl x509 -pubkey -noout | \
openssl pkey -pubin -outform der | \
openssl dgst -sha256 -binary | \
openssl enc -base64
```

### Pinning Modes

```swift
// Strict mode (default): Connection fails if validation fails
await pinning.setStrictMode(true)

// Non-strict mode: Logs warning but allows connection
// (Useful for testing/debugging)
await pinning.setStrictMode(false)
```

### Best Practices

1. **Pin Multiple Hashes**: Include backup keys in case of certificate rotation
2. **Monitor Expiration**: Track certificate expiration dates
3. **Test Thoroughly**: Verify pinning works before deploying to production
4. **Plan for Updates**: Have a strategy for updating pins via app updates

### Example with Multiple Pins

```swift
let pinning = CertificatePinning()

// Primary certificate
await pinning.addPin(
    forDomain: "api.rawg.io",
    publicKeyHash: "sha256/PRIMARY_KEY_HASH_HERE"
)

// Backup certificate (for rotation)
await pinning.addPin(
    forDomain: "api.rawg.io",
    publicKeyHash: "sha256/BACKUP_KEY_HASH_HERE"
)

// Remove a pin if needed
await pinning.removePin(
    forDomain: "api.rawg.io",
    publicKeyHash: "sha256/OLD_KEY_HASH_HERE"
)

// Clear all pins for a domain
await pinning.clearPins(forDomain: "api.rawg.io")
```

## TLS Version Enforcement

RAWGKit enforces modern TLS versions to protect against protocol downgrade attacks.

### Automatic TLS Enforcement

The ``NetworkManager`` automatically enforces:
- **Minimum**: TLS 1.2
- **Maximum**: TLS 1.3
- **Rejected**: TLS 1.0, TLS 1.1 (deprecated and insecure)

This is configured automatically and requires no additional setup:

```swift
// TLS enforcement is automatic
let client = RAWGClient(apiKey: "YOUR_API_KEY_HERE")

// All connections use TLS 1.2 or 1.3 only
let games = try await client.fetchGames()
```

### Why TLS Enforcement Matters

- **TLS 1.0/1.1 are deprecated** and contain known vulnerabilities
- **Prevents downgrade attacks** where attackers force use of older protocols
- **Industry standard** - major platforms have deprecated TLS 1.0/1.1
- **Compliance** - many security standards require TLS 1.2+

## Input Validation

RAWGKit validates all input parameters to prevent injection attacks and malformed requests.

### Automatic Validation

The ``InputValidator`` automatically validates:
- Search queries (XSS prevention)
- Page numbers (range validation)
- Resource IDs (format validation)
- Slugs (SQL injection prevention)
- Dates (format validation)
- Ordering parameters (whitelist validation)

```swift
// All these inputs are validated automatically
let games = try await client.fetchGames(
    search: "user input",      // XSS prevention
    page: 1,                   // Range validation (1-999999)
    pageSize: 20,              // Range validation (1-40)
    ordering: "-rating"        // Whitelist validation
)
```

### Validation Rules

The following rules are enforced:

**Search Queries**:
- Maximum 100 characters
- HTML tags removed
- Special characters sanitized
- Prevents XSS attacks

**Page Numbers**:
- Must be positive integers
- Range: 1 to 999,999
- Prevents resource exhaustion

**Page Size**:
- Range: 1 to 40 (RAWG API limit)
- Prevents excessive data transfer

**Resource IDs**:
- Must be positive integers
- Prevents SQL injection

**Slugs**:
- Alphanumeric, hyphens, underscores only
- Prevents directory traversal and injection

**Dates**:
- ISO 8601 format (YYYY-MM-DD)
- Validates actual dates

### Manual Validation

Use the ``InputValidator`` directly for custom validation:

```swift
import RAWGKit

// Validate search query
if InputValidator.isValidSearch("user input") {
    // Safe to use
}

// Validate page number
if InputValidator.isValidPage(1) {
    // Valid page number
}

// Validate slug
if InputValidator.isValidSlug("game-slug") {
    // Safe slug
}

// Validate date
if InputValidator.isValidDate("2024-01-01") {
    // Valid ISO 8601 date
}

// Sanitize search query
let sanitized = InputValidator.sanitizeSearchQuery("unsafe<script>input")
// Returns: "unsafeinput"
```

## Production Logging

RAWGKit sanitizes logs in production to prevent sensitive data exposure.

### Debug vs Production Logging

```swift
// DEBUG builds: Detailed logging with request/response data
// - Full URL with parameters
// - Response bodies
// - Detailed error messages

// RELEASE builds: Generic logging only
// - No sensitive data
// - Generic error messages
// - No API key exposure
```

### Log Levels

RAWGKit uses `os.Logger` with appropriate log levels:

```swift
// INFO: General information (API calls, cache hits)
// ERROR: Errors with recovery suggestions
// DEBUG: Detailed debugging (DEBUG builds only)
// FAULT: Critical errors
```

## Security Checklist

Before deploying to production:

- [ ] Store API keys in Keychain, not hardcoded
- [ ] Remove API keys from source control
- [ ] Enable certificate pinning for production
- [ ] Test certificate pinning in staging first
- [ ] Verify TLS enforcement is working
- [ ] Review logs for sensitive data leakage
- [ ] Test input validation with malicious inputs
- [ ] Implement rate limiting in your app
- [ ] Monitor for security updates
- [ ] Plan for certificate rotation

## Common Security Mistakes

### ❌ Don't Hardcode API Keys

```swift
// BAD: API key in source code
let client = RAWGClient(apiKey: "hardcoded_api_key_here")
```

```swift
// GOOD: Load from Keychain
let client = try await RAWGClient.initWithKeychain()
```

### ❌ Don't Commit API Keys

```bash
# Add to .gitignore
*.xcconfig
*.env
Secrets/
```

### ❌ Don't Disable Security Features

```swift
// BAD: Disabling certificate validation
// NEVER do this in production!
```

### ❌ Don't Trust User Input

```swift
// BAD: Using user input directly
let games = try await client.fetchGames(search: userInput)

// GOOD: Input is validated automatically by RAWGKit
// But be aware of the validation that happens
```

## Compliance

RAWGKit helps you meet security compliance requirements:

- **CWE-532**: Information Exposure Through Log Files ✅
- **CWE-20**: Improper Input Validation ✅
- **OWASP Top 10**: Injection Prevention ✅
- **PCI DSS**: TLS 1.2+ Requirement ✅
- **GDPR**: Secure Data Storage ✅

## Next Steps

- Review <doc:Performance> for optimization techniques
- Explore <doc:AdvancedFeatures> for complex use cases
- Check the demo app for security implementation examples
