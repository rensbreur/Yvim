import Carbon.HIToolbox
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

        if keyEvent.key.keycode == kVK_Escape && keyEvent.event == .down {
            context.switchToCommandMode()
            return true
        }

        if multiplierReader.feed(character: keyEvent.key.char) {
            return true
        }

        var characterWasRead = false

        if motionReader.feed(character: keyEvent.key.char) {
            if let motion = motionReader.motion {
                let motion = Commands.ChangeSelection(motion: motion.multiplied(multiplierReader.multiplier ?? 1))
                let composite = Commands.Composite(commands: [motion, command])
                composite.perform(context.editor)
                context.mostRecentCommand = composite
                context.switchToCommandMode()
                return true
            }
            characterWasRead = true
        }

        if textObjectReader.feed(character: keyEvent.key.char) {
            if let textObject = textObjectReader.textObject {
                let selection = Commands.ChangeSelectionWithTextObject(textObject: textObject)
                let composite = Commands.Composite(commands: [selection, command])
                composite.perform(context.editor)
                context.mostRecentCommand = composite
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
