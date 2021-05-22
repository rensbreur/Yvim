import Foundation

extension unichar: ExpressibleByUnicodeScalarLiteral {
    public init(unicodeScalarLiteral value: Character) {
        self = value.utf16.first!
    }
}
