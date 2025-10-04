// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftSSZipArchive",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "SwiftSSZipArchive",
            targets: ["SwiftSSZipArchive"]
        ),
    ],
    dependencies: [
        // No external dependencies for the Swift wrapper
    ],
    targets: [
        .target(
            name: "SwiftSSZipArchive",
            dependencies: [],
            path: ".",
            exclude: ["Package.swift"],
            sources: [
                "ZipCommon.swift",
                "ZipArchiveError.swift",
                "ZipArchiveDelegate.swift",
                "SSZipArchive.swift",
                "Extensions",
                "Views"
            ]
        ),
        .testTarget(
            name: "SwiftSSZipArchiveTests",
            dependencies: ["SwiftSSZipArchive"],
            path: "Tests"
        ),
    ]
)
