import Foundation
@testable import Yvim

extension Yvim.TextRange {
    init(_ text: String, _ selection: String) {
        var selection = selection
        selection.removeAll(where: { $0 == "_" })
        let start = text.distance(from: text.startIndex, to: selection.firstIndex(of: "*")!)
        let end = text.distance(from: text.startIndex, to: selection.lastIndex(of: "*")!)
        self.init(text: text as NSString, start: start, end: end)
    }
}
