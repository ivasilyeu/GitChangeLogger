// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GitChangeLogger",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        // Products can be used to vend plugins, making them visible to other packages.
        .plugin(
            name: "GitChangeLogger",
            targets: ["GitChangeLogger"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .plugin(
            name: "GitChangeLogger",
            capability: .command(intent: PluginCommandIntent.custom(verb: "generate-changelog", description: "Generates Changelog.md file for the current (target) Git branch against the latest release (base) branch"), permissions:
                                    [PluginPermission.allowNetworkConnections(scope: PluginNetworkPermissionScope.all(), reason: "PluginPermission.allowNetworkConnections-reason"),
                                     PluginPermission.writeToPackageDirectory(reason: "PluginPermission.writeToPackageDirectory-reason")]),
            dependencies: ["GitChangeLogExtractor"]
        ),
        .executableTarget(name: "GitChangeLogExtractor"),
    ]
)
