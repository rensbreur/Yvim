import Foundation

typealias SimulateKeyPress = (CGKeyCode, CGEventFlags) -> Void

protocol KeyHandler {
    func handleKeyEvent(_ keyEvent: KeyEvent, simulateKeyPress: SimulateKeyPress) -> Bool
}

struct KeyEvent {
    enum Event {
        case up
        case down
    }
    let event: Event
    let key: Key
}

struct Key {
    let keycode: CGKeyCode
    let char: Character
    let modifierKeys: CGEventFlags
}
