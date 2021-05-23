import Foundation

protocol MotionCommand {
    func handle(motion: LineMotion)
    func handleUp()
    func handleDown()
}

class CommandHandlerMotion: Reader {
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
