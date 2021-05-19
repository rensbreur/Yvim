import Foundation

class SimpleReader: Reader {
    let character: Character

    init(character: Character) {
        self.character = character
    }

    private(set) var success = false

    func feed(character: Character) -> Bool {
        if character == self.character {
            self.success = true
            return true
        }
        return false
    }
}
