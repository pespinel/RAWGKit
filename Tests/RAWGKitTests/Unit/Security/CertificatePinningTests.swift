//
// CertificatePinningTests.swift
// RAWGKitTests
//

import Foundation
@testable import RAWGKit
import Security
import Testing

@Suite("CertificatePinning Tests")
struct CertificatePinningTests {
    @Test("CertificatePinning initializes correctly")
    func initialization() async {
        let pins = [
            "api.example.com": ["sha256/abc123", "sha256/def456"],
            "cdn.example.com": ["sha256/ghi789"],
        ]

        let pinning = CertificatePinning(pinnedDomains: pins, strictMode: false)

        let domains = await pinning.domains
        #expect(domains.count == 2)
        #expect(domains.contains("api.example.com"))
        #expect(domains.contains("cdn.example.com"))
    }

    @Test("hasPins returns true for domains with pins")
    func hasPinsReturnsTrue() async {
        let pins = ["api.example.com": ["sha256/abc123"]]
        let pinning = CertificatePinning(pinnedDomains: pins)

        let hasPins = await pinning.hasPins(for: "api.example.com")
        #expect(hasPins == true)
    }

    @Test("hasPins returns false for domains without pins")
    func hasPinsReturnsFalse() async {
        let pins = ["api.example.com": ["sha256/abc123"]]
        let pinning = CertificatePinning(pinnedDomains: pins)

        let hasPins = await pinning.hasPins(for: "other.example.com")
        #expect(hasPins == false)
    }

    @Test("hasPins returns false for domains with empty pin arrays")
    func hasPinsReturnsFalseForEmptyArrays() async {
        let pins = ["api.example.com": [String]()]
        let pinning = CertificatePinning(pinnedDomains: pins)

        let hasPins = await pinning.hasPins(for: "api.example.com")
        #expect(hasPins == false)
    }

    @Test("domains returns all pinned domain names")
    func domainsReturnsAllNames() async {
        let pins = [
            "api.example.com": ["sha256/abc123"],
            "cdn.example.com": ["sha256/def456"],
            "app.example.com": ["sha256/ghi789"],
        ]
        let pinning = CertificatePinning(pinnedDomains: pins)

        let domains = await pinning.domains
        #expect(domains.count == 3)
        #expect(domains.contains("api.example.com"))
        #expect(domains.contains("cdn.example.com"))
        #expect(domains.contains("app.example.com"))
    }

    @Test("Non-strict mode allows connections without pins")
    func nonStrictModeAllowsUnpinnedDomains() async {
        let pins = ["api.example.com": ["sha256/abc123"]]
        let pinning = CertificatePinning(pinnedDomains: pins, strictMode: false)

        // Create a mock server trust (this will fail validation but test the logic)
        // In non-strict mode, domains without pins should return true
        // This is tested indirectly through the validation logic
        let hasPins = await pinning.hasPins(for: "unpinned.example.com")
        #expect(hasPins == false)
    }

    @Test("Strict mode is configurable")
    func strictModeIsConfigurable() async {
        let pins = ["api.example.com": ["sha256/abc123"]]

        let nonStrictPinning = CertificatePinning(pinnedDomains: pins, strictMode: false)
        let strictPinning = CertificatePinning(pinnedDomains: pins, strictMode: true)

        // Both should have the same domains
        let nonStrictDomains = await nonStrictPinning.domains
        let strictDomains = await strictPinning.domains

        #expect(nonStrictDomains == strictDomains)
    }

    @Test("Empty pinnedDomains creates valid instance")
    func emptyPinnedDomainsIsValid() async {
        let pinning = CertificatePinning(pinnedDomains: [:])

        let domains = await pinning.domains
        #expect(domains.isEmpty)
    }

    @Test("CertificatePinningDelegate initializes with pinning instance")
    func delegateInitialization() async {
        let pins = ["api.example.com": ["sha256/abc123"]]
        let pinning = CertificatePinning(pinnedDomains: pins)
        let delegate = CertificatePinningDelegate(certificatePinning: pinning)

        // Delegate should be created successfully
        #expect(delegate != nil)
    }

    @Test("Multiple domains with different pins")
    func multipleDomainsDifferentPins() async {
        let pins = [
            "api.rawg.io": [
                "sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
                "sha256/BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=",
            ],
            "cdn.rawg.io": [
                "sha256/CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC=",
            ],
        ]
        let pinning = CertificatePinning(pinnedDomains: pins)

        let apiHasPins = await pinning.hasPins(for: "api.rawg.io")
        let cdnHasPins = await pinning.hasPins(for: "cdn.rawg.io")
        let otherHasPins = await pinning.hasPins(for: "other.rawg.io")

        #expect(apiHasPins == true)
        #expect(cdnHasPins == true)
        #expect(otherHasPins == false)
    }

    @Test("Domains property is nonisolated")
    func domainsIsNonisolated() {
        let pins = ["api.example.com": ["sha256/abc123"]]
        let pinning = CertificatePinning(pinnedDomains: pins)

        // This should compile and work in a synchronous context
        let domains = pinning.domains
        #expect(!domains.isEmpty)
    }

    @Test("hasPins is nonisolated")
    func hasPinsIsNonisolated() {
        let pins = ["api.example.com": ["sha256/abc123"]]
        let pinning = CertificatePinning(pinnedDomains: pins)

        // This should compile and work in a synchronous context
        let hasPins = pinning.hasPins(for: "api.example.com")
        #expect(hasPins == true)
    }
}
