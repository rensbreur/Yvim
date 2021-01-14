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
    mutating func moveForward(while condition: (unichar) -> Bool) {
        var pos = position
        while let char = text.safeCharacter(at: pos), condition(char) {
            pos += 1
        }
        position = pos
    }

    mutating func moveBackward(while condition: (unichar) -> Bool) {
        var pos = position
        while let char = text.safeCharacter(at: pos), condition(char) {
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

    mutating func seekForward(char: unichar) {
        moveForwardInLine()
        moveForward(while: { $0 != char })
    }

    mutating func seekBackward(char: unichar) {
        moveBackwardInLine()
        moveBackward(while: { $0 != char })
    }

    mutating func moveToBeginningOfLine() {
        moveBackward(while: { $0 != "\n" })
        moveForwardInLine()
    }

    mutating func moveToEndOfLine() {
        moveForward(while: { $0 != "\n" })
        moveBackwardInLine()
    }

    mutating func moveToFirstCharacterInLine() {
        moveToBeginningOfLine()
        moveForward(while: { $0 == " " })
    }

    mutating func moveToAfterWord() {
        moveForward(while: { $0 != " " && $0 != "\n" })
    }

    mutating func moveToEndOfWord() {
        moveToAfterWord()
        moveBackwardInLine()
    }

    mutating func moveToNextWord() {
        moveToAfterWord()
        moveForward(while: { $0 == " " || $0 == "\n" })
    }

    mutating func moveToBeginningOfWord() {
        moveBackward(while: { $0 != " " && $0 != "\n" })
        moveForwardInLine()
    }
}
