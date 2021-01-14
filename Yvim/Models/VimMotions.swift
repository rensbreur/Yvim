//
//  VimMotions.swift
//  Yvim
//
//  Created by Rens Breur on 14.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

struct VimMotionForward: VimMotion {
    func move(_ position: inout TextPosition) {
        position.moveForwardInLine()
    }
}

struct VimMotionBackward: VimMotion {
    func move(_ position: inout TextPosition) {
        position.moveBackwardInLine()
    }
}

struct VimFind: ParametrizedVimMotion {
    let parameter: unichar
    func move(_ position: inout TextPosition) {
        position.seekForward(char: parameter)
    }
}

struct VimFindReverse: ParametrizedVimMotion {
    let parameter: unichar
    func move(_ position: inout TextPosition) {
        position.seekBackward(char: parameter)
    }
}

struct VimTil: ParametrizedVimMotion {
    let parameter: unichar
    func move(_ position: inout TextPosition) {
        position.moveForwardInLine()
        position.seekForward(char: parameter)
        position.moveBackwardInLine()
    }
}

struct VimTilReverse: ParametrizedVimMotion {
    let parameter: unichar
    func move(_ position: inout TextPosition) {
        position.moveBackwardInLine()
        position.seekBackward(char: parameter)
        position.moveForwardInLine()
    }
}

struct VimWord: VimMotion {
    func move(_ position: inout TextPosition) {
        position.moveForwardInLine()
        position.moveToNextWord()
    }
}

struct VimEnd: VimMotion {
    func move(_ position: inout TextPosition) {
        position.moveForwardInLine()
        position.moveToEndOfWord()
    }
}

struct VimBack: VimMotion {
    func move(_ position: inout TextPosition) {
        position.moveBackwardInLine()
        position.moveToBeginningOfWord()
    }
}

struct VimLineStart: VimMotion {
    func move(_ position: inout TextPosition) {
        position.moveToBeginningOfLine()
    }
}

struct VimLineEnd: VimMotion {
    func move(_ position: inout TextPosition) {
        position.moveToEndOfLine()
    }
}

struct VimLineFirstNonBlankCharacter: VimMotion {
    func move(_ position: inout TextPosition) {
        position.moveToBeginningOfLine()
        position.moveForward(while: { $0 == " " })
    }
}
