import Foundation

extension CGEvent {
    var keyboardEventKeycode: CGKeyCode {
        CGKeyCode(getIntegerValueField(.keyboardEventKeycode))
    }

    var keyDown: Bool {
        type == CGEventType.keyDown
    }

    var unicodeString: String {
        var length: Int = 0
        var str: [UniChar] = [0,0,0,0]
        keyboardGetUnicodeString(maxStringLength: 1, actualStringLength: &length, unicodeString: &str)
        return CFStringCreateWithCharacters(kCFAllocatorDefault, str, 1) as String
    }

    static func keyboardEvent(keyCode: CGKeyCode, keyDown: Bool, modifierKeys: CGEventFlags = []) -> CGEvent {
        let event = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: keyDown)!
        event.flags = modifierKeys
        return event
    }
}
