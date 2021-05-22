import Foundation

extension LineMotions {
    struct FindReverse: LineMotionParametrized {
        let parameter: unichar
        func move(_ position: inout TextPosition) {
            let originialPosition = position.position
            position.moveBackward(ensuring: { $0 != parameter && $0 != "\n" })
            position.moveBackwardInLine()
            if position.text.safeCharacter(at: position.position) != parameter {
                position.position = originialPosition
            }
        }
    }
}
