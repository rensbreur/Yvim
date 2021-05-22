import Foundation

enum KeyConstants {
    enum LineMotion {
        static let forward: Character = "l"
        static let backward: Character = "h"
        static let find: Character = "f"
        static let findReverse: Character = "F"
        static let til: Character = "t"
        static let tilReverse: Character = "T"
        static let word: Character = "w"
        static let wordBack: Character = "b"
        static let wordEnd: Character = "e"
        static let lineStart: Character = "0"
        static let lineEnd: Character = "$"
        static let lineFirstNonBlank: Character = "^"
    }
    enum VerticalMotion {
        static let up: Character = "k"
        static let down: Character = "j"
    }
    enum TextObject {
        static let inner: Character = "i"
        static let word: Character = "w"
    }
    static let insert: Character = "i"
    static let add: Character = "a"
    static let delete: Character = "d"
    static let yank: Character = "y"
    static let visual: Character = "v"
    static let newLine: Character = "o"
    static let paste: Character = "p"
    static let pasteBefore: Character = "P"
    static let pasteAfter: Character = "p"
    static let undo: Character = "u"
    static let prompt: Character = ":"
    static let again: Character = "."
    static let change: Character = "c"
}
