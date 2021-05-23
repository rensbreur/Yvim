import Foundation

extension TextObjects {
    struct Line: TextObject, Equatable {
        /// If non-zero, the relative lines that are included as well.
        /// E.g. -1 includes the line before, 2 will select 3 lines in total.
        let expansion: Int

        func expand(_ range: inout TextRange) {
            range.expandToBeginningOfLine()
            range.expandToNewline()
            if expansion < 0 {
                for _ in 0 ..< abs(expansion) {
                    range.expandBackward()
                    range.expandToBeginningOfLine()
                }
            }
            if expansion > 0 {
                for _ in 0 ..< expansion {
                    range.expandForward()
                    range.expandToNewline()
                }
            }
        }
    }
}
