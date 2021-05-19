import Foundation

class MotionReader: Reader {
    private var parametrizedMotion: LineMotionParametrized.Type?

    var motion: LineMotion?

    private(set) var invalid = false

    func feed(character: Character) -> Bool {
        let char = character

        if invalid { return false }

        if let parametrizedMotion = self.parametrizedMotion {
            self.motion = parametrizedMotion.init(parameter: char.utf16.first!)
            return true
        }

        if let parametrizedMotion = readParametrizedMotion(char) {
            self.parametrizedMotion = parametrizedMotion
            return true
        }

        if let motion = readMotion(char) {
            self.motion = motion
            return true
        }

        invalid = true
        return false
    }

    private func readMotion(_ character: Character) -> LineMotion? {
        switch character {
        case KeyConstants.LineMotion.forward:
            return LineMotions.Forward()
        case KeyConstants.LineMotion.backward:
            return LineMotions.Backward()
        case KeyConstants.LineMotion.word:
            return LineMotions.Word()
        case KeyConstants.LineMotion.wordBack:
            return LineMotions.Back()
        case KeyConstants.LineMotion.wordEnd:
            return LineMotions.End()
        case KeyConstants.LineMotion.lineStart:
            return LineMotions.LineStart()
        case KeyConstants.LineMotion.lineEnd:
            return LineMotions.LineEnd()
        case KeyConstants.LineMotion.lineFirstNonBlank:
            return LineMotions.LineFirstNonBlankCharacter()
        default:
            return nil
        }
    }

    private func readParametrizedMotion(_ character: Character) -> LineMotionParametrized.Type? {
        switch character {
        case KeyConstants.LineMotion.find:
            return LineMotions.Find.self
        case KeyConstants.LineMotion.findReverse:
            return LineMotions.FindReverse.self
        case KeyConstants.LineMotion.til:
            return LineMotions.Til.self
        case KeyConstants.LineMotion.tilReverse:
            return LineMotions.TilReverse.self
        default:
            return nil
        }
    }

}
