//
//  MemorySegment.swift
//  SwiftHackVirtualMachine
//
//  Created by Piotr Gorzelany on 31/05/2018.
//

import Foundation

public enum MemorySegment {
    case argument
    case local
    case `static`
    case constant
    case this
    case that
    case pointer
    case test
}
