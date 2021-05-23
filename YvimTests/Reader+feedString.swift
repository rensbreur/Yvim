import Foundation
@testable import Yvim

extension Reader {
    func feed(string: String) {
        for character in string {
            _ = feed(character: Character(String(character)))
        }
    }
}
