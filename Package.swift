// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

/**
*  CNAME file generator plugin for Publish
*  Copyright (c) Manny Guerrero 2020
*  MIT license, see LICENSE file for details
*/

import PackageDescription

let package = Package(
    name: "CNAMEPublishPlugin",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "CNAMEPublishPlugin",
            targets: ["CNAMEPublishPlugin"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/johnsundell/publish.git", from: "0.9.0")
    ],
    targets: [
        .target(
            name: "CNAMEPublishPlugin",
            dependencies: [
                .product(name: "Publish", package: "publish")
            ]
        ),
        .testTarget(
            name: "CNAMEPublishPluginTests",
            dependencies: ["CNAMEPublishPlugin"]
        ),
    ]
)
