import Foundation

protocol SelectionCommand {
    func handle(motion: LineMotion)
    func handle(textObject: TextObject)
}

class CommandHandlerSelection: Reader {
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
