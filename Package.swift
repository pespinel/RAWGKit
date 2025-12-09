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
    targets: [
        .target(
            name: "RAWGKit",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
                .enableUpcomingFeature("ExistentialAny")
            ]
        ),
        .testTarget(
            name: "RAWGKitTests",
            dependencies: ["RAWGKit"],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
                .enableUpcomingFeature("ExistentialAny")
            ]
        ),
    ]
)
