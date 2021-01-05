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
            return (true, .success(.find(char: character)))
        }
        if self.til {
            return (true, .success(.find(char: character)))
        }
        if self.findReverse {
            return (true, .success(.findReverse(char: character)))
        }
        if self.tilReverse {
            return (true, .success(.tilReverse(char: character)))
        }
        switch character {
        case "l":
            return (true, .success(.forward))
        case "h":
            return (true, .success(.backward))
        case "j":
            return (true, .success(.down))
        case "k":
            return (true, .success(.up))
        case "f":
            self.find = true
            return (true, .needMore)
        case "F":
            self.findReverse = true
            return (true, .needMore)
        case "t":
            self.til = true
            return (true, .needMore)
        case "T":
            self.tilReverse = true
            return (true, .needMore)
        case "w":
            return (true, .success(.nextWord))
        case "b":
            return (true, .success(.wordBegin))
        case "e":
            return (true, .success(.wordEnd))
        case "0":
            return (true, .success(.lineStart))
        case "$":
            return (true, .success(.lineEnd))
        case "^":
            return (true, .success(.lineFirstNonBlankCharacter))
        default:
            return (false, .fail)
        }
    }
}
