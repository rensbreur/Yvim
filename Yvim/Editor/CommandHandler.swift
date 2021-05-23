import Foundation

protocol EditorCommand {
    func handleEvent()
}

class CommandHandler: Reader {
    func feed(character: Character) -> Bool {
        reader.feed(character: character) && { command.handleEvent(); return true }()
    }

    let key: Character
    let command: EditorCommand

    init(_ key: Character, command: EditorCommand) {
        self.key = key
        self.command = command
    }

    private lazy var reader: Reader = SimpleReader(character: key)
}
