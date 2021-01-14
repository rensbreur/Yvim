//
//  MotionParser.swift
//  Yvim
//
//  Created by Admin on 05.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

class MotionParser: ActionParser {
    private var parametrizedMotion: ParametrizedVimMotion.Type?

    func feed(_ character: Character) -> (Bool, ParseResult<VimMotion>) {
        if let parametrizedMotion = self.parametrizedMotion {
            return (true, .success(parametrizedMotion.init(parameter: character.utf16.first!)))
        }

        if let parametrizedMotion = readParametrizedMotion(character) {
            self.parametrizedMotion = parametrizedMotion
            return (true, .needMore)
        }

        if let motion = readMotion(character) {
            return (true, .success(motion))
        }

        return (false, .fail)
    }

    private func readMotion(_ character: Character) -> VimMotion? {
        switch character {
        case KeyConstants.Motion.forward:
            return VimMotionForward()
        case KeyConstants.Motion.backward:
            return VimMotionBackward()
        case KeyConstants.Motion.word:
            return VimWord()
        case KeyConstants.Motion.wordBack:
            return VimBack()
        case KeyConstants.Motion.wordEnd:
            return VimEnd()
        case KeyConstants.Motion.lineStart:
            return VimLineStart()
        case KeyConstants.Motion.lineEnd:
            return VimLineEnd()
        case KeyConstants.Motion.lineFirstNonBlank:
            return VimLineFirstNonBlankCharacter()
        default:
            return nil
        }
    }

    private func readParametrizedMotion(_ character: Character) -> ParametrizedVimMotion.Type? {
        switch character {
        case KeyConstants.Motion.find:
            return VimFind.self
        case KeyConstants.Motion.findReverse:
            return VimFindReverse.self
        case KeyConstants.Motion.til:
            return VimTil.self
        case KeyConstants.Motion.tilReverse:
            return VimTilReverse.self
        default:
            return nil
        }
    }

}
