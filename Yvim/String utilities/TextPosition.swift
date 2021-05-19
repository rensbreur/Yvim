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
    var currentCharacter: unichar? {
        text.safeCharacter(at: position)
    }

    var previousCharacter: unichar? {
        text.safeCharacter(at: position - 1)
    }

    var nextCharacter: unichar? {
        text.safeCharacter(at: position + 1)
    }

    mutating func moveForward(ensuring condition: (unichar) -> Bool) {
        while let char = nextCharacter, condition(char) {
            position += 1
        }
    }

    mutating func moveBackward(ensuring condition: (unichar) -> Bool) {
        while let char = previousCharacter, condition(char) {
            position -= 1
        }
    }

    mutating func moveForwardInLine() {
        if let char = nextCharacter, char != "\n" {
            position += 1
        }
    }

    mutating func moveBackwardInLine() {
        if let char = previousCharacter, char != "\n" {
            position -= 1
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
        if let current = currentCharacter, current.isAlphanumeric {
            moveForward(ensuring: \.isAlphanumeric)
        }
    }

    mutating func moveToNextWord() {
        if let current = currentCharacter, current.isAlphanumeric {
            moveForward(ensuring: \.isAlphanumeric)
            moveForward()
        }
        else if let current = currentCharacter, !current.isWhitespace {
            moveForward()
        }
        if let current = currentCharacter, current.isWhitespace {
            moveForward(ensuring: \.isWhitespace)
            moveForward()
        }
    }

    mutating func moveToBeginningOfWord() {
        moveBackward(ensuring: \.isWhitespace)
        moveBackward()
        if let current = currentCharacter, current.isAlphanumeric {
            moveBackward(ensuring: \.isAlphanumeric)
        }
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
