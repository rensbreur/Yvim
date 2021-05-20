import Foundation

class PrefixedReader: Reader {
    let prefix: Character
    let reader: Reader

    var prefixSuccess: Bool?

    init(prefix: Character, reader: Reader) {
        self.prefix = prefix
        self.reader = reader
    }

    func feed(character: Character) -> Bool {
        if prefixSuccess == false {
            return false
        }
        if prefixSuccess == true {
            return reader.feed(character: character)
        }
        let match = self.prefix == character
        prefixSuccess = match
        return match
    }

}
