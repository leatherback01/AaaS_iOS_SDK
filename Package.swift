// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LAAS",
    platforms: [
            .iOS(.v11)
        ],
    products: [
        .library(
            name: "LAAS",
            targets: ["LAAS"]),
    ],
    dependencies: [

    ],
    targets: [
        .target(
            name: "LAAS",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "LAASTests",
            dependencies: ["LAAS"]),
    ],
    swiftLanguageVersions: [
            .v5
        ]
)
