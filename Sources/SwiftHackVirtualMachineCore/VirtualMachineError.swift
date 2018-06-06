//
//  VirtualMachineError.swift
//  SwiftHackVirtualMachineCore
//
//  Created by Piotr Gorzelany on 06.06.2018.
//

import Foundation

class VirtualMachineError: NSError {
    convenience init(message: String) {
        self.init(domain: "HackVirtualMachine", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
    }

    convenience init(line: SourceCodeLine, description: String? = nil) {
        var message = "Invalid command at file: \(line.sourceFileName), line: \(line.lineNumber), contents: \(line.contents))"
        if let description = description {
            message += " \ndescription: \(description)"
        }
        self.init(message: message)
    }
}
