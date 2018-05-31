//
//  CommentsAndWhitespaceStripper.swift
//  SwiftHackVirtualMachineCore
//
//  Created by Piotr Gorzelany on 31/05/2018.
//

import Foundation

/// Strips comments and whitespace from the provided input lines
public class CommentAndWhitespaceStripper {

    private let commentCharacter = "//"

    public init() {}

    /// Strips the provided strings from comments and whitespace
    public func strip(lines: [String]) -> [String] {
        let results = stripWhitespace(from: lines)
        return stripComments(from: results)
    }

    private func stripWhitespace(from lines: [String]) -> [String] {
        return lines.compactMap { (line) -> String? in
            let result = line.components(separatedBy: .whitespacesAndNewlines).joined()
            guard !result.isEmpty else {
                return nil
            }

            return result
        }
    }

    private func stripComments(from lines: [String]) -> [String] {
        return lines.compactMap({ (line) -> String? in
            guard let result = line.components(separatedBy: commentCharacter).first, !result.isEmpty else {
                return nil
            }

            return result
        })
    }
}
