import Foundation

class MultiplierReader: Reader {
    var multiplier: Int?
    private var passthrough = false

    func feed(character: Character) -> Bool {
        if passthrough {
            return false
        }

        guard let digit = Int(String(character)), !(multiplier == nil && digit == 0) else {
            self.passthrough = true
            return false
        }
        self.multiplier = ((self.multiplier ?? 0) * 10) + digit
        return true
    }
}
