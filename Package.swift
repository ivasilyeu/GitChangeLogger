// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GitChangeLogger",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .plugin(
            name: "GitChangeLogger",
            targets: ["GitChangeLogger"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
    ], targets: [
        .plugin(
            name: "GitChangeLogger",
            capability: .command(intent: PluginCommandIntent.custom(verb: "generate-changelog", description: "Generates Changelog.md file for the current (target) Git branch against the latest release (base) branch"), permissions:
                                    [PluginPermission.allowNetworkConnections(scope: PluginNetworkPermissionScope.all(), reason: "PluginPermission.allowNetworkConnections-reason"),
                                     PluginPermission.writeToPackageDirectory(reason: "PluginPermission.writeToPackageDirectory-reason")]),
            dependencies: ["GitChangeLogExtractor"]
        ),
        .executableTarget(name: "GitChangeLogExtractor",
                          dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")]),
    ]
)
