// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "RAWGKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v13),
        .watchOS(.v8),
        .tvOS(.v15),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "RAWGKit",
            targets: ["RAWGKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "RAWGKit",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
                .enableUpcomingFeature("ExistentialAny"),
                .unsafeFlags(["-Xfrontend", "-disable-round-trip-debug-types"])
            ]
        ),
        .testTarget(
            name: "RAWGKitTests",
            dependencies: ["RAWGKit"],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
                .enableUpcomingFeature("ExistentialAny"),
                .unsafeFlags(["-Xfrontend", "-disable-round-trip-debug-types"])
            ]
        ),
    ]
)
