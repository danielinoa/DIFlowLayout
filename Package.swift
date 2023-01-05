// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DIFlowLayout",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(name: "DIFlowLayout", targets: ["DIFlowLayout"]),
    ],
    dependencies: [
        .package(url: "https://github.com/danielinoa/DIFlowLayoutEngine", branch: "main")
    ],
    targets: [
        .target(name: "DIFlowLayout", dependencies: ["DIFlowLayoutEngine"]),
        .testTarget(name: "DIFlowLayoutTests", dependencies: ["DIFlowLayout"]),
    ]
)
