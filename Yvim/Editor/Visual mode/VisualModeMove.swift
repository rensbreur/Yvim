import Carbon.HIToolbox
import Foundation

class SelectionCommandHandler: Reader {
    let command: SelectionCommand

    let multiplierReader = MultiplierReader()
    let motionReader = MotionReader()
    let textObjectReader = TextObjectReader()

    lazy var reader: Reader = SequentialReader([
        multiplierReader,
        CompositeReader([
            motionReader,
            textObjectReader
        ])
    ])

    init(command: SelectionCommand) {
        self.command = command
    }

    func feed(character: Character) -> Bool {
        if reader.feed(character: character) {
            if let motion = motionReader.motion {
                command.handle(motion: motion.multiplied(multiplierReader.multiplier ?? 1))
            }
            if let textObject = textObjectReader.textObject {
                command.handle(textObject: textObject)
            }
            return true
        }
        return false
    }
}

class VisualModeMove: SelectionCommand {
    let editor: BufferEditor
    var selection: VimSelection
    weak var modeSwitcher: EditorModeSwitcher?

    init(editor: BufferEditor, selection: VimSelection, modeSwitcher: EditorModeSwitcher?) {
        self.editor = editor
        self.selection = selection
        self.modeSwitcher = modeSwitcher
    }

    func handle(motion: LineMotion) {
        self.selection.move(motion: motion, in: editor.getText())
        modeSwitcher?.switchToVisualMode(selection: selection)
    }

    func handle(textObject: TextObject) {
        self.selection.expand(textObject: textObject, in: editor.getText())
        modeSwitcher?.switchToVisualMode(selection: self.selection)
    }
}
