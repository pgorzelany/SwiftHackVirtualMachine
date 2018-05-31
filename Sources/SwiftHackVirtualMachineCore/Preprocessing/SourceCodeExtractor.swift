//
//  SourceCodeExtractor.swift
//  SwiftHackVirtualMachineCore
//
//  Created by Piotr Gorzelany on 31/05/2018.
//

import Foundation

class SourceCodeExtractor {

    private let sourceFileExtension = "vm"
    private let fileManager = FileManager.default

    func getSourceCodeLines(at directoryUrl: URL) throws -> [SourceCodeLine] {
        let fileUrls = try getSourceFileUrls(at: directoryUrl)
        return try getSourceCodeLines(from: fileUrls)
    }

    /// Returns all source code file urls for the given directory url
    private func getSourceFileUrls(at directoryUrl: URL) throws -> [URL] {
        let directoryContents = try fileManager.contentsOfDirectory(at: directoryUrl, includingPropertiesForKeys: nil, options: [])
        let vmFileUrls = directoryContents.filter { (content) -> Bool in
            content.pathExtension == sourceFileExtension && content.isFileURL
        }

        return vmFileUrls
    }

    private func getSourceCodeLines(from fileUrls: [URL]) throws -> [SourceCodeLine] {
        var results = [SourceCodeLine]()
        for url in fileUrls {
            let fileName = url.lastPathComponent
            let fileContents = try String.init(contentsOf: url, encoding: .utf8)
            let lines = fileContents.components(separatedBy: "\n")

            for (index, line) in lines.enumerated() {
                let sourceCodeLine = SourceCodeLine(lineNumber: index + 1, sourceFileName: fileName, contents: line)
                results.append(sourceCodeLine)
            }
        }
        return results
    }
}
