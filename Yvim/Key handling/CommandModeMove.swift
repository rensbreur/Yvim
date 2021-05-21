import Carbon.HIToolbox
import Foundation

class MotionCommandHandler: Reader {
    let multiplierReader = MultiplierReader()
    let motionReader = MotionReader()
    let verticalMotionReaderUp = SimpleReader(character: KeyConstants.VerticalMotion.up)
    let verticalMotionReaderDown = SimpleReader(character: KeyConstants.VerticalMotion.down)

    let command: MotionCommand

    init(command: MotionCommand) {
        self.command = command
    }

    lazy var reader: Reader = SequentialReader([
        multiplierReader,
        CompositeReader([
            motionReader,
            verticalMotionReaderUp,
            verticalMotionReaderDown
        ])
    ])

    func feed(character: Character) -> Bool {
        if reader.feed(character: character) {
            if let motion = motionReader.motion {
                command.handle(motion: motion.multiplied(multiplierReader.multiplier ?? 1))
            }
            if verticalMotionReaderUp.success {
                command.handleUp()
            }
            if verticalMotionReaderDown.success {
                command.handleDown()
            }
            return true
        }
        return false
    }
}

class CommandModeMove: MotionCommand {
    let editor: BufferEditor
    weak var keySimulator: KeyPressSimulator?
    weak var modeSwitcher: EditorModeSwitcher?

    init(editor: BufferEditor, keySimulator: KeyPressSimulator, modeSwitcher: EditorModeSwitcher?) {
        self.editor = editor
        self.keySimulator = keySimulator
        self.modeSwitcher = modeSwitcher
    }

    func handle(motion: LineMotion) {
        Operations.Move(motion: motion).perform(editor)
        modeSwitcher?.switchToCommandMode()
    }

    func handleUp() {
        keySimulator?.simulateKeyPress(CGKeyCode(kVK_UpArrow), [])
        modeSwitcher?.switchToCommandMode()
    }

    func handleDown() {
        keySimulator?.simulateKeyPress(CGKeyCode(kVK_DownArrow), [])
        modeSwitcher?.switchToCommandMode()
    }
}
