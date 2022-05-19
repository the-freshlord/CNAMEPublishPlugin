// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

/**
*  CNAME file generator plugin for Publish
*  Copyright (c) Manny Guerrero 2020
*  MIT license, see LICENSE file for details
*/

import PackageDescription

let package = Package(
    name: "CNAMEPublishPlugin",
    products: [
        .library(
            name: "CNAMEPublishPlugin",
            targets: ["CNAMEPublishPlugin"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/johnsundell/publish.git", from: "0.7.0")
    ],
    targets: [
        .target(
            name: "CNAMEPublishPlugin",
            dependencies: ["Publish"]
        ),
        .testTarget(
            name: "CNAMEPublishPluginTests",
            dependencies: ["CNAMEPublishPlugin"]
        ),
    ]
)
