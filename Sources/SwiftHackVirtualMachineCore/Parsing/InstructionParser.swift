//
//  InstructionParser.swift
//  SwiftHackVirtualMachineCore
//
//  Created by Piotr Gorzelany on 31/05/2018.
//

import Foundation

class InstructionParser {

    private var functionScopes = [String]()

    func parse(source: [SourceCodeLine]) throws -> [Command] {
        return try source.map(extractCommand)
    }

    private func extractCommand(from line: SourceCodeLine) throws -> Command {
        let lineContents = line.contents
        let components = lineContents.components(separatedBy: .whitespaces)

        guard let rawCommand = components.first else {
            throw VirtualMachineError(line: line)
        }

        let commandType: CommandType

        switch rawCommand {
        case "pop", "push":
            guard components.count >= 3, let segment = MemorySegment(rawValue: components[1]), let index = Int16(components[2]) else {
                throw VirtualMachineError(line: line, description: "The pop/push command does not contain a valid memory segment and index")
            }

            commandType = rawCommand == "pop" ? .pop(segment: segment, index: index) : .push(segment: segment, index: index)
        case "neg":
            commandType = .neg
        case "add":
            commandType = .add
        case "sub":
            commandType = .sub
        case "eq":
            commandType = .eq
        case "gt":
            commandType = .gt
        case "lt":
            commandType = .lt
        case "and":
            commandType = .and
        case "or":
            commandType = .or
        case "not":
            commandType = .not
        case "label":
            guard components.count >= 2 else {
                throw VirtualMachineError(line: line, description: "Missing label name")
            }
            var name = components[1]
            if let currentFunctionName = functionScopes.last {
                name = "\(currentFunctionName)$\(name)"
            }
            commandType = .label(name: name)
        case "goto":
            guard components.count >= 2 else {
                throw VirtualMachineError(line: line, description: "Missing label name")
            }
            var label = components[1]
            if let currentFunctionName = functionScopes.last {
                label = "\(currentFunctionName)$\(label)"
            }
            commandType = .goto(label: label)
        case "if-goto":
            guard components.count >= 2 else {
                throw VirtualMachineError(line: line, description: "Missing label name")
            }
            var label = components[1]
            if let currentFunctionName = functionScopes.last {
                label = "\(currentFunctionName)$\(label)"
            }
            commandType = .ifgoto(label: label)
        case "function":
            guard components.count >= 3, let argumentCount = UInt(components[2]) else {
                throw VirtualMachineError(line: line, description: "Invalid function declaration")
            }
            let name = components[1]
            commandType = .function(name: name, argumentCount: argumentCount)
            functionScopes.append(name)
        case "call":
            guard components.count >= 3, let argumentCount = UInt(components[2]) else {
                throw VirtualMachineError(line: line, description: "Missing function name")
            }
            let functionName = components[1]
            commandType = .call(functionName: functionName, argumentCount: argumentCount)
        case "return":
            commandType = .return
            _ = functionScopes.popLast()
        default:
            throw VirtualMachineError(line: line)
        }

        return Command(type: commandType, line: line)
    }
}
