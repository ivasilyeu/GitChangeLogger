//
//  GitChangeLogExtractor.swift
//
//
//  Created by IV on 20.01.2024.
//

import Foundation

@main
struct GitChangeLogExtractor {

    static func main() throws -> Void {

        let arguments = CommandLine.arguments

        let baseBranchNameIndex = arguments.index(arguments.firstIndex(of: "--base")!, offsetBy: 1)
        let baseBranchName = arguments[baseBranchNameIndex]

        let targetBranchNameIndex = arguments.index(arguments.firstIndex(of: "--target")!, offsetBy: 1)
        let targetBranchName = arguments[targetBranchNameIndex]

        let outputPathIndex = arguments.index(arguments.firstIndex(of: "--output")!, offsetBy: 1)
        let outputPath = arguments[outputPathIndex]

        let gitPath = "/usr/bin/git"
        let git = Process()
        git.executableURL = URL(fileURLWithPath: gitPath)
        git.arguments = ["log",
                         "\(baseBranchName)..\(targetBranchName)",
                         "--pretty='format:%s %an <%ae>%n'"]

//        let outputPipe = Pipe()
//        git.standardOutput = outputPipe

        let fileManager = FileManager.default
        let outputDir = (outputPath as NSString).deletingLastPathComponent
        try fileManager.createDirectory(atPath: outputDir, withIntermediateDirectories: true)
        guard fileManager.createFile(atPath: outputPath, contents: nil) else {
            return
        }

        guard let outputHandle = FileHandle(forWritingAtPath: outputPath) else {
            return
        }
        git.standardOutput = outputHandle

        try git.run()
        git.waitUntilExit()
        try outputHandle.close()

//        let data = try outputPipe.fileHandleForReading.readToEnd()

//        let stdout = FileHandle.standardOutput
//        try stdout.write(contentsOf: data)
    }
}
