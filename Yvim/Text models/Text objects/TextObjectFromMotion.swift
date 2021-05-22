import Foundation

extension TextObjects {
    struct FromMotion: TextObject {
        let motion: LineMotion

        func expand(_ range: inout TextRange) {
            let a = range.start
            let b = motion.index(from: a, in: range.text)
            range.start = min(a, b)
            range.end = max(a, b)
        }
    }
}
