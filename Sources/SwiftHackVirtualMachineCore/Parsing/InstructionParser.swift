//
//  InstructionParser.swift
//  SwiftHackVirtualMachineCore
//
//  Created by Piotr Gorzelany on 31/05/2018.
//

import Foundation

class InstructionParser {

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
        default:
            throw VirtualMachineError(line: line)
        }

        return Command(type: commandType, line: line)
    }
}
