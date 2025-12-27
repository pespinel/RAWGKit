//
// MetadataModelsTests.swift
// RAWGKitTests
//

import Foundation
@testable import RAWGKit
import Testing

@Suite("Metadata Models Tests")
struct MetadataModelsTests {
    // MARK: - Requirements Tests

    @Test("Requirements initializes with both fields")
    func requirementsFullInitialization() {
        let requirements = Requirements(
            minimum: "OS: Windows 10\nCPU: Intel Core i5\nRAM: 8GB",
            recommended: "OS: Windows 11\nCPU: Intel Core i7\nRAM: 16GB"
        )

        #expect(requirements.minimum == "OS: Windows 10\nCPU: Intel Core i5\nRAM: 8GB")
        #expect(requirements.recommended == "OS: Windows 11\nCPU: Intel Core i7\nRAM: 16GB")
    }

    @Test("Requirements initializes with only minimum")
    func requirementsMinimumOnly() {
        let requirements = Requirements(minimum: "OS: Windows 10")

        #expect(requirements.minimum == "OS: Windows 10")
        #expect(requirements.recommended == nil)
    }

    @Test("Requirements initializes with only recommended")
    func requirementsRecommendedOnly() {
        let requirements = Requirements(recommended: "OS: Windows 11")

        #expect(requirements.minimum == nil)
        #expect(requirements.recommended == "OS: Windows 11")
    }

    @Test("Requirements initializes with nil values")
    func requirementsNilValues() {
        let requirements = Requirements()

        #expect(requirements.minimum == nil)
        #expect(requirements.recommended == nil)
    }

    @Test("Requirements decodes from JSON")
    func requirementsDecodesFromJSON() throws {
        let json = Data("""
        {
            "minimum": "OS: Windows 10\\nCPU: Intel Core i5",
            "recommended": "OS: Windows 11\\nCPU: Intel Core i7"
        }
        """.utf8)

        let decoder = JSONDecoder()
        let requirements = try decoder.decode(Requirements.self, from: json)

        #expect(requirements.minimum != nil)
        #expect(requirements.recommended != nil)
    }

    @Test("Requirements handles empty strings")
    func requirementsEmptyStrings() throws {
        let json = Data("""
        {
            "minimum": "",
            "recommended": ""
        }
        """.utf8)

        let decoder = JSONDecoder()
        let requirements = try decoder.decode(Requirements.self, from: json)

        #expect(requirements.minimum?.isEmpty == true)
        #expect(requirements.recommended?.isEmpty == true)
    }

    @Test("Requirements conforms to Hashable")
    func requirementsHashable() {
        let req1 = Requirements(minimum: "Min", recommended: "Rec")
        let req2 = Requirements(minimum: "Min", recommended: "Rec")
        let req3 = Requirements(minimum: "Different", recommended: "Rec")

        #expect(req1.hashValue == req2.hashValue)
        #expect(req1.hashValue != req3.hashValue)
    }

    // MARK: - PlatformInfo Tests

    @Test("PlatformInfo initializes with all fields")
    func platformInfoFullInitialization() {
        let platform = Platform(id: 4, name: "PC", slug: "pc")
        let requirements = Requirements(
            minimum: "OS: Windows 10",
            recommended: "OS: Windows 11"
        )

        let platformInfo = PlatformInfo(
            platform: platform,
            releasedAt: "2024-01-15",
            requirements: requirements
        )

        #expect(platformInfo.platform.id == 4)
        #expect(platformInfo.platform.name == "PC")
        #expect(platformInfo.releasedAt == "2024-01-15")
        #expect(platformInfo.requirements?.minimum == "OS: Windows 10")
    }

    @Test("PlatformInfo initializes with minimal fields")
    func platformInfoMinimalInitialization() {
        let platform = Platform(id: 18, name: "PlayStation 4", slug: "playstation4")
        let platformInfo = PlatformInfo(platform: platform)

        #expect(platformInfo.platform.id == 18)
        #expect(platformInfo.platform.name == "PlayStation 4")
        #expect(platformInfo.releasedAt == nil)
        #expect(platformInfo.requirements == nil)
    }

    @Test("PlatformInfo id derived from platform")
    func platformInfoDerivedId() {
        let platform = Platform(id: 7, name: "Nintendo Switch", slug: "nintendo-switch")
        let platformInfo = PlatformInfo(platform: platform)

        #expect(platformInfo.id == 7)
        #expect(platformInfo.id == platform.id)
    }

    @Test("PlatformInfo decodes from JSON with snake_case")
    func platformInfoDecodesFromJSON() throws {
        let json = Data("""
        {
            "platform": {
                "id": 4,
                "name": "PC",
                "slug": "pc"
            },
            "released_at": "2024-01-15",
            "requirements": {
                "minimum": "OS: Windows 10"
            }
        }
        """.utf8)

        let decoder = JSONDecoder()
        let platformInfo = try decoder.decode(PlatformInfo.self, from: json)

        #expect(platformInfo.platform.id == 4)
        #expect(platformInfo.releasedAt == "2024-01-15")
        #expect(platformInfo.requirements?.minimum == "OS: Windows 10")
    }

    @Test("PlatformInfo handles missing optional fields")
    func platformInfoMissingOptionalFields() throws {
        let json = Data("""
        {
            "platform": {
                "id": 1,
                "name": "Xbox One",
                "slug": "xbox-one"
            }
        }
        """.utf8)

        let decoder = JSONDecoder()
        let platformInfo = try decoder.decode(PlatformInfo.self, from: json)

        #expect(platformInfo.platform.id == 1)
        #expect(platformInfo.releasedAt == nil)
        #expect(platformInfo.requirements == nil)
    }

