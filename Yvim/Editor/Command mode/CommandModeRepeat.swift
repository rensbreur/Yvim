import Foundation

class CommandModeRepeat: EditorCommand {
    let editor: BufferEditor
    let operationMemory: OperationMemory
    weak var modeSwitcher: EditorModeSwitcher?

    init(editor: BufferEditor, operationMemory: OperationMemory, modeSwitcher: EditorModeSwitcher?) {
        self.editor = editor
        self.operationMemory = operationMemory
        self.modeSwitcher = modeSwitcher
    }

    func handleEvent() {
        operationMemory.mostRecentCommand?.perform(editor)
        modeSwitcher?.switchToCommandMode()
    }
}
