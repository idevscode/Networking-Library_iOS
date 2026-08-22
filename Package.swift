// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Networking-Library_iOS",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "Domain",
            targets: ["Domain"]
        ),
        .library(
            name: "Data",
            targets: ["Data"]
        ),
        .library(
            name: "Networking-Library_iOS",
            targets: ["Domain", "Data"]
        ),
    ],
    targets: [
        .target(
            name: "Domain",
            path: "Sources/Domain"
        ),
        .target(
            name: "Data",
            dependencies: [
                "Domain"
            ],
            path: "Sources/Data"
        ),
    ]
)
