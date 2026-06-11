// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "DIFlowLayout",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .macCatalyst(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "DIFlowLayout", targets: ["DIFlowLayout"]),
    ],
    dependencies: [
        .package(url: "https://github.com/danielinoa/DIFlowLayoutEngine", from: "1.0.0")
    ],
    targets: [
        .target(name: "DIFlowLayout", dependencies: ["DIFlowLayoutEngine"]),
        .testTarget(name: "DIFlowLayoutTests", dependencies: ["DIFlowLayout"]),
    ]
)
