import Foundation

class VisualModeDelete: EditorCommand {
    let register: Register
    let editor: BufferEditor
    weak var modeSwitcher: EditorModeSwitcher?

    init(register: Register, editor: BufferEditor, modeSwitcher: EditorModeSwitcher?) {
        self.register = register
        self.editor = editor
        self.modeSwitcher = modeSwitcher
    }

    let reader: Reader = SimpleReader(character: KeyConstants.delete)

    func handleEvent() {
        register.register = editor.getSelectedText() as String
        editor.setSelectedText("")
        modeSwitcher?.switchToCommandMode()
    }
}
