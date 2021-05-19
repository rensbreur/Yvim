//
//  TextPosition.swift
//  Yvim
//
//  Created by Rens Breur on 13.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

struct TextPosition {
    let text: NSString
    var position: Int
}

extension TextPosition {
    mutating func moveForward(ensuring condition: (unichar) -> Bool) {
        var pos = position
        while let char = text.safeCharacter(at: pos + 1), condition(char) {
            pos += 1
        }
        position = pos
    }

    mutating func moveBackward(ensuring condition: (unichar) -> Bool) {
        var pos = position
        while let char = text.safeCharacter(at: pos - 1), condition(char) {
            pos -= 1
        }
        position = pos
    }

    mutating func moveForwardInLine() {
        let pos = position + 1
        if let char = text.safeCharacter(at: pos), char != "\n" {
            position = pos
        }
    }

    mutating func moveBackwardInLine() {
        let pos = position - 1
        if let char = text.safeCharacter(at: pos), char != "\n" {
            position = pos
        }
    }

    mutating func moveForward() {
        let pos = position + 1
        if pos < text.length {
            position = pos
        }
    }

    mutating func moveBackward() {
        let pos = position - 1
        if pos >= 0 {
            position = pos
        }
    }

    mutating func moveToBeginningOfLine() {
        moveBackward(ensuring: { $0 != "\n" })
    }

    mutating func moveToEndOfLine() {
        moveForward(ensuring: { $0 != "\n" })
    }

    mutating func moveToFirstCharacterInLine() {
        moveToBeginningOfLine()
        moveForward(ensuring: { $0 == " " })
        moveForward()
    }

    mutating func moveToEndOfWord() {
        moveForward(ensuring: \.isWhitespace)
        moveForward()
        if let current = text.safeCharacter(at: position), !current.isAlphanumeric { return }
        moveForward(ensuring: \.isAlphanumeric)
    }

    mutating func moveToNextWord() {
        if let current = text.safeCharacter(at: position), current.isAlphanumeric {
            moveForward(ensuring: \.isAlphanumeric)
            moveForward()
        }
        else if let current = text.safeCharacter(at: position), !current.isWhitespace {
            moveForward()
        }
        if let current = text.safeCharacter(at: position), current.isWhitespace {
            moveForward(ensuring: \.isWhitespace)
            moveForward()
        }
    }

    mutating func moveToBeginningOfWord() {
        moveBackward(ensuring: { $0 != " " && $0 != "\n" })
    }
}

extension TextPosition: Equatable {}

extension unichar {
    var isWhitespace: Bool {
        guard let unicodeScalar = UnicodeScalar(self) else {
            return false
        }
        return Character(unicodeScalar).isWhitespace
    }

    var isAlphanumeric: Bool {
        guard let unicodeScalar = UnicodeScalar(self) else {
            return false
        }
        let character = Character(unicodeScalar)
        return character.isLetter || character.isNumber
    }
}
