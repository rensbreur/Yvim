import Foundation

class CommandModeMove: Reader {
    let editor: BufferEditor
    weak var modeSwitcher: EditorModeSwitcher?

    init(editor: BufferEditor, modeSwitcher: EditorModeSwitcher?) {
        self.editor = editor
        self.modeSwitcher = modeSwitcher
    }

    let multiplierReader = MultiplierReader()
    let motionReader = MotionReader()

    lazy var reader = SequentialReader(readers: [multiplierReader, motionReader])

    func feed(character: Character) -> Bool {
        if reader.feed(character: character) {
            if let motion = motionReader.motion {
                Commands.Move(motion: motion.multiplied(multiplierReader.multiplier ?? 1)).perform(editor)
                modeSwitcher?.switchToCommandMode()
            }
            return true
        }
        return false
    }
}
