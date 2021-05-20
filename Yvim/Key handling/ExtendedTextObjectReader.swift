import Foundation

/// Parses not only text objects, but also (multiplied) motions
class ExtendedTextObjectReader: Reader {
    let multiplierReader = MultiplierReader()
    let motionReader = MotionReader()
    let textObjectReader = TextObjectReader()

    var textObject: TextObject?

    lazy var reader: CompositeReader = CompositeReader(readers: [motionReader, textObjectReader])

    func feed(character: Character) -> Bool {
        if multiplierReader.feed(character: character) {
            return true
        }

        if reader.feed(character: character) {
            if let motion = motionReader.motion {
                textObject = TextObjects.FromMotion(motion: motion.multiplied(multiplierReader.multiplier ?? 1))
            }

            if let textObject = textObjectReader.textObject {
                self.textObject = textObject
            }

            return true
        }

        return false
    }

}
