import Foundation

class VisualModeChange: EditorCommand {
    let register: Register
    let editor: BufferEditor
    weak var modeSwitcher: EditorModeSwitcher?

    init(register: Register, editor: BufferEditor, modeSwitcher: EditorModeSwitcher?) {
        self.register = register
        self.editor = editor
        self.modeSwitcher = modeSwitcher
    }

    func handleEvent() {
        let command = FreeTextOperations.Change(register: self.register, textObject: TextObjects.Empty())
        command.performFirstTime(editor)
        modeSwitcher?.switchToInsertMode(freeTextCommand: command)
    }

}
