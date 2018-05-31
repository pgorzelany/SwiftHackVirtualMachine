//
// CodeGenerator.swift
//  Basic
//
//  Created by Piotr Gorzelany on 31/05/2018.
//

import Foundation

class CodeGenerator {

    func createAssemblyFile(for commands: [Command]) throws {
        let currentDirectoryUrl = URL(string: FileManager.default.currentDirectoryPath)!
        let directoryName = currentDirectoryUrl.lastPathComponent
        let outputUrl = URL(fileURLWithPath: currentDirectoryUrl.path).appendingPathComponent("\(directoryName).asm")
        let assembly = generateAssembly(for: commands)
        try assembly.write(to: outputUrl, atomically: true, encoding: .utf8)
    }

    func generateAssembly(for commands: [Command]) -> String {
        return "Random assembly"
    }
}
