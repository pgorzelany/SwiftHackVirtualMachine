//
// CodeGenerator.swift
//  Basic
//
//  Created by Piotr Gorzelany on 31/05/2018.
//

import Foundation

class CodeGenerator {

    func createAssemblyFile(for commands: [Command], at directoryURL: URL) throws {
        let directoryName = directoryURL.lastPathComponent
        let outputUrl = URL(fileURLWithPath: directoryURL.path).appendingPathComponent("\(directoryName).asm")
        let assembly = try generateAssembly(for: commands)
        try assembly.write(to: outputUrl, atomically: true, encoding: .utf8)
    }

    func generateAssembly(for commands: [Command]) throws -> String {
        return try commands.map(generateAssembly).joined(separator: "\n")
    }

    func generateAssembly(for command: Command) throws -> String {
        #warning("implement this")

        switch command {
        case .push(let segment, let index):
            return generateAssemblyForPushCommand(segment: segment, index: index)
        case .pop(let segment, let index):
            return generateAssemblyForPopCommand(segment: segment, index: index)
        case .neg:
            return generateAssemblyForNegCommand()
        case .add:
            return generateAssemblyForAddCommand()
        case .sub:
            return generateAssemblyForSubCommand()
        case .eq:
            return generateAssemblyForEqCommand()
        case .qt:
            return generateAssemblyForGtCommand()
        case .lt:
            return generateAssemblyForLtCommand()
        case .and:
            return generateAssemblyForAndCommand()
        case .or:
            return generateAssemblyForOrCommand()
        case .not:
            return generateAssemblyForNotCommand()
        }
    }

    private func generateAssemblyForPushCommand(segment: MemorySegment, index: Int16) -> String {
        fatalError()
    }

    private func generateAssemblyForPopCommand(segment: MemorySegment, index: Int16) -> String {
        fatalError()
    }

    private func generateAssemblyForNegCommand() -> String {
        fatalError()
    }

    private func generateAssemblyForAddCommand() -> String {
        fatalError()
    }

    private func generateAssemblyForSubCommand() -> String {
        fatalError()
    }

    private func generateAssemblyForEqCommand() -> String {
        fatalError()
    }

    private func generateAssemblyForLtCommand() -> String {
        fatalError()
    }

    private func generateAssemblyForGtCommand() -> String {
        fatalError()
    }

    private func generateAssemblyForAndCommand() -> String {
        fatalError()
    }

    private func generateAssemblyForOrCommand() -> String {
        fatalError()
    }

    private func generateAssemblyForNotCommand() -> String {
        fatalError()
    }
}
