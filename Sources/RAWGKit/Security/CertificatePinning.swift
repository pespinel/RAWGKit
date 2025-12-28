//
// CertificatePinning.swift
// RAWGKit
//

import Foundation
@preconcurrency import Security

/// Certificate pinning utility for enhanced network security.
///
/// `CertificatePinning` implements SSL/TLS certificate pinning to protect against
/// man-in-the-middle attacks by validating that the server's certificate matches
/// a known trusted certificate or public key.
///
/// ## How It Works
///
/// Certificate pinning validates the server's certificate chain against pre-defined
/// public keys or certificates embedded in the app. This prevents attackers from
/// using fraudulently issued certificates.
///
/// ## Usage
///
/// ```swift
/// // Pin by domain with public key hashes
/// let pinning = CertificatePinning(
///     pinnedDomains: [
///         "api.rawg.io": [
///             "sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
///             "sha256/BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB="
///         ]
///     ]
/// )
///
/// // Use with URLSession
/// let delegate = pinning.sessionDelegate()
/// let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
/// ```
///
/// - Important: Certificate pinning requires careful maintenance. Certificate updates
///   must be coordinated with app updates to avoid breaking connectivity.
///
/// - Note: For production use, obtain public key hashes from your server's certificates
///   using tools like OpenSSL or online certificate inspection tools.
public actor CertificatePinning {
    /// Dictionary mapping domain names to arrays of pinned public key hashes (SHA-256, Base64-encoded)
    private let pinnedDomains: [String: [String]]

    /// Whether to enforce strict pinning (fail if no pins are defined for a domain)
    private let strictMode: Bool

    /// Creates a new certificate pinning instance.
    ///
    /// - Parameters:
    ///   - pinnedDomains: Dictionary mapping domain names to their pinned public key hashes.
    ///     Keys should be domain names (e.g., "api.rawg.io") and values should be arrays of
    ///     SHA-256 public key hashes in Base64 encoding with "sha256/" prefix.
    ///   - strictMode: If `true`, validation fails for domains without pins. If `false`,
    ///     domains without pins use standard certificate validation. Defaults to `false`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let pinning = CertificatePinning(
    ///     pinnedDomains: [
    ///         "api.rawg.io": [
    ///             "sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
    ///         ]
    ///     ],
    ///     strictMode: true
    /// )
    /// ```
    public init(pinnedDomains: [String: [String]], strictMode: Bool = false) {
        self.pinnedDomains = pinnedDomains
        self.strictMode = strictMode
    }

    /// Validates a server trust against pinned certificates.
    ///
    /// This method is called during the SSL/TLS handshake to validate the server's
    /// certificate chain. It extracts public keys from the server's certificates and
    /// compares them against the pinned hashes.
    ///
    /// - Parameters:
    ///   - serverTrust: The server trust to validate
    ///   - domain: The domain being connected to
    /// - Returns: `true` if validation succeeds, `false` otherwise
    nonisolated public func validate(serverTrust: SecTrust, for domain: String) -> Bool {
        // Get pins for this domain
        guard let pins = pinnedDomains[domain] else {
            // No pins defined for this domain
            return !strictMode // In non-strict mode, allow connections without pins
        }

        // Extract certificates from server trust
        guard let certificates = extractCertificates(from: serverTrust) else {
            return false
        }

        // Extract public key hashes from certificates
        for certificate in certificates {
            if let publicKeyHash = publicKeyHash(for: certificate) {
                let formattedHash = "sha256/\(publicKeyHash)"
                if pins.contains(formattedHash) {
                    return true // Found a matching pin
                }
            }
        }

        return false // No matching pins found
    }

    /// Extracts certificates from a SecTrust object.
    ///
    /// - Parameter serverTrust: The server trust to extract certificates from
    /// - Returns: Array of SecCertificate objects, or nil if extraction fails
    nonisolated private func extractCertificates(from serverTrust: SecTrust) -> [SecCertificate]? {
        var certificates: [SecCertificate] = []

        #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
            if #available(iOS 15.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *) {
                // iOS 15+ / modern API
                guard let certificateChain = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate] else {
                    return nil
                }
                certificates = certificateChain
            } else {
                // iOS 14 and earlier
                let count = SecTrustGetCertificateCount(serverTrust)
                for index in 0 ..< count {
                    if let certificate = SecTrustGetCertificateAtIndex(serverTrust, index) {
                        certificates.append(certificate)
                    }
                }
            }
        #elseif os(macOS)
            if #available(macOS 12.0, *) {
                // macOS 12+ / modern API
                guard let certificateChain = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate] else {
                    return nil
                }
                certificates = certificateChain
            } else {
                // macOS 11 and earlier
                let count = SecTrustGetCertificateCount(serverTrust)
                for index in 0 ..< count {
                    if let certificate = SecTrustGetCertificateAtIndex(serverTrust, index) {
                        certificates.append(certificate)
                    }
                }
            }
        #endif

        return certificates.isEmpty ? nil : certificates
    }

    /// Computes the SHA-256 hash of a certificate's public key in Base64 encoding.
    ///
    /// - Parameter certificate: The certificate to hash
    /// - Returns: Base64-encoded SHA-256 hash of the public key, or nil if extraction fails
    nonisolated private func publicKeyHash(for certificate: SecCertificate) -> String? {
        guard let publicKey = SecCertificateCopyKey(certificate) else {
            return nil
        }

        guard let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, nil) as Data? else {
            return nil
        }

        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        publicKeyData.withUnsafeBytes { buffer in
            _ = CC_SHA256(buffer.baseAddress, CC_LONG(publicKeyData.count), &hash)
        }

        let hashData = Data(hash)
        return hashData.base64EncodedString()
    }

    /// Returns the list of pinned domains.
    ///
    /// - Returns: Array of domain names that have certificate pins configured
    nonisolated public var domains: [String] {
        Array(pinnedDomains.keys)
    }

    /// Checks if a domain has pins configured.
    ///
    /// - Parameter domain: The domain to check
    /// - Returns: `true` if the domain has one or more pins configured
    nonisolated public func hasPins(for domain: String) -> Bool {
        pinnedDomains[domain]?.isEmpty == false
    }
}

