import Foundation

class CommandModeYank: ParametrizedEditorCommand {
    let register: Register
    let editor: BufferEditor
    weak var modeSwitcher: EditorModeSwitcher?

    init(register: Register, editor: BufferEditor, modeSwitcher: EditorModeSwitcher?) {
        self.register = register
        self.editor = editor
        self.modeSwitcher = modeSwitcher
    }

    func handle(textObject: TextObject) {
        editor.perform {
            var range = $0.textRange
            textObject.expand(&range)
            register.register = range.asRegisterValue
        }
        modeSwitcher?.switchToCommandMode()
    }

}
