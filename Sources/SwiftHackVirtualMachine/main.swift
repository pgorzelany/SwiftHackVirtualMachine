//
//  main.swift
//  SwiftHackVirtualMachine
//
//  Created by Piotr Gorzelany on 31/05/2018.
//

import SwiftHackVirtualMachineCore

let virtualMachine = VirtualMachine()

do {
    try virtualMachine.run()
} catch {
    print(error)
}
