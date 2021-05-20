import Foundation

class CommandModeDelete: EditorCommand {
    let register: Register
    let commandMemory: CommandMemory
    let editor: BufferEditor
    weak var modeSwitcher: EditorModeSwitcher?

    init(register: Register, commandMemory: CommandMemory, editor: BufferEditor, modeSwitcher: EditorModeSwitcher?) {
        self.register = register
        self.commandMemory = commandMemory
        self.editor = editor
        self.modeSwitcher = modeSwitcher
    }

    let multiplierReader = MultiplierReader()
    let motionReader = MotionReader()
    let textObjectReader = TextObjectReader()
    let lineReader = SimpleReader(character: KeyConstants.delete) // `dd` deletes full line

    lazy var reader: Reader = PrefixedReader(
        prefix: KeyConstants.delete,
        reader: CompositeReader(
            [motionReader, textObjectReader, lineReader]
        )
    )

    func handleEvent() {
        if let motion = motionReader.motion {
            let textObject = TextObjects.FromMotion(motion: motion.multiplied(multiplierReader.multiplier ?? 1))
            delete(textObject)
            return
        }
        if let textObject = textObjectReader.textObject {
            delete(textObject)
            return
        }
        if lineReader.success {
            deleteLine()
            return
        }
    }

    private func delete(_ textObject: TextObject) {
        let command = Commands.Delete(register: self.register, textObject: textObject)
        command.perform(editor)
        commandMemory.mostRecentCommand = command
        modeSwitcher?.switchToCommandMode()
    }

    private func deleteLine() {
        let textObject = TextObjects.Line()
        let command = Commands.DeleteLine(register: self.register, textObject: textObject)
        command.perform(editor)
        commandMemory.mostRecentCommand = command
        modeSwitcher?.switchToCommandMode()
    }
}
