import Carbon.HIToolbox
import Foundation

class EditorModeVisual: EditorMode {
    let mode: Mode = .visual

    unowned var context: EditorModeSwitcher
    let register: Register
    let editor: BufferEditor

    let multiplierReader = MultiplierReader()
    let motionReader = MotionReader()
    let textObjectReader = TextObjectReader()
    lazy var selectionCommandReader = SelectionCommandReader(commandFactory: CommandFactory(register: register))
    let changeTextReader = SimpleReader(character: KeyConstants.change)

    lazy var reader = CompositeReader(readers: [motionReader, textObjectReader, selectionCommandReader, changeTextReader])

    var selection: VimSelection

    private var onKeyUp: (() -> Void)?

    init(context: EditorModeSwitcher, selection: VimSelection? = nil, register: Register, editor: BufferEditor) {
        self.context = context
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
            context.switchToCommandMode()
            return true
        }

        if multiplierReader.feed(character: keyEvent.key.char) {
            return true
        }

        if reader.feed(character: keyEvent.key.char) {
            if let motion = motionReader.motion {
                self.selection.move(motion: motion.multiplied(multiplierReader.multiplier ?? 1), in: editor.getText())
                context.switchToVisualMode(selection: self.selection)
            }

            if let textObject = textObjectReader.textObject {
                self.selection.expand(textObject: textObject, in: editor.getText())
                context.switchToVisualMode(selection: self.selection)
            }

            if let command = selectionCommandReader.command {
                command.perform(editor)
                context.switchToCommandMode()
            }

            if changeTextReader.success {
                let change = FreeTextCommands.Change(register: register)
                change.performFirstTime(editor)
                context.switchToInsertMode(freeTextCommand: change)
            }

            return true
        }

        context.switchToCommandMode()
        return true
    }
}
