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

        print("running GitChangeLogExtractor...")

        let arguments = CommandLine.arguments

        let baseBranchNameIndex = arguments.index(arguments.firstIndex(of: "--base")!, offsetBy: 1)
        let baseBranchName = arguments[baseBranchNameIndex]

        print("GitChangeLogExtractor | base branch: \(baseBranchName)")

        let targetBranchNameIndex = arguments.index(arguments.firstIndex(of: "--target")!, offsetBy: 1)
        let targetBranchName = arguments[targetBranchNameIndex]

        print("GitChangeLogExtractor | target branch: \(targetBranchName)")

        let outputPathIndex = arguments.index(arguments.firstIndex(of: "--output")!, offsetBy: 1)
        let outputPath = arguments[outputPathIndex]

        print("GitChangeLogExtractor | output path: \(outputPath)")

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
        
        do {
            try fileManager.createDirectory(atPath: outputDir, withIntermediateDirectories: true)
        } catch {
            print("GitChangeLogExtractor | error while creating output directory: \(error)")
        }

        if !fileManager.createFile(atPath: outputPath, contents: nil) {

            print("GitChangeLogExtractor | error while creating output file")
        }

        guard let outputHandle = FileHandle(forWritingAtPath: outputPath) else {

            print("GitChangeLogExtractor | error while opening file handle for the output file")
            return
        }

        git.standardOutput = outputHandle

        do {
            try git.run()
        } catch {
            print("GitChangeLogExtractor | error while executing git command: \(error)")
        }

        git.waitUntilExit()
        
        do {
            try outputHandle.close()
        } catch {
            print("GitChangeLogExtractor | error while closing file handle for the output file: \(error)")
        }

//        let data = try outputPipe.fileHandleForReading.readToEnd()

//        let stdout = FileHandle.standardOutput
//        try stdout.write(contentsOf: data)

        print("GitChangeLogExtractor | done!")
    }
}
