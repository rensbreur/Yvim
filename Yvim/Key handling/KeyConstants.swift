//
//  KeyConstants.swift
//  Yvim
//
//  Created by Rens Breur on 13.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

enum KeyConstants {
    enum Motion {
        static let up: Character = "k"
        static let down: Character = "j"
        static let forward: Character = "l"
        static let backward: Character = "h"
        static let find: Character = "f"
        static let findReverse: Character = "F"
        static let til: Character = "t"
        static let tilReverse: Character = "T"
        static let word: Character = "w"
        static let wordBack: Character = "b"
        static let wordEnd: Character = "e"
        static let lineStart: Character = "0"
        static let lineEnd: Character = "$"
        static let lineFirstNonBlank: Character = "^"
    }
    static let insert: Character = "i"
    static let add: Character = "a"
    static let delete: Character = "d"
    static let yank: Character = "y"
    static let visual: Character = "v"
    static let newLine: Character = "o"
    static let paste: Character = "p"
}
