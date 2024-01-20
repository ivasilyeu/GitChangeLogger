import PackagePlugin

@main
struct GitChangeLogger: BuildToolPlugin {

    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {

        let git = try context.tool(named: "git")
        let directory = context.pluginWorkDirectory

        let baseBranch = "develop"
        let targetBranch = "delayed/SFFEAT0010489-landing-redesign"

        return [createCommand(tool: git, baseBranchName: baseBranch, targetBranchName: targetBranch, workDirectory: directory)]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension GitChangeLogger: XcodeBuildToolPlugin {

    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
    
        let extractor = try context.tool(named: "ChangeLogExtractor")
        let directory = context.pluginWorkDirectory

        let baseBranch = "develop"
        let targetBranch = "delayed/SFFEAT0010489-landing-redesign"

        return [createCommand(tool: extractor, baseBranchName: baseBranch, targetBranchName: targetBranch, workDirectory: directory)]
    }
}

#endif

extension GitChangeLogger {

    func createCommand(tool: PluginContext.Tool, baseBranchName: String, targetBranchName: String, workDirectory: Path) -> Command {

        let output = workDirectory.appending(subpath: "changelog/changelog.md")

        return Command.buildCommand(displayName: "Generating changelog file",
                             executable: tool.path,
                             arguments: ["--base", baseBranchName,
                                         "--target", targetBranchName,
                                         "--output", output.string],
                             outputFiles: [output])

//        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
//        let output = String(decoding: outputData, as: UTF8.self)
//
//        let contributors = Set(output.components(separatedBy: CharacterSet.newlines)).sorted().filter { !$0.isEmpty }
//        try contributors.joined(separator: "\n").write(toFile: "CONTRIBUTORS.txt", atomically: true, encoding: .utf8)


    }
}
