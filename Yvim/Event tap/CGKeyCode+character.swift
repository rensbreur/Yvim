import Carbon.HIToolbox

private let currentKeyboard = TISCopyCurrentKeyboardInputSource().takeRetainedValue()

private let layoutData = Unmanaged<CFData>.fromOpaque(
    TISGetInputSourceProperty(
        currentKeyboard,
        kTISPropertyUnicodeKeyLayoutData)
).takeUnretainedValue()

/// Get the string value for keycode in the current layout
func stringForKeycode(_ keyCode: CGKeyCode) -> String! {
    let ptr = CFDataGetBytePtr(layoutData)!

    var keysDown: UInt32 = 0
    var chars: [UniChar] = [0]
    var realLength: Int = 0

    let r = UCKeyTranslate(
        UnsafeRawPointer(ptr).assumingMemoryBound(to: UCKeyboardLayout.self),
        keyCode,
        UInt16(kUCKeyActionDisplay),
        0,
        UInt32(LMGetKbdType()),
        1 << kUCKeyTranslateNoDeadKeysBit,
        &keysDown,
        1,
        &realLength,
        &chars
    )

    guard r == 0 else {
        print("Could not translate key")
        return nil
    }

    return CFStringCreateWithCharacters(kCFAllocatorDefault, chars, 1) as String
}

/// Get the keycode to produce the character in the current layout
func keycodeForString(_ string: String) -> CGKeyCode! {
    _keycodeForString[string]
}

private let _keycodeForString: [String: CGKeyCode] = {
    var dict: [String: CGKeyCode] = [:]
    for i in 0..<UInt16.max {
        if let str = stringForKeycode(i) { dict[str] = i }
    }
    return dict
}()
