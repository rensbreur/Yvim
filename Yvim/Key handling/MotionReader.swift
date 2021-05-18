import Foundation

class MotionReader {
    private var parametrizedMotion: ParametrizedVimMotion.Type?

    var motion: VimMotion?

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

    private func readMotion(_ character: Character) -> VimMotion? {
        switch character {
        case KeyConstants.Motion.forward:
            return VimMotionForward()
        case KeyConstants.Motion.backward:
            return VimMotionBackward()
        case KeyConstants.Motion.word:
            return VimWord()
        case KeyConstants.Motion.wordBack:
            return VimBack()
        case KeyConstants.Motion.wordEnd:
            return VimEnd()
        case KeyConstants.Motion.lineStart:
            return VimLineStart()
        case KeyConstants.Motion.lineEnd:
            return VimLineEnd()
        case KeyConstants.Motion.lineFirstNonBlank:
            return VimLineFirstNonBlankCharacter()
        default:
            return nil
        }
    }

    private func readParametrizedMotion(_ character: Character) -> ParametrizedVimMotion.Type? {
        switch character {
        case KeyConstants.Motion.find:
            return VimFind.self
        case KeyConstants.Motion.findReverse:
            return VimFindReverse.self
        case KeyConstants.Motion.til:
            return VimTil.self
        case KeyConstants.Motion.tilReverse:
            return VimTilReverse.self
        default:
            return nil
        }
    }

}
