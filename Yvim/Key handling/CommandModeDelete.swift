import Foundation

class CommandModeDelete: Reader {
    let register: Register
    let commandMemory: CommandMemory
    let editor: BufferEditor
    weak var modeSwitcher: EditorModeSwitcher?

    init(register: Register, commandMemory: CommandMemory, editor: BufferEditor, modeSwitcher: EditorModeSwitcher?) {
        self.register = register
        self.commandMemory = commandMemory
        self.editor = editor
        self.modeSwitcher = modeSwitcher
    }

    let textObjectReader = ExtendedTextObjectReader()

    lazy var reader = PrefixedReader(prefix: KeyConstants.delete, reader: textObjectReader)

    func feed(character: Character) -> Bool {
        if reader.feed(character: character) {
            if let textObject = textObjectReader.textObject {
                let command = Commands.Delete(register: self.register, textObject: textObject)
                command.perform(editor)
                commandMemory.mostRecentCommand = command
                modeSwitcher?.switchToCommandMode()
            }
            return true
        }
        return false
    }
}

class PrefixedReader: Reader {
    let prefix: Character
    let reader: Reader

    var prefixSuccess: Bool?

    init(prefix: Character, reader: Reader) {
        self.prefix = prefix
        self.reader = reader
    }

    func feed(character: Character) -> Bool {
        if prefixSuccess == false {
            return false
        }
        if prefixSuccess == true {
            return reader.feed(character: character)
        }
        prefixSuccess = self.prefix == character
        return true
    }

}
