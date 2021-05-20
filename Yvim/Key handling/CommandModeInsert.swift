import Foundation

class CommandModeInsert: EditorCommand {
    let editor: BufferEditor
    weak var modeSwitcher: EditorModeSwitcher?

    init(editor: BufferEditor, modeSwitcher: EditorModeSwitcher?) {
        self.editor = editor
        self.modeSwitcher = modeSwitcher
    }

    let reader: Reader = SimpleReader(character: KeyConstants.insert)

    func handleEvent() {
        let insert = FreeTextCommands.Insert()
        insert.performFirstTime(self.editor)
        modeSwitcher?.switchToInsertMode(freeTextCommand: insert)
    }
}
