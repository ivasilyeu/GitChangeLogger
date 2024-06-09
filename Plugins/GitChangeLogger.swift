import PackagePlugin
import XcodeProjectPlugin
import Foundation

@main
struct GitChangeLogger: XcodeCommandPlugin {

    func performCommand(context: XcodeProjectPlugin.XcodePluginContext, arguments: [String]) throws {

        let baseBranch = "develop"
        let targetBranch = "delayed/SFFEAT0010489-landing-redesign"

        let workDirectory = context.pluginWorkDirectory
        let output = workDirectory.appending(subpath: "changelog/changelog.md")

        let extractorTool = try context.tool(named: "GitChangeLogExtractor")

        let extractor = Process()
        extractor.executableURL = URL(fileURLWithPath: extractorTool.path.string)
        extractor.arguments = ["--base", baseBranch,
                         "--target", targetBranch,
                         "--output", output.string]

//        let outputPipe = Pipe()
//        extractor.standardOutput = outputPipe

        try extractor.run()
        extractor.waitUntilExit()
    }
}
