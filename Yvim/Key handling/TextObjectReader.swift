import Foundation

class TextObjectReader {
    enum Range {
        case outer
        case inner
    }

    private var range: Range?

    private(set) var invalid = false

    var textObject: TextObject?

    func feed(character: Character) -> Bool {
        if invalid {
            return false
        }

        if let range = self.range {
            if character == KeyConstants.TextObject.word {
                self.textObject = TextObjects.InnerWord()
                return true
            }
            self.range = nil
            return false
        }

        if character == KeyConstants.TextObject.inner {
            self.range = .inner
            return true
        }

        invalid = true
        return false
    }

}
