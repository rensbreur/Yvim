import Foundation

class EditorModeCommandParameter: EditorMode {
    let mode: Mode = .command

    unowned var context: YvimKeyHandler

    let commandMultiplier: Int
    let command: Command

    let multiplierReader = MultiplierReader()
    let motionReader = MotionReader()
    let textObjectReader = TextObjectReader()

    private var onKeyUp: (() -> Void)?

    init(context: YvimKeyHandler, command: Command, multiplier: Int) {
        self.context = context
        self.command = command
        self.commandMultiplier = multiplier
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
                context.editor.changeSelection(motion.multiplied(multiplierReader.multiplier ?? 1), simulateKeyPress: simulateKeyPress)
                command.perform(editor: context.editor)
                context.switchToCommandMode()
                return true
            }
            characterWasRead = true
        }

        if textObjectReader.feed(character: keyEvent.key.char) {
            if let textObject = textObjectReader.textObject {
                let operation = BufferEditorOperation(editor: context.editor.bufferEditor)
                let newRange = textObject.range(from: operation.cursorPosition, in: operation.text)
                operation.selectedTextRange = newRange
                operation.commit()
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
