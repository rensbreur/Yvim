import Foundation

class ParametrizedCommandHandler: Reader {
    let key: Character
    let command: ParametrizedEditorCommand

    init(_ key: Character, command: ParametrizedEditorCommand) {
        self.key = key
        self.command = command
    }

    let multiplierReader = MultiplierReader()
    let motionReader = MotionReader()
    let verticalMotionReaderUp = SimpleReader(character: KeyConstants.VerticalMotion.up)
    let verticalMotionReaderDown = SimpleReader(character: KeyConstants.VerticalMotion.down)
    let textObjectReader = TextObjectReader()
    lazy var lineReader = SimpleReader(character: key)

    lazy var reader: Reader = PrefixedReader(
        prefix: key,
        reader: SequentialReader([
            multiplierReader,
            CompositeReader([
                motionReader,
                verticalMotionReaderUp,
                verticalMotionReaderDown,
                textObjectReader,
                lineReader
            ])
        ])
    )

    func feed(character: Character) -> Bool {
        if reader.feed(character: character) {
            if let motion = motionReader.motion {
                let textObject = TextObjects.FromMotion(motion: motion.multiplied(multiplierReader.multiplier ?? 1))
                command.handle(textObject: textObject)
            }
            if let textObject = textObjectReader.textObject {
                command.handle(textObject: textObject)
            }
            if lineReader.success {
                let textObject = TextObjects.Line(expansion: (multiplierReader.multiplier ?? 1) - 1)
                command.handle(textObject: textObject)
            }
            if verticalMotionReaderUp.success {
                let textObject = TextObjects.Line(expansion: (multiplierReader.multiplier ?? 1) * -1)
                command.handle(textObject: textObject)
            }
            if verticalMotionReaderDown.success {
                let textObject = TextObjects.Line(expansion: (multiplierReader.multiplier ?? 1))
                command.handle(textObject: textObject)
            }
            return true
        }
        return false
    }

}


class CommandHandler: Reader {
    func feed(character: Character) -> Bool {
        reader.feed(character: character) && { command.handleEvent(); return true }()
    }

    let key: Character
    let command: EditorCommand

    init(_ key: Character, command: EditorCommand) {
        self.key = key
        self.command = command
    }

    private lazy var reader: Reader = SimpleReader(character: key)
}
