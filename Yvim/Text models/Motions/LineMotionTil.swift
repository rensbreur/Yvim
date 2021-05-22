import Foundation

extension LineMotions {
    struct Til: LineMotionParametrized {
        let parameter: unichar
        func move(_ position: inout TextPosition) {
            let originialPosition = position.position
            position.moveForward()
            position.moveForward(ensuring: { $0 != parameter && $0 != "\n" })
            if position.text.safeCharacter(at: position.position + 1) != parameter {
                position.position = originialPosition
            }
        }
    }
}
