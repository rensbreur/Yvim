import Foundation

protocol LineMotion {
    func move(_ position: inout TextPosition)
}

extension LineMotion {
    func index(from index: Int, in text: NSString) -> Int {
        var position = TextPosition(text: text, position: index)
        move(&position)
        return position.position
    }
}

protocol LineMotionParametrized: LineMotion {
    init(parameter: unichar)
}

enum LineMotions {}
