import Foundation

protocol LineMotion {
    func move(_ position: inout TextPosition)
}

extension LineMotion {
    func index(from index: Int, in text: NSString) -> Int {
        var position = TextPosition(text: text, position: index)
        move(&position)
        return position.position
    }
}

protocol LineMotionParametrized: LineMotion {
    init(parameter: unichar)
}

enum LineMotions {
    struct Forward: LineMotion {
        func move(_ position: inout TextPosition) {
            position.moveForwardInLine()
        }
    }

    struct Backward: LineMotion {
        func move(_ position: inout TextPosition) {
            position.moveBackwardInLine()
        }
    }

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

    struct TilReverse: LineMotionParametrized {
        let parameter: unichar
        func move(_ position: inout TextPosition) {
            let originialPosition = position.position
            position.moveBackward()
            position.moveBackward(ensuring: { $0 != parameter && $0 != "\n" })
            if position.text.safeCharacter(at: position.position - 1) != parameter {
                position.position = originialPosition
            }
        }
    }

    struct Word: LineMotion {
        func move(_ position: inout TextPosition) {
            position.moveToNextWord()
        }
    }

    struct End: LineMotion {
        func move(_ position: inout TextPosition) {
            position.moveToEndOfWord()
        }
    }

    struct Back: LineMotion {
        func move(_ position: inout TextPosition) {
            position.moveBackwardInLine()
            position.moveToBeginningOfWord()
        }
    }

    struct LineStart: LineMotion {
        func move(_ position: inout TextPosition) {
            position.moveToBeginningOfLine()
        }
    }

    struct LineEnd: LineMotion {
        func move(_ position: inout TextPosition) {
            position.moveToEndOfLine()
        }
    }

    struct LineFirstNonBlankCharacter: LineMotion {
        func move(_ position: inout TextPosition) {
            position.moveToBeginningOfLine()
            position.moveForward(ensuring: { $0 == " " })
            position.moveForward()
        }
    }
}

struct LineMotionMultiplied: LineMotion {
    let motion: LineMotion
    let multiplier: Int

    func move(_ position: inout TextPosition) {
        for _ in 0 ..< multiplier {
            motion.move(&position)
        }
    }
}

extension LineMotion {
    func multiplied(_ multiplier: Int) -> LineMotion {
        LineMotionMultiplied(motion: self, multiplier: multiplier)
    }
}
