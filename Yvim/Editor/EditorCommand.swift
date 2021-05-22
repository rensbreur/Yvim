import Foundation

protocol EditorCommand {
    func handleEvent()
}

protocol ParametrizedEditorCommand {
    func handle(textObject: TextObject)
}

extension ParametrizedEditorCommand {
    static func ~>(_ lhs: Character, _ rhs: ParametrizedEditorCommand) -> ParametrizedCommandHandler {
        ParametrizedCommandHandler(lhs, command: rhs)
    }
}

protocol SelectionCommand {
    func handle(motion: LineMotion)
    func handle(textObject: TextObject)
}

protocol MotionCommand {
    func handle(motion: LineMotion)
    func handleUp()
    func handleDown()
}