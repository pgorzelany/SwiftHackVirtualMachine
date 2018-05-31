//
//  VirtualMachine.swift
//  SwiftHackVirtualMachineCore
//
//  Created by Piotr Gorzelany on 31/05/2018.
//

import Foundation

public class VirtualMachine {

    public init() {}

    /// Compiles .vm source files into a single .asm file in the current directory
    public func run() throws {
        print(CommandLine.arguments[0])
    }

    /// Compiles the given *.vm file at the source url and outputs assembly to destination url
    public func compileFile(source sourceUrl: URL, destination destinationUrl: URL) throws {

    }

    /// Compiles the given source in the form of vm instructions and outputs the assembly instructions
    public func compile(source: [String]) throws -> [String] {
        fatalError("")
    }
}