// MARK: - URLSessionDelegate Support

/// URLSession delegate that performs certificate pinning validation.
///
/// This delegate integrates `CertificatePinning` with `URLSession` to validate
/// server certificates during the TLS handshake.
public final class CertificatePinningDelegate: NSObject, URLSessionDelegate {
    private let certificatePinning: CertificatePinning

    /// Creates a new delegate with the given certificate pinning configuration.
    ///
    /// - Parameter certificatePinning: The certificate pinning instance to use for validation
    public init(certificatePinning: CertificatePinning) {
        self.certificatePinning = certificatePinning
        super.init()
    }

    public func urlSession(
        _: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping @Sendable (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.performDefaultHandling, nil)
            return
        }

        let domain = challenge.protectionSpace.host

        // Validate synchronously (nonisolated method)
        let isValid = certificatePinning.validate(serverTrust: serverTrust, for: domain)

        if isValid {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}

// MARK: - CommonCrypto Bridging

#if canImport(CommonCrypto)
    import CommonCrypto
#else
    // For platforms without CommonCrypto, provide stub constants
    // swiftlint:disable:next identifier_name
    private let CC_SHA256_DIGEST_LENGTH: Int32 = 32
    @available(*, unavailable, message: "CommonCrypto not available on this platform")
    private func CC_SHA256(
        _: UnsafeRawPointer?,
        _: CC_LONG,
        _: UnsafeMutablePointer<UInt8>?
    ) -> UnsafeMutablePointer<UInt8>? {
        nil
    }
#endif
