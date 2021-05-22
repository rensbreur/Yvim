import Foundation

extension NSString {
    func safeCharacter(at index: Int) -> unichar? {
        guard index >= 0 else { return nil }
        guard index < length else { return nil }
        return character(at: index)
    }
}
