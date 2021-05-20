import Carbon.HIToolbox
import Foundation

class CommandModeMove: EditorCommand {
    let editor: BufferEditor
    weak var keySimulator: KeyPressSimulator?
    weak var modeSwitcher: EditorModeSwitcher?

    init(editor: BufferEditor, keySimulator: KeyPressSimulator, modeSwitcher: EditorModeSwitcher?) {
        self.editor = editor
        self.keySimulator = keySimulator
        self.modeSwitcher = modeSwitcher
    }

    let multiplierReader = MultiplierReader()
    let motionReader = MotionReader()
    let verticalMotionReaderUp = SimpleReader(character: KeyConstants.VerticalMotion.up)
    let verticalMotionReaderDown = SimpleReader(character: KeyConstants.VerticalMotion.down)

    lazy var reader: Reader = SequentialReader([
        multiplierReader,
        CompositeReader([
            motionReader,
            verticalMotionReaderUp,
            verticalMotionReaderDown
        ])
    ])

    func handleEvent() {
        if let motion = motionReader.motion {
            Commands.Move(motion: motion.multiplied(multiplierReader.multiplier ?? 1)).perform(editor)
            modeSwitcher?.switchToCommandMode()
        }
        if verticalMotionReaderUp.success {
            keySimulator?.simulateKeyPress(CGKeyCode(kVK_UpArrow), [])
            modeSwitcher?.switchToCommandMode()
        }
        if verticalMotionReaderDown.success {
            keySimulator?.simulateKeyPress(CGKeyCode(kVK_DownArrow), [])
            modeSwitcher?.switchToCommandMode()
        }
    }
}
