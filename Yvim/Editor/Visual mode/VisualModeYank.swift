import Foundation

class VisualModeYank: EditorCommand {
    let register: Register
    let editor: BufferEditor
    weak var modeSwitcher: EditorModeSwitcher?

    init(register: Register, editor: BufferEditor, modeSwitcher: EditorModeSwitcher?) {
        self.register = register
        self.editor = editor
        self.modeSwitcher = modeSwitcher
    }

    func handleEvent() {
        editor.perform {
            register.register = $0.textRange.asRegisterValue
        }
        modeSwitcher?.switchToCommandMode()
    }

}
