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

        switch rawCommand {
        case "pop", "push":
            guard components.count == 3, let segment = MemorySegment(rawValue: components[1]), let index = Int16(components[2]) else {
                throw VirtualMachineError(line: line, description: "The pop command does not contain a valid memory segment and index")
            }

            return rawCommand == "pop" ? .pop(segment: segment, index: index) : .push(segment: segment, index: index)
        case "neg":
            return .neg
        case "add":
            return .add
        case "sub":
            return .sub
        case "eq":
            return .eq
        case "qt":
            return .qt
        case "lt":
            return .lt
        case "and":
            return .and
        case "or":
            return .or
        case "not":
            return .not
        default:
            throw VirtualMachineError(line: line)
        }
    }
}