    @Test("PlatformInfo conforms to Hashable")
    func platformInfoHashable() {
        let platform1 = Platform(id: 4, name: "PC", slug: "pc")
        let platform2 = Platform(id: 4, name: "PC", slug: "pc")
        let platform3 = Platform(id: 18, name: "PS4", slug: "ps4")

        let info1 = PlatformInfo(platform: platform1)
        let info2 = PlatformInfo(platform: platform2)
        let info3 = PlatformInfo(platform: platform3)

        #expect(info1.hashValue == info2.hashValue)
        #expect(info1.hashValue != info3.hashValue)
    }

    // MARK: - ParentPlatform Tests

    @Test("ParentPlatform initializes with all fields")
    func parentPlatformFullInitialization() {
        let ps4 = Platform(id: 18, name: "PlayStation 4", slug: "playstation4")
        let ps5 = Platform(id: 187, name: "PlayStation 5", slug: "playstation5")

        let parentPlatform = ParentPlatform(
            id: 2,
            name: "PlayStation",
            slug: "playstation",
            platforms: [ps4, ps5]
        )

        #expect(parentPlatform.id == 2)
        #expect(parentPlatform.name == "PlayStation")
        #expect(parentPlatform.slug == "playstation")
        #expect(parentPlatform.platforms?.count == 2)
        #expect(parentPlatform.platforms?.first?.id == 18)
    }

    @Test("ParentPlatform initializes with minimal fields")
    func parentPlatformMinimalInitialization() {
        let parentPlatform = ParentPlatform(
            id: 1,
            name: "PC",
            slug: "pc"
        )

        #expect(parentPlatform.id == 1)
        #expect(parentPlatform.name == "PC")
        #expect(parentPlatform.slug == "pc")
        #expect(parentPlatform.platforms == nil)
    }

    @Test("ParentPlatform decodes from JSON")
    func parentPlatformDecodesFromJSON() throws {
        let json = Data("""
        {
            "id": 2,
            "name": "PlayStation",
            "slug": "playstation",
            "platforms": [
                {
                    "id": 18,
                    "name": "PlayStation 4",
                    "slug": "playstation4"
                },
                {
                    "id": 187,
                    "name": "PlayStation 5",
                    "slug": "playstation5"
                }
            ]
        }
        """.utf8)

        let decoder = JSONDecoder()
        let parentPlatform = try decoder.decode(ParentPlatform.self, from: json)

        #expect(parentPlatform.id == 2)
        #expect(parentPlatform.name == "PlayStation")
        #expect(parentPlatform.platforms?.count == 2)
    }

    @Test("ParentPlatform handles empty platforms array")
    func parentPlatformEmptyPlatformsArray() throws {
        let json = Data("""
        {
            "id": 1,
            "name": "PC",
            "slug": "pc",
            "platforms": []
        }
        """.utf8)

        let decoder = JSONDecoder()
        let parentPlatform = try decoder.decode(ParentPlatform.self, from: json)

        #expect(parentPlatform.platforms?.isEmpty == true)
    }

    @Test("ParentPlatform conforms to Hashable")
    func parentPlatformHashable() {
        let platform = Platform(id: 4, name: "PC", slug: "pc")
        let parent1 = ParentPlatform(id: 1, name: "PC", slug: "pc", platforms: [platform])
        let parent2 = ParentPlatform(id: 1, name: "PC", slug: "pc", platforms: [platform])
        let parent3 = ParentPlatform(id: 2, name: "PlayStation", slug: "playstation")

        #expect(parent1.hashValue == parent2.hashValue)
        #expect(parent1.hashValue != parent3.hashValue)
    }

    // MARK: - Edge Cases

    @Test("Requirements handles very long text")
    func requirementsLongText() {
        let longText = String(repeating: "A", count: 10000)
        let requirements = Requirements(minimum: longText)

        #expect(requirements.minimum?.count == 10000)
    }

    @Test("Requirements handles special characters")
    func requirementsSpecialCharacters() {
        let requirements = Requirements(
            minimum: "OS: Windows™ 10 © 2024\nCPU: Intel® Core™ i5",
            recommended: "GPU: NVIDIA® GeForce® RTX™ 4070"
        )

        #expect(requirements.minimum?.contains("™") == true)
        #expect(requirements.minimum?.contains("©") == true)
        #expect(requirements.recommended?.contains("®") == true)
    }

    @Test("PlatformInfo handles future release dates")
    func platformInfoFutureReleaseDate() {
        let platform = Platform(id: 1, name: "Test", slug: "test")
        let platformInfo = PlatformInfo(
            platform: platform,
            releasedAt: "2030-12-31"
        )

        #expect(platformInfo.releasedAt == "2030-12-31")
    }

    @Test("PlatformInfo handles past release dates")
    func platformInfoPastReleaseDate() {
        let platform = Platform(id: 1, name: "Retro", slug: "retro")
        let platformInfo = PlatformInfo(
            platform: platform,
            releasedAt: "1990-01-01"
        )

        #expect(platformInfo.releasedAt == "1990-01-01")
    }

    @Test("ParentPlatform handles single child platform")
    func parentPlatformSingleChild() {
        let pc = Platform(id: 4, name: "PC", slug: "pc")
        let parentPlatform = ParentPlatform(
            id: 1,
            name: "PC",
            slug: "pc",
            platforms: [pc]
        )

        #expect(parentPlatform.platforms?.count == 1)
    }

    @Test("ParentPlatform handles many child platforms")
    func parentPlatformManyChildren() {
        let platforms = (1 ... 10).map { Platform(id: $0, name: "Platform \($0)", slug: "platform-\($0)") }
        let parentPlatform = ParentPlatform(
            id: 1,
            name: "Multi",
            slug: "multi",
            platforms: platforms
        )

        #expect(parentPlatform.platforms?.count == 10)
    }
}
