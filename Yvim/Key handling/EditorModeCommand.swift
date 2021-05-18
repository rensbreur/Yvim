import Carbon.HIToolbox
import Foundation

class EditorModeCommand: EditorMode {
    let mode: Mode = .command

    unowned var context: YvimKeyHandler

    let multiplierReader = MultiplierReader()
    let motionReader = MotionReader()
    let selectionCommandReader = SelectionCommandReader()

    private var onKeyUp: (() -> Void)?

    init(context: YvimKeyHandler) {
        self.context = context
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
                context.editor.move(motion.multiplied(multiplierReader.multiplier ?? 1), simulateKeyPress: simulateKeyPress)
                context.switchToCommandMode()
            }
            return true
        }

        if selectionCommandReader.feed(character: keyEvent.key.char) {
            if let command = selectionCommandReader.command {
                context.switchToCommandParameterMode(command: command, multiplier: multiplierReader.multiplier ?? 1)
            }
            return true
        }

        if keyEvent.key.char == KeyConstants.insert {
            onKeyUp = { [weak self] in self?.context.switchToInsertMode() }
            return true
        }

        if keyEvent.key.char == KeyConstants.visual {
            onKeyUp = { [weak self] in self?.context.switchToVisualMode() }
            return true
        }

        context.switchToCommandMode()
        return true
    }
}
