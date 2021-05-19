import Carbon.HIToolbox
import Foundation

class EditorModeVisual: EditorMode {
    let mode: Mode = .visual

    unowned var context: YvimKeyHandler

    let multiplierReader = MultiplierReader()
    let motionReader = MotionReader()
    let textObjectReader = TextObjectReader()
    let selectionCommandReader = SelectionCommandReader()

    var selection: VimSelection

    private var onKeyUp: (() -> Void)?

    init(context: YvimKeyHandler, selection: VimSelection? = nil) {
        self.context = context
        self.selection = selection ?? VimSelection(anchor: context.editor.bufferEditor.getSelectedTextRange().location)
        updateSelection()
    }

    func updateSelection() {
        self.context.editor.bufferEditor.setSelectedTextRange(selection.range)
    }
    
    func handleKeyEvent(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool {
        if keyEvent.event == .up {
            self.onKeyUp?()
            return true
        }

        if multiplierReader.feed(character: keyEvent.key.char) {
            return true
        }

        var characterWasRead = false

        if motionReader.feed(character: keyEvent.key.char) {
            if let motion = motionReader.motion {
                self.selection.move(motion: motion.multiplied(multiplierReader.multiplier ?? 1), in: context.editor.bufferEditor.getText())
                context.switchToVisualMode(selection: self.selection)
                return true
            }
            characterWasRead = true
        }

        if textObjectReader.feed(character: keyEvent.key.char) {
            if let textObject = textObjectReader.textObject {
                self.selection.expand(textObject: textObject, in: context.editor.bufferEditor.getText())
                context.switchToVisualMode(selection: self.selection)
                return true
            }
            characterWasRead = true
        }

        if selectionCommandReader.feed(character: keyEvent.key.char) {
            if let command = selectionCommandReader.command {
                command.perform(editor: context.editor)
                context.switchToCommandMode()
                return true
            }
            characterWasRead = true
        }

        if (!characterWasRead) {
            context.switchToCommandMode()
        }

        return true
    }
}
