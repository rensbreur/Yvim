//
//  VimMovement.swift
//  Yvim
//
//  Created by Admin on 04.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

protocol VimMovement {
    func index(from index: Int, in text: NSString) -> Int
}

protocol ParametrizedVimMovement: VimMovement {
    init(parameter: unichar)
}

struct VimMovementForward: VimMovement {
    func index(from index: Int, in text: NSString) -> Int {
        text.moveForwardInLine(from: index)
    }
}

struct VimMovementBackward: VimMovement {
    func index(from index: Int, in text: NSString) -> Int {
        text.moveBackwardInLine(from: index)
    }
}

struct VimFind: ParametrizedVimMovement {
    let parameter: unichar
    func index(from index: Int, in text: NSString) -> Int {
        text.seekForward(from: index, char: parameter)
    }
}

struct VimFindReverse: ParametrizedVimMovement {
    let parameter: unichar
    func index(from index: Int, in text: NSString) -> Int {
        text.seekBackward(from: index, char: parameter)
    }
}

struct VimTil: ParametrizedVimMovement {
    let parameter: unichar
    func index(from index: Int, in text: NSString) -> Int {
        text.moveBackwardInLine(from: text.seekForward(from: text.moveForwardInLine(from: index), char: parameter))
    }
}

struct VimTilReverse: ParametrizedVimMovement {
    let parameter: unichar
    func index(from index: Int, in text: NSString) -> Int {
        text.moveForwardInLine(from: text.seekBackward(from: text.moveBackwardInLine(from: index), char: parameter))
    }
}

struct VimWord: VimMovement {
    func index(from index: Int, in text: NSString) -> Int {
        text.moveToNextWord(from: text.moveForwardInLine(from: index))
    }
}

struct VimEnd: VimMovement {
    func index(from index: Int, in text: NSString) -> Int {
        text.moveToEndOfWord(from: text.moveForwardInLine(from: index))
    }
}

struct VimBack: VimMovement {
    func index(from index: Int, in text: NSString) -> Int {
        text.moveForwardInLine(from: text.moveToBeginningOfWord(from: index))
    }
}

struct VimLineStart: VimMovement {
    func index(from index: Int, in text: NSString) -> Int {
        text.moveToBeginningOfLine(from: index)
    }
}

struct VimLineEnd: VimMovement {
    func index(from index: Int, in text: NSString) -> Int {
        text.moveToEndOfLine(from: index)
    }
}

struct VimLineFirstNonBlankCharacter: VimMovement {
    func index(from index: Int, in text: NSString) -> Int {
        let lineStart = text.moveToBeginningOfLine(from: index)
        return text.moveForward(from: lineStart, while: { $0 == " " })
    }
}
