import Foundation

class MotionReader {
    private var parametrizedMotion: LineMotionParametrized.Type?

    var motion: LineMotion?

    func feed(character: Character) -> Bool {
        let char = character

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

        return false
    }

    private func readMotion(_ character: Character) -> LineMotion? {
        switch character {
        case KeyConstants.Motion.forward:
            return LineMotions.Forward()
        case KeyConstants.Motion.backward:
            return LineMotions.Backward()
        case KeyConstants.Motion.word:
            return LineMotions.Word()
        case KeyConstants.Motion.wordBack:
            return LineMotions.Back()
        case KeyConstants.Motion.wordEnd:
            return LineMotions.End()
        case KeyConstants.Motion.lineStart:
            return LineMotions.LineStart()
        case KeyConstants.Motion.lineEnd:
            return LineMotions.LineEnd()
        case KeyConstants.Motion.lineFirstNonBlank:
            return LineMotions.LineFirstNonBlankCharacter()
        default:
            return nil
        }
    }

    private func readParametrizedMotion(_ character: Character) -> LineMotionParametrized.Type? {
        switch character {
        case KeyConstants.Motion.find:
            return LineMotions.Find.self
        case KeyConstants.Motion.findReverse:
            return LineMotions.FindReverse.self
        case KeyConstants.Motion.til:
            return LineMotions.Til.self
        case KeyConstants.Motion.tilReverse:
            return LineMotions.TilReverse.self
        default:
            return nil
        }
    }

}
