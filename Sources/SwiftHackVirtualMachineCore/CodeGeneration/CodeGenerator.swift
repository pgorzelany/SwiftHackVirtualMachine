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
        switch command.type {
        case .push(let segment, let index):
            return try generateAssemblyForPushCommand(segment: segment, index: index, fileName: command.line.sourceFileName)
        case .pop(let segment, let index):
            return try generateAssemblyForPopCommand(segment: segment, index: index, fileName: command.line.sourceFileName)
        case .neg:
            return generateAssemblyForNegCommand()
        case .add:
            return generateAssemblyForAddCommand()
        case .sub:
            return generateAssemblyForSubCommand()
        case .eq:
            return generateAssemblyForEqCommand()
        case .gt:
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

    private func generateAssemblyForPushCommand(segment: MemorySegment, index: Int16, fileName: String) throws -> String {
        return """
        // VM - Push \(segment) \(index)
        \(try generateAssemblyToStoreValueIntoDRegister(segment: segment, index: index, fileName: fileName))
        @SP
        A=M
        M=D // store the value in the memory segment on top of the stack
        @SP
        M=M+1 // increment the stack pointer
        """
    }

    private func generateAssemblyForPopCommand(segment: MemorySegment, index: Int16, fileName: String) throws -> String {
        return """
        // VM - Pop \(segment) \(index)
        @SP
        A=M-1
        D=M // store the value on top of stack in D
        \(try generateAssemblyToStoreDRegisterValueIn(segment: segment, index: index, fileName: fileName))
        @SP
        M=M-1 // decrement the stack pointer
        """
    }

    /// Generates assembly that stores the value in the D register into the specified memory segment and index.
    // Used in the VM POP command
    private func generateAssemblyToStoreDRegisterValueIn(segment: MemorySegment, index: Int16, fileName: String) throws -> String {
        switch segment {
        case .argument:
            return """
            @ARG
            \(generateAssemblyToGetAddress(for: index))
            M=D
            """
        case .local:
            return """
            @LCL
            \(generateAssemblyToGetAddress(for: index))
            M=D
            """
        case .static:
            return """
            @\(fileName).\(index)
            M=D
            """
        case .constant:
            return """
            @\(index)
            M=D
            """
        case .this:
            return """
            @THIS
            \(generateAssemblyToGetAddress(for: index))
            M=D
            """
        case .that:
            return """
            @THAT
            \(generateAssemblyToGetAddress(for: index))
            M=D
            """
        case .pointer:
            let address: String
            switch index {
            case 0:
                address = "THIS"
            case 1:
                address = "THAT"
            default:
                throw VirtualMachineError(message: "Invalid pointer index: \(index)")
            }
            return """
            @\(address)
            A=M
            M=D
            """
        case .temp:
            let address = 5 + index
            return """
            @\(address)
            A=M
            M=D
            """
        }
    }

    /// Generates assembly that will get the value at the specified memory segment and index and store it into the D register
    /// Used in the VM PUSH command
    private func generateAssemblyToStoreValueIntoDRegister(segment: MemorySegment, index: Int16, fileName: String) throws -> String {
        switch segment {
        case .argument:
            return """
            @ARG
            \(generateAssemblyToGetAddress(for: index))
            D=M
            """
        case .local:
            return """
            @LCL
            \(generateAssemblyToGetAddress(for: index))
            D=M
            """
        case .static:
            return """
            @\(fileName).\(index)
            D=M
            """
        case .constant:
            return """
            @\(index)
            D=A
            """
        case .this:
            return """
            @THIS
            \(generateAssemblyToGetAddress(for: index))
            D=M
            """
        case .that:
            return """
            @THAT
            \(generateAssemblyToGetAddress(for: index))
            D=M
            """
        case .pointer:
            let address: String
            switch index {
            case 0:
                address = "THIS"
            case 1:
                address = "THAT"
            default:
                throw VirtualMachineError(message: "Invalid pointer index: \(index)")
            }
            return """
            @\(address)
            A=M
            D=M
            """
        case .temp:
            let address = 5 + index
            return """
            @\(address)
            A=M
            D=M
            """
        }
    }

    /// Generates assembly to store the specified memory address in the A register
    /// A prerequisite is that the A register already holds the desired base memory segment address
    private func generateAssemblyToGetAddress(for index: Int16) -> String {
        var assembly = "A=M" // start at the speicifed memory segment base address
        // We can only increment the memory by 1 so we need to unfold the index
        for _ in (0..<index) {
            assembly += "\nA=A+1"
        }
        return assembly
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
        A=M-1
        A=A-1
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
        A=M-1
        A=A-1
        M=M-D
        @SP
        M=M-1 // decrement the stack pointer
        """

    }

    private func generateAssemblyForEqCommand() -> String {
        let pushTrueLabel = "push_true_" + UUID().uuidString
        let pushFalseLabel = "push_false_" + UUID().uuidString
        let decrementStackPointerLabel = "decrement_stack_pointer_" + UUID().uuidString
        return """
        // VM - EQ
        @SP
        A=M-1
        D=M // store first value in D
        @SP
        A=M-1
        A=A-1
        D=M-D // D now holds the subtraction of fist - second argument
        @\(pushTrueLabel)
        D;JEQ // if D is equal 0, push true to the stack else push false
        @\(pushFalseLabel)
        0;JMP // otherwise push false
        (\(pushTrueLabel))
            @SP
            A=M-1
            A=A-1
            M=-1 // push true
            @\(decrementStackPointerLabel)
            0;JMP
        (\(pushFalseLabel))
            @SP
            A=M-1
            A=A-1
            M=0 // push false
            @\(decrementStackPointerLabel)
            0;JMP
        (\(decrementStackPointerLabel))
            @SP
            M=M-1 // decrement the stack pointer
        """
    }

    private func generateAssemblyForLtCommand() -> String {
        let pushTrueLabel = "push_true_" + UUID().uuidString
        let pushFalseLabel = "push_false_" + UUID().uuidString
        let decrementStackPointerLabel = "decrement_stack_pointer_" + UUID().uuidString
        return """
        // VM - LT
        @SP
        A=M-1
        D=M // store first value in D
        @SP
        A=M-1
        A=A-1
        D=M-D // D now holds the subtraction of fist - second argument
        @\(pushTrueLabel)
        D;JLT // if D is less than 0, push true to the stack else push false
        @\(pushFalseLabel)
        0;JMP // otherwise push false
        (\(pushTrueLabel))
            @SP
            A=M-1
            A=A-1
            M=-1 // push true
            @\(decrementStackPointerLabel)
            0;JMP
        (\(pushFalseLabel))
            @SP
            A=M-1
            A=A-1
            M=0 // push false
            @\(decrementStackPointerLabel)
            0;JMP
        (\(decrementStackPointerLabel))
            @SP
            M=M-1 // decrement the stack pointer
        """
    }

    private func generateAssemblyForGtCommand() -> String {
        let pushTrueLabel = "push_true_" + UUID().uuidString
        let pushFalseLabel = "push_false_" + UUID().uuidString
        let decrementStackPointerLabel = "decrement_stack_pointer_" + UUID().uuidString
        return """
        // VM - GT
        @SP
        A=M-1
        D=M // store first value in D
        @SP
        A=M-1
        A=A-1
        D=M-D // D now holds the subtraction of fist - second argument
        @\(pushTrueLabel)
        D;JGT // if D is greater than 0, push true to the stack else push false
        @\(pushFalseLabel)
        0;JMP // otherwise push false
        (\(pushTrueLabel))
            @SP
            A=M-1
            A=A-1
            M=-1 // push true
            @\(decrementStackPointerLabel)
            0;JMP
        (\(pushFalseLabel))
            @SP
            A=M-1
            A=A-1
            M=0 // push false
            @\(decrementStackPointerLabel)
            0;JMP
        (\(decrementStackPointerLabel))
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
        A=M-1
        A=A-1
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
        A=M-1
        A=A-1
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
