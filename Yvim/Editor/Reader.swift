import Foundation

protocol Reader {
    func feed(character: Character) -> Bool
}
