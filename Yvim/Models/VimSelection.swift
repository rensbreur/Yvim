import Foundation

struct VimSelection {
    init(anchor: Int, movable: Int? = nil) {
        self.anchor = anchor
        self.movable = movable ?? anchor
    }

    private(set) var anchor: Int
    private(set) var movable: Int

    var start: Int {
        min(anchor, movable)
    }

    var end: Int {
        if movable <= anchor {
            return anchor + 1
        }
        return movable + 1
    }

    mutating func move(motion: LineMotion, in text: NSString) {
        movable = motion.index(from: movable, in: text)
    }

    mutating func expand(textObject: TextObject, in text: NSString) {
        let range = textObject.range(from: anchor, in: text)
        self.anchor = range.location
        self.movable = range.location + range.length - 1
    }

    var range: CFRange {
        CFRange(location: start, length: end - start)
    }
}
