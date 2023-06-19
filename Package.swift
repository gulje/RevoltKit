// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RevoltKit",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "RevoltKit",
            targets: ["RevoltKit"]),
        .library(
            name: "RevoltKitCore",
            targets: ["RevoltKitCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "RevoltKit",
            dependencies: [
                .target(name: "RevoltKitCore"),
                .product(name: "Logging", package: "swift-log")
            ]),
        .target(
            name: "RevoltKitCore"),
    ]
)
