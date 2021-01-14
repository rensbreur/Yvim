//
//  NSString+motion.swift
//  Yvim
//
//  Created by Rens Breur on 13.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

extension NSString {
    func moveForward(from index: Int, while condition: (unichar) -> Bool) -> Int {
        var pos = index
        while let char = safeCharacter(at: pos), condition(char) {
            pos += 1
        }
        return pos
    }

    func moveBackward(from index: Int, while condition: (unichar) -> Bool) -> Int {
        var pos = index
        while let char = safeCharacter(at: pos), condition(char) {
            pos -= 1
        }
        return pos
    }

    func moveForwardInLine(from index: Int) -> Int {
        let pos = index + 1
        if let char = safeCharacter(at: pos), char != "\n" {
            return pos
        }
        return index
    }

    func moveBackwardInLine(from index: Int) -> Int {
        let pos = index - 1
        if let char = safeCharacter(at: pos), char != "\n" {
            return pos
        }
        return index
    }

    func seekForward(from index: Int, char: unichar) -> Int {
        moveForward(from: moveForwardInLine(from: index), while: { $0 != char })
    }

    func seekBackward(from index: Int, char: unichar) -> Int {
        moveBackward(from: moveBackwardInLine(from: index), while: { $0 != char })
    }

    func moveToBeginningOfLine(from index: Int) -> Int {
        moveForwardInLine(from: moveBackward(from: index, while: { $0 != "\n" }))
    }

    func moveToEndOfLine(from index: Int) -> Int {
        moveBackwardInLine(from: moveForward(from: index, while: { $0 != "\n" }))
    }

    func moveToFirstCharacterInLine(from index: Int) -> Int {
        moveForward(from: moveToBeginningOfLine(from: index), while: { $0 == " " })
    }

    func moveToAfterWord(from index: Int) -> Int {
        moveForward(from: index, while: { $0 != " " && $0 != "\n" })
    }

    func moveToEndOfWord(from index: Int) -> Int {
        moveBackwardInLine(from: moveToAfterWord(from: index))
    }

    func moveToNextWord(from index: Int) -> Int {
        moveForward(from: moveToAfterWord(from: index), while: { $0 == " " || $0 == "\n" })
    }

    func moveToBeginningOfWord(from index: Int) -> Int {
        moveForwardInLine(from: moveBackward(from: index, while: { $0 != " " && $0 != "\n" }))
    }
}
