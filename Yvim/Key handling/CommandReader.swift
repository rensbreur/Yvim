import Foundation

class CommandReader: Reader {
    let register: Register

    var command: Command?

    init(register: Register) {
        self.register = register
    }

    func feed(character: Character) -> Bool {
        switch character {
        case KeyConstants.pasteBefore:
            self.command = Commands.Paste(register: self.register)
        case KeyConstants.pasteAfter:
            self.command = Commands.PasteAfter(register: self.register)
        default:
            return false
        }
        return true
    }
}
