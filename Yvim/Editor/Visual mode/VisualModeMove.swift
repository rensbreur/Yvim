import Carbon.HIToolbox
import Foundation

class VisualModeMove: SelectionCommand {
    let editor: BufferEditor
    var selection: VimSelection
    weak var modeSwitcher: EditorModeSwitcher?

    init(editor: BufferEditor, selection: VimSelection, modeSwitcher: EditorModeSwitcher?) {
        self.editor = editor
        self.selection = selection
        self.modeSwitcher = modeSwitcher
    }

    func handle(motion: LineMotion) {
        self.selection.move(motion: motion, in: editor.getText())
        modeSwitcher?.switchToVisualMode(selection: selection)
    }

    func handle(textObject: TextObject) {
        self.selection.expand(textObject: textObject, in: editor.getText())
        modeSwitcher?.switchToVisualMode(selection: self.selection)
    }
}
