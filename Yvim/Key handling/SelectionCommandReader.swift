//
//  SelectionCommandReader.swift
//  Yvim
//
//  Created by Admin on 18.05.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

class SelectionCommandReader {
    var command: Command?

    func feed(character: Character) -> Bool {
        switch character {
        case KeyConstants.delete:
            self.command = Commands.Delete()
        case KeyConstants.yank:
            self.command = Commands.Yank()
        case KeyConstants.paste:
            self.command = Commands.Paste()
        default:
            return false
        }
        return true
    }
}
