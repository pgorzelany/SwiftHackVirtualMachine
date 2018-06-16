//
//  Command.swift
//  SwiftHackVirtualMachine
//
//  Created by Piotr Gorzelany on 31/05/2018.
//

import Foundation

public enum CommandType {
    case push(segment: MemorySegment, index: Int16)
    case pop(segment: MemorySegment, index: Int16)
    case neg
    case add
    case sub
    case eq
    case gt
    case lt
    case and
    case or
    case not
    case label(name: String)
    case goto(label: String)
    case ifgoto(label: String)
    case function(name: String, argumentCount: UInt)
    case call(functionName: String, argumentCount: UInt)
    case `return`
}
