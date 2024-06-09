import PackagePlugin
import XcodeProjectPlugin
import Foundation

/**
 - Parameter base: Base branch to generate changelog against. Default value is `master`.
 - Parameter target: Target branch to generate changelog against. Default value is `develop`.
 */
@main
struct GitChangeLogger: CommandPlugin {

    func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {

        let directory = context.package.directory
        let tool = try context.tool(named: "GitChangeLogExtractor")
        try run(workDirectory: directory, tool: tool, arguments: arguments)
    }
}

extension GitChangeLogger: XcodeCommandPlugin {

    func performCommand(context: XcodeProjectPlugin.XcodePluginContext, arguments: [String]) throws {

        let directory = context.xcodeProject.directory
        let tool = try context.tool(named: "GitChangeLogExtractor")
        try run(workDirectory: directory, tool: tool, arguments: arguments)
    }
}

fileprivate extension GitChangeLogger {

    func run(workDirectory: PackagePlugin.Path, tool: PluginContext.Tool, arguments: [String]) throws {

        let output = workDirectory.appending(subpath: "changelog/changelog.md")

        let extractor = Process()
        extractor.executableURL = URL(fileURLWithPath: tool.path.string)
        extractor.arguments = arguments + ["--output", output.string]

        try extractor.run()
        extractor.waitUntilExit()
    }
}
