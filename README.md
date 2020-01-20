# CNAME plugin for Publish

A [Publish](https://github.com/johnsundell/publish) plugin that generates a custom domain name file for any Publush website deployed to Github.

## Background

When developing your own static website and deploying to Github pages, you will most likely  want to have your own custom domain. This requires having
a custom domain name file, also known as a `CNAME` in the root directory of your website or the Github repository that your website is hosted on. When generating your site and pushing to Github, the `CNAME` file is removed since [Publish](https://github.com/johnsundell/publish) will always push whatever files are generated in the dedicated `Output` directory. This plugin aims to generate a `CNAME`
file into the `Output` directory that [Publish](https://github.com/johnsundell/publish) uses for deploying your site to Github.

## Installation

To install it into your [Publish](https://github.com/johnsundell/publish) package, add it as a dependency within your `Package.swift` manifest:
```swift
let package = Package(
    ...
    dependencies: [
        ...
        .package(url: "https://github.com/SwiftyGuerrero/CNAMEPublishPlugin", from: "0.1.0")
    ],
    targets: [
        .target(
            ...
            dependencies: [
                ...
                "CNAMEPublishPlugin"
            ]
        )
    ]
    ...
)
```

## Usage

In the file where you declare your [Publish](https://github.com/johnsundell/publish) deployment pipeline,
import `CNAMEPublishPlugin`:
```swift
import CNAMEPublishPlugin
```

The plugin can be installed at any point in the publishing pipeline, but before the deploy step:
```swift
import CNAMEPublishPlugin

...
try Website().publish(using: [
    ...
    .installPlugin(.generateCNAME(with: "test.io", "www.test.io")),
    .deploy(using: .gitHub("TestUser/TestUser.github.io"))
])
```

You can also add a `CNAME` to the `Resources` directory of your website and then use the `addCNAME` plugin to copy
the `CNAME` to the output directory:
```swift
import CNAMEPublishPlugin

...
try Website().publish(using: [
    ...
    .installPlugin(.addCNAME()),
    .deploy(using: .gitHub("TestUser/TestUser.github.io"))
])
```

To verify that the file is generated and in the `Output` directory, you can use the `publish run` command to test
publishing your site locally. Then in the created `Output` directory, you will see the generated `CNAME` as shown
below:
<p align="left">
    <img src="./Assets/output.png">
</p>

To learn more about custom domains for Github Pages, visit Github's [documentation](https://help.github.com/en/github/working-with-github-pages/managing-a-custom-domain-for-your-github-pages-site) related to managing your own custom domain.