import Foundation

class CommandModeDelete: EditorCommand {
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
    lazy var reader: Reader = PrefixedReader(prefix: KeyConstants.delete, reader: textObjectReader)

    func handleEvent() {
        if let textObject = textObjectReader.textObject {
            let command = Commands.Delete(register: self.register, textObject: textObject)
            command.perform(editor)
            commandMemory.mostRecentCommand = command
            modeSwitcher?.switchToCommandMode()
        }
    }
}
