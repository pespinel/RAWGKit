// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "RAWGKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v13),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "RAWGKit",
            targets: ["RAWGKit"]
        ),
    ],
    dependencies: [
        // SwiftLint plugin
        .package(url: "https://github.com/realm/SwiftLint", from: "0.57.0"),
        // SwiftFormat plugin
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.54.0"),
    ],
    targets: [
        .target(
            name: "RAWGKit",
            dependencies: [],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
        .testTarget(
            name: "RAWGKitTests",
            dependencies: ["RAWGKit"],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
    ]
)
