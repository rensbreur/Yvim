import Foundation

class SequentialReader: Reader {
    let readers: [Reader]

    init(_ readers: [Reader]) {
        self.readers = readers.map(AutofailingReader.init)
    }

    func feed(character: Character) -> Bool {
        for reader in readers {
            if reader.feed(character: character) {
                return true
            }
        }
        return false
    }
}
