import Carbon.HIToolbox
import Foundation

class EditorModeVisual: EditorMode {
    let mode: Mode = .visual

    weak var modeSwitcher: EditorModeSwitcher?
    let register: Register
    let editor: BufferEditor

    let multiplierReader = MultiplierReader()
    let motionReader = MotionReader()
    let textObjectReader = TextObjectReader()
    lazy var selectionCommandReader = ParametrizedCommandReader(register: register)
    let changeTextReader = SimpleReader(character: KeyConstants.change)

    lazy var reader = CompositeReader(readers: [motionReader, textObjectReader, selectionCommandReader, changeTextReader])

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

        if multiplierReader.feed(character: keyEvent.key.char) {
            return true
        }

        if reader.feed(character: keyEvent.key.char) {
            if let motion = motionReader.motion {
                self.selection.move(motion: motion.multiplied(multiplierReader.multiplier ?? 1), in: editor.getText())
                modeSwitcher?.switchToVisualMode(selection: self.selection)
            }

            if let textObject = textObjectReader.textObject {
                self.selection.expand(textObject: textObject, in: editor.getText())
                modeSwitcher?.switchToVisualMode(selection: self.selection)
            }

            if let command = selectionCommandReader.command {
                //command.perform(editor)
                modeSwitcher?.switchToCommandMode()
            }

            if changeTextReader.success {
                let change = FreeTextCommands.Change(register: register, textObject: TextObjects.Empty())
                editor.setSelectedText("")
                modeSwitcher?.switchToInsertMode(freeTextCommand: change)
            }

            return true
        }

        modeSwitcher?.switchToCommandMode()
        return true
    }
}
