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

    private let commandFactory: CommandFactory

    init(commandFactory: CommandFactory) {
        self.commandFactory = commandFactory
    }

    func feed(character: Character) -> Bool {
        switch character {
        case KeyConstants.delete:
            self.command = commandFactory.createDeleteCommand()
        case KeyConstants.yank:
            self.command = commandFactory.createYankCommand()
        case KeyConstants.paste:
            self.command = commandFactory.createPasteCommand()
        default:
            return false
        }
        return true
    }
}

struct CommandFactory {
    let register: Register

    func createDeleteCommand() -> Commands.Delete {
        Commands.Delete(register: self.register)
    }

    func createYankCommand() -> Commands.Yank {
        Commands.Yank(register: self.register)
    }

    func createPasteCommand() -> Commands.Paste {
        Commands.Paste(register: self.register)
    }
}
