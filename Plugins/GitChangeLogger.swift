import PackagePlugin
import XcodeProjectPlugin
import Foundation

@main
struct GitChangeLogger: XcodeCommandPlugin {

    func performCommand(context: XcodeProjectPlugin.XcodePluginContext, arguments: [String]) throws {

        let directory = context.pluginWorkDirectory
        let tool = try context.tool(named: "GitChangeLogExtractor")
        try run(workDirectory: directory, tool: tool)
    }
}

extension GitChangeLogger: CommandPlugin {
    
    func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {

        let directory = context.pluginWorkDirectory
        let tool = try context.tool(named: "GitChangeLogExtractor")
        try run(workDirectory: directory, tool: tool)
    }
}

fileprivate extension GitChangeLogger {

    func run(workDirectory: PackagePlugin.Path, tool: PluginContext.Tool) throws {

        let baseBranch = "develop"
        let targetBranch = "delayed/SFFEAT0010489-landing-redesign"


        let output = workDirectory.appending(subpath: "changelog/changelog.md")



        let extractor = Process()
        extractor.executableURL = URL(fileURLWithPath: tool.path.string)
        extractor.arguments = ["--base", baseBranch,
                         "--target", targetBranch,
                         "--output", output.string]

//        let outputPipe = Pipe()
//        extractor.standardOutput = outputPipe

        try extractor.run()
        extractor.waitUntilExit()
    }
}
