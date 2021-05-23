import Foundation

/// Command that takes a motion or text object as parameter, e.g.
/// `d` delete (`2dd`/`diw`)
protocol ParametrizedEditorCommand {
    func handle(textObject: TextObject)
}

class CommandHandlerParametrized: Reader {
    let key: Character
    let command: ParametrizedEditorCommand

    init(_ key: Character, multiplier: MultiplierReader, command: ParametrizedEditorCommand) {
        self.key = key
        self.cmdMultiplier = multiplier
        self.command = command
    }

    let cmdMultiplier: MultiplierReader
    let multiplierReader = MultiplierReader()
    let motionReader = MotionReader()
    let verticalMotionReaderUp = SimpleReader(character: KeyConstants.VerticalMotion.up)
    let verticalMotionReaderDown = SimpleReader(character: KeyConstants.VerticalMotion.down)
    let textObjectReader = TextObjectReader()
    lazy var lineReader = SimpleReader(character: key)

    private var multiplier: Int {
        (cmdMultiplier.multiplier ?? 1) * (multiplierReader.multiplier ?? 1)
    }

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
                let textObject = TextObjects.FromMotion(motion: motion.multiplied(multiplier))
                command.handle(textObject: textObject)
            }
            if let textObject = textObjectReader.textObject {
                command.handle(textObject: textObject)
            }
            if lineReader.success {
                let textObject = TextObjects.Line(expansion: multiplier - 1)
                command.handle(textObject: textObject)
            }
            if verticalMotionReaderUp.success {
                let textObject = TextObjects.Line(expansion: multiplier * -1)
                command.handle(textObject: textObject)
            }
            if verticalMotionReaderDown.success {
                let textObject = TextObjects.Line(expansion: multiplier)
                command.handle(textObject: textObject)
            }
            return true
        }
        return false
    }

}
