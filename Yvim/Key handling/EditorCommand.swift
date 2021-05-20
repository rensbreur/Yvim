import Foundation

protocol EditorCommand: Reader {
    func handleEvent()
    var reader: Reader { get }
}

extension EditorCommand {
    func feed(character: Character) -> Bool {
        if reader.feed(character: character) {
            handleEvent()
            return true
        }
        return false
    }
}
