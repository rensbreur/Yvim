import Foundation

class ParametrizedCommandReader: Reader {
    let register: Register

    var command: ((TextObject) -> Command)?

    init(register: Register) {
        self.register = register
    }

    func feed(character: Character) -> Bool {
        switch character {
        case KeyConstants.delete:
            self.command = { Commands.Delete(register: self.register, textObject: $0) }
        case KeyConstants.yank:
            self.command = { Commands.Yank(register: self.register, textObject: $0) }
        case KeyConstants.paste:
            self.command = { Commands.Paste(register: self.register, textObject: $0) }
        default:
            return false
        }
        return true
    }
}
