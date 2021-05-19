import Carbon.HIToolbox
import Foundation

class EditorModeCommandParameter: EditorMode {
    let mode: Mode = .command

    unowned var context: YvimKeyHandler

    let completion: (Command) -> Void

    let multiplierReader = MultiplierReader()
    let motionReader = MotionReader()
    let textObjectReader = TextObjectReader()

    lazy var reader: CompositeReader = CompositeReader(readers: [motionReader, textObjectReader])

    private var onKeyUp: (() -> Void)?

    init(context: YvimKeyHandler, completion: @escaping (Command) -> Void) {
        self.context = context
        self.completion = completion
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
                let motion = Commands.ChangeSelection(motion: motion.multiplied(multiplierReader.multiplier ?? 1))
                completion(motion)
            }

            if let textObject = textObjectReader.textObject {
                let selection = Commands.ChangeSelectionWithTextObject(textObject: textObject)
                completion(selection)
            }

            return true
        }

        context.switchToCommandMode()

        return true
    }

}
