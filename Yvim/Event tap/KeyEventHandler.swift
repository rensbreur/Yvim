import Foundation

class KeyEventHandler: EventHandler {
    func handleEvent(_ event: CGEvent, simulateEvent: (CGEvent) -> Void) -> Bool {
        let keycode = event.keyboardEventKeycode
        let keyDown = event.keyDown
        let event = KeyEvent(event: keyDown ? .down : .up, key: Key(keycode: keycode, char: event.unicodeString.first!, modifierKeys: event.flags))

        func simulateKeyPress(_ keyCode: CGKeyCode, modifierKeys: CGEventFlags = []) -> Void {
            simulateEvent(.keyboardEvent(keyCode: keyCode, keyDown: true, modifierKeys: modifierKeys))
            simulateEvent(.keyboardEvent(keyCode: keyCode, keyDown: false, modifierKeys: modifierKeys))
        }

        return self.keyHandler.handleKeyEvent(event, simulateKeyPress: simulateKeyPress)
    }

    let keyHandler: KeyHandler

    init(keyHandler: KeyHandler) {
        self.keyHandler = keyHandler
    }

}
