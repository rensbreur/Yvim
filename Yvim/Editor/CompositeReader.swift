import Foundation

class CompositeReader: Reader {
    let readers: [Reader]

    init(_  readers: [Reader]) {
        self.readers = readers.map(AutofailingReader.init)
    }

    func feed(character: Character) -> Bool {
        var characterWasRead = false
        for reader in readers {
            if reader.feed(character: character) {
                characterWasRead = true
            }
        }
        return characterWasRead
    }
}

/// Does not read characters anymore after failing once
class AutofailingReader: Reader {
    let wrapped: Reader
    private(set) var failed = false

    init(_ wrapped: Reader) {
        self.wrapped = wrapped
    }

    func feed(character: Character) -> Bool {
        if failed { return false }
        if wrapped.feed(character: character) { return true }
        failed = true
        return false
    }
}
