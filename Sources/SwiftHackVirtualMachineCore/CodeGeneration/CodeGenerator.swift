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
        return """
        // VM - NEG
        @SP // points to the stack pointer
        A=M-1 // point to last stack memory location
        M=-M // negate the top stack value
        """
    }

    private func generateAssemblyForAddCommand() -> String {
        return """
        // VM - ADD
        @SP
        A=M-1
        D=M // store the first value in D
        @SP
        A=M-2
        M=M+D
        @SP
        M=M-1
        """
    }

    private func generateAssemblyForSubCommand() -> String {
        return """
        // VM - SUB
        @SP
        A=M-1
        D=M // store the first value in D
        @SP
        A=M-2
        M=M-D
        @SP
        M=M-1 // decrement the stack pointer
        """

    }

    private func generateAssemblyForEqCommand() -> String {
        return """
        @SP
        A=M-1
        D=M // store first value in D
        @SP
        A=M-2
        D=M-D // D now holds the subtraction of fist - second argument
        @PUSHTRUE
        D;JEQ // if D is equal 0, push true to the stack else push false
        // push false to the stack
        @SP
        A=M-2
        M=0 // push false
        (PUSHTRUE)
            @SP
            A=M-2
            M=-1 // push true
        @SP
        M=M-1 // decrement the stack pointer
        """
    }

    private func generateAssemblyForLtCommand() -> String {
        return """
        @SP
        A=M-1
        D=M // store first value in D
        @SP
        A=M-2
        D=M-D // D now holds the subtraction of fist - second argument
        @PUSHTRUE
        D;JLT // if D is less than 0, push true to the stack else push false
        // push false to the stack
        @SP
        A=M-2
        M=0 // push false
        (PUSHTRUE)
            @SP
            A=M-2
            M=-1 // push true
        @SP
        M=M-1 // decrement the stack pointer
        """
    }

    private func generateAssemblyForGtCommand() -> String {
        return """
        @SP
        A=M-1
        D=M // store first value in D
        @SP
        A=M-2
        D=M-D // D now holds the subtraction of fist - second argument
        @PUSHTRUE
        D;JGT // if D is greater than 0, push true to the stack else push false
        // push false to the stack
        @SP
        A=M-2
        M=0 // push false
        (PUSHTRUE)
            @SP
            A=M-2
            M=-1 // push true
        @SP
        M=M-1 // decrement the stack pointer
        """
    }

    private func generateAssemblyForAndCommand() -> String {
        return """
        // VM - AND
        @SP
        A=M-1
        D=M // store the first value in D
        @SP
        A=M-2
        M=D&M
        @SP
        M=M-1 // decrement the stack pointer
        """
    }

    private func generateAssemblyForOrCommand() -> String {
        return """
        // VM - OR
        @SP
        A=M-1
        D=M // store the first value in D
        @SP
        A=M-2
        M=D|M
        @SP
        M=M-1 // decrement the stack pointer
        """
    }

    private func generateAssemblyForNotCommand() -> String {
        return """
        // VM - NOT
        @SP // points to the stack pointer
        A=M-1 // point to last stack memory location
        M=!M
        """
    }
}
