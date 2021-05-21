import Carbon.HIToolbox
import Foundation

class EditorModeVisual: EditorMode {
    let mode: Mode = .visual

    weak var modeSwitcher: EditorModeSwitcher?
    let register: Register
    let editor: BufferEditor

    lazy var reader = CompositeReader(createCommands())

    func createCommands() -> [Reader] {[
        SelectionCommandHandler(command: VisualModeMove(editor: editor, selection: selection, modeSwitcher: modeSwitcher)),
        CommandHandler("d", command: VisualModeDelete(register: register, editor: editor, modeSwitcher: modeSwitcher))
    ]}

    var selection: VimSelection

    private var onKeyUp: (() -> Void)?

    init(modeSwitcher: EditorModeSwitcher, selection: VimSelection? = nil, register: Register, editor: BufferEditor) {
        self.modeSwitcher = modeSwitcher
        self.selection = selection ?? VimSelection(anchor: editor.getSelectedTextRange().location)
        self.register = register
        self.editor = editor
        updateSelection()
    }

    func updateSelection() {
        self.editor.setSelectedTextRange(selection.range)
    }
    
    func handleKeyEvent(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        if keyEvent.event == .up {
            self.onKeyUp?()
            return true
        }

        if keyEvent.key.keycode == kVK_Escape && keyEvent.event == .down {
            modeSwitcher?.switchToCommandMode()
            return true
        }

        if reader.feed(character: keyEvent.key.char) {
            return true
        }

        modeSwitcher?.switchToCommandMode()
        return true
    }
}
