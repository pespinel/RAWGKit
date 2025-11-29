// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "RAWGKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15)
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
            dependencies: []
        ),
        .testTarget(
            name: "RAWGKitTests",
            dependencies: ["RAWGKit"]
        ),
    ]
)
