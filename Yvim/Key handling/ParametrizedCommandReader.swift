import Foundation

class ParametrizedCommandReader: Reader {
    let register: Register

    var command: Command?

    init(register: Register) {
        self.register = register
    }

    func feed(character: Character) -> Bool {
        switch character {
        case KeyConstants.delete:
            self.command = Commands.Delete(register: self.register)
        case KeyConstants.yank:
            self.command = Commands.Yank(register: self.register)
        case KeyConstants.paste:
            self.command = Commands.Paste(register: self.register)
        default:
            return false
        }
        return true
    }
}
