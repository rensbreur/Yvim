//
//  MovementParser.swift
//  Yvim
//
//  Created by Admin on 05.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

class MovementParser: ActionParser {
    private var find = false
    private var findReverse = false
    private var til = false
    private var tilReverse = false

    func feed(_ character: Character) -> (Bool, ParseResult<VimMovement>) {
        if self.find {
            return (true, .success(VimFind(parameter: character.utf16.first!)))
        }
        if self.til {
            return (true, .success(VimTil(parameter: character.utf16.first!)))
        }
        if self.findReverse {
            return (true, .success(VimFindReverse(parameter: character.utf16.first!)))
        }
        if self.tilReverse {
            return (true, .success(VimTilReverse(parameter: character.utf16.first!)))
        }
        switch character {
        case KeyConstants.Motion.forward:
            return (true, .success(VimMovementForward()))
        case KeyConstants.Motion.backward:
            return (true, .success(VimMovementBackward()))
        case KeyConstants.Motion.find:
            self.find = true
            return (true, .needMore)
        case KeyConstants.Motion.findReverse:
            self.findReverse = true
            return (true, .needMore)
        case KeyConstants.Motion.til:
            self.til = true
            return (true, .needMore)
        case KeyConstants.Motion.tilReverse:
            self.tilReverse = true
            return (true, .needMore)
        case KeyConstants.Motion.word:
            return (true, .success(VimWord()))
        case KeyConstants.Motion.wordBack:
            return (true, .success(VimBack()))
        case KeyConstants.Motion.wordEnd:
            return (true, .success(VimEnd()))
        case KeyConstants.Motion.lineStart:
            return (true, .success(VimLineStart()))
        case KeyConstants.Motion.lineEnd:
            return (true, .success(VimLineEnd()))
        case KeyConstants.Motion.lineFirstNonBlank:
            return (true, .success(VimLineFirstNonBlankCharacter()))
        default:
            return (false, .fail)
        }
    }
}
