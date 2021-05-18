import Foundation

class EditorModeCommandParameter: EditorMode {
    let mode: Mode = .command

    unowned var context: YvimKeyHandler

    let commandMultiplier: Int
    let command: Command

    let multiplierReader = MultiplierReader()
    let motionReader = MotionReader()

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

        if motionReader.feed(character: keyEvent.key.char) {
            if let motion = motionReader.motion {
                context.editor.changeSelection(motion.multiplied(multiplierReader.multiplier ?? 1), simulateKeyPress: simulateKeyPress)
                command.perform(editor: context.editor)
                context.switchToCommandMode()
            }
            return true
        }

        context.switchToCommandMode()
        return true
    }

}
