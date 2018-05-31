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
    func strip(lines: [SourceCodeLine]) -> [SourceCodeLine] {
        let results = stripWhitespace(from: lines)
        return stripComments(from: results)
    }

    private func stripWhitespace(from lines: [SourceCodeLine]) -> [SourceCodeLine] {
        return lines.compactMap { (line) -> SourceCodeLine? in
            var lineCopy = line
            lineCopy.contents = lineCopy.contents.components(separatedBy: .whitespacesAndNewlines).joined(separator: " ")
            guard !lineCopy.contents.isEmpty else {
                return nil
            }

            return lineCopy
        }
    }

    private func stripComments(from lines: [SourceCodeLine]) -> [SourceCodeLine] {
        return lines.compactMap({ (line) -> SourceCodeLine? in
            var lineCopy = line
            guard let codeContent = lineCopy.contents.components(separatedBy: commentCharacter).first, !codeContent.isEmpty else {
                return nil
            }
            
            lineCopy.contents = codeContent
            return lineCopy
        })
    }
}
