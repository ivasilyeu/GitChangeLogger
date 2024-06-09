//
//  GitChangeLogExtractor.swift
//
//
//  Created by IV on 20.01.2024.
//

import ArgumentParser
import Foundation

@main
struct GitChangeLogExtractor: ParsableCommand {

    @Argument(help: "Path to output file for the changelog")
    var output: String

    @Option(name: .shortAndLong, help: "Name of the target branch to generate the changelog against")
    var targetBranch: String = "develop"

    @Option(name: .shortAndLong, help: "Name of the base branch to generate the changelog against")
    var baseBranch: String = "master"

    @Argument(parsing: .allUnrecognized)
    var other: [String]

    mutating func run() throws {

        print("running GitChangeLogExtractor...")
        print("GitChangeLogExtractor | base branch: \(baseBranch)")
        print("GitChangeLogExtractor | target branch: \(targetBranch)")
        print("GitChangeLogExtractor | output path: \(output)")

        let gitPath = "/usr/bin/git"
        let git = Process()
        git.executableURL = URL(fileURLWithPath: gitPath)
        git.arguments = ["log",
                         "\(baseBranch)..\(targetBranch)",
                         "--pretty='format:%s %an <%ae>%n'"]

//        let outputPipe = Pipe()
//        git.standardOutput = outputPipe

        let fileManager = FileManager.default
        let outputDir = (output as NSString).deletingLastPathComponent
        
        do {
            try fileManager.createDirectory(atPath: outputDir, withIntermediateDirectories: true)
        } catch {
            print("GitChangeLogExtractor | error while creating output directory: \(error)")
        }

        if !fileManager.createFile(atPath: output, contents: nil) {

            print("GitChangeLogExtractor | error while creating output file")
        }

        guard let outputHandle = FileHandle(forWritingAtPath: output) else {

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
