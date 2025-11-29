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
        // SwiftLint is kept as a dependency but the plugin is disabled
        // TODO: Re‑enable SwiftLintBuildToolPlugin when the Swift 6.x / SPM
        //       bug “a prebuild command cannot use executables built from source”
        //       is fixed in SwiftLint / SwiftPM.
        .package(url: "https://github.com/realm/SwiftLint", from: "0.57.0"),

        // SwiftFormat plugin (keep or remove depending on whether it causes issues)
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.54.0"),
    ],
    targets: [
        .target(
            name: "RAWGKit",
            dependencies: []
            // plugins: [
            //     .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            // ]
        ),
        .testTarget(
            name: "RAWGKitTests",
            dependencies: ["RAWGKit"]
            // plugins: [
            //     .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            // ]
        ),
    ]
)
