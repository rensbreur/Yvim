import Carbon.HIToolbox
import Foundation

class EditorModeVisual: EditorMode {
    let mode: Mode = .visual

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
                context.editor.changeSelection(motion, multiplier: multiplierReader.multiplier ?? 1, simulateKeyPress: simulateKeyPress)
                context.switchToVisualMode()
            }
            return true
        }

        if selectionCommandReader.feed(character: keyEvent.key.char) {
            if let command = selectionCommandReader.command {
                command.perform(editor: context.editor)
                context.switchToCommandMode()
            }
            return true
        }

        context.switchToCommandMode()
        return true
    }
}
