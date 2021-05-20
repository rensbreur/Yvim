import Carbon.HIToolbox
import Foundation

class VisualModeMove: EditorCommand {
    let editor: BufferEditor
    var selection: VimSelection
    weak var modeSwitcher: EditorModeSwitcher?

    init(editor: BufferEditor, selection: VimSelection, modeSwitcher: EditorModeSwitcher?) {
        self.editor = editor
        self.selection = selection
        self.modeSwitcher = modeSwitcher
    }

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

    func handleEvent() {
        if let motion = motionReader.motion {
            self.selection.move(motion: motion.multiplied(multiplierReader.multiplier ?? 1), in: editor.getText())
            modeSwitcher?.switchToVisualMode(selection: self.selection)
        }

        if let textObject = textObjectReader.textObject {
            self.selection.expand(textObject: textObject, in: editor.getText())
            modeSwitcher?.switchToVisualMode(selection: self.selection)
        }
    }
}
