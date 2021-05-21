import Foundation

protocol EditorCommand {
    func handleEvent()
}

infix operator ~>: AdditionPrecedence

extension EditorCommand {
    static func ~>(_ lhs: Character, _ rhs: EditorCommand) -> CommandHandler {
        CommandHandler(lhs, command: rhs)
    }
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
