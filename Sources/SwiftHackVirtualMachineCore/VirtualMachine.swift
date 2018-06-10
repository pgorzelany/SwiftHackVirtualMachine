//
//  VirtualMachine.swift
//  SwiftHackVirtualMachineCore
//
//  Created by Piotr Gorzelany on 31/05/2018.
//

import Foundation

public class VirtualMachine {

    public init() {}

    private let sourceCodeExtractor = SourceCodeExtractor()
    private let stripper = CommentAndWhitespaceStripper()
    private let parser = InstructionParser()
    private let codeGenerator = CodeGenerator()

    /// Compiles .vm source files into a single .asm file in the current directory
    public func run() throws {
        let currentDirectoryUrl = URL(string: FileManager.default.currentDirectoryPath)!
        let sourceCodeLines = try sourceCodeExtractor.getSourceCodeLines(at: currentDirectoryUrl)
        let strippedSourceCodeLines = stripper.strip(lines: sourceCodeLines)
        let commands = try parser.parse(source: strippedSourceCodeLines)
        try codeGenerator.createAssemblyFile(for: commands, at: currentDirectoryUrl)
        print("Created asm file")
    }
}
