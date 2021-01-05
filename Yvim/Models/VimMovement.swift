//
//  VimMovement.swift
//  Yvim
//
//  Created by Admin on 04.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

enum VimMovement {
    case forward
    case backward
    case up
    case down
    case find(char: Character)
    case findReverse(char: Character)
    case til(char: Character)
    case tilReverse(char: Character)
    case nextWord
    case wordBegin
    case wordEnd
    case lineStart
    case lineEnd
    case lineFirstNonBlankCharacter
}
