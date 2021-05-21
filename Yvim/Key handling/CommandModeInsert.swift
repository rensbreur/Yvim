import Foundation

class CommandModeInsert: EditorCommand {
    let editor: BufferEditor
    weak var modeSwitcher: EditorModeSwitcher?

    init(editor: BufferEditor, modeSwitcher: EditorModeSwitcher?) {
        self.editor = editor
        self.modeSwitcher = modeSwitcher
    }

    func handleEvent() {
        let insert = FreeTextOperations.Insert()
        insert.performFirstTime(self.editor)
        modeSwitcher?.switchToInsertMode(freeTextCommand: insert)
    }
}
