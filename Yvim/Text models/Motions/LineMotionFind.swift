import Foundation

extension LineMotions {
    struct Find: LineMotionParametrized {
        let parameter: unichar
        func move(_ position: inout TextPosition) {
            let originialPosition = position.position
            position.moveForward(ensuring: { $0 != parameter && $0 != "\n" })
            position.moveForwardInLine()
            if position.text.safeCharacter(at: position.position) != parameter {
                position.position = originialPosition
            }
        }
    }
}
