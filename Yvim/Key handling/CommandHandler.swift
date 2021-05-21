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
    let textObjectReader = TextObjectReader()
    lazy var lineReader = SimpleReader(character: key)

    lazy var reader: Reader = PrefixedReader(
        prefix: key,
        reader: CompositeReader(
            [motionReader, textObjectReader, lineReader]
        )
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
                let textObject = TextObjects.Line()
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
