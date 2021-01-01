//
//  YvimEngine.swift
//  Yvim
//
//  Created by Rens Breur on 31.12.20.
//  Copyright © 2020 Rens Breur. All rights reserved.
//

import Foundation
import Carbon.HIToolbox
import Carbon

enum Mode {
    case command
    case transparent // insert, send through all keys
    case visual

    var description: String {
        switch self {
        case .command: return "-- COMMAND --"
        case .transparent: return "-- INSERT --"
        case .visual: return "-- VISUAL --"
        }
    }
}

class YvimEngine: KeyboardEventHandler {
    @Published var mode: Mode = .command

    var kc: KeyboardEventSimulator

    init(kc: KeyboardEventSimulator) {
        self.kc = kc
    }

    func handleKeyboardEvent(keycode: Int64, keyDown: Bool) -> Bool {
        switch mode {
        case .command:
            if (keycode == kVK_ANSI_A || keycode == kVK_ANSI_I) && keyDown {
                mode = .transparent
            }
            if (keycode == kVK_ANSI_H && keyDown) {
                kc.sendKey(keyCode: kVK_LeftArrow)
            }
            if (keycode == kVK_ANSI_L && keyDown) {
            kc.sendKey(keyCode: kVK_RightArrow)
            }
            if (keycode == kVK_ANSI_S && keyDown) {
                kc.sendKey(keyCode: kVK_ANSI_D, ctrl: true)
                kc.sendKey(keyCode: kVK_ANSI_KeypadEnter)
                self.mode = .transparent
            }
            if (keycode == kVK_ANSI_J && keyDown) {
            kc.sendKey(keyCode: kVK_UpArrow)
            }
            if (keycode == kVK_ANSI_K && keyDown) {
            kc.sendKey(keyCode: kVK_DownArrow)
            }
            let str = createStringForKey(keyCode: CGKeyCode(keycode))
            print("INTERCEPTING KEY \(keycode) \(str)")
            return true;
        case .transparent:
            if keycode == kVK_Escape && keyDown {
            mode = .command
            return true
            }
            return false
        case .visual:
            return false
        }
    }

}

//enum KeyboardKey: ExpressibleByUnicodeScalarLiteral {
//    case n1,n2,n3,n4,n5,n6,n7,n8,n9,n0
//    case a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z
//    case dot,comma
//    case minus, equals, forwardSlash, bracketOpen, bracketClose, paragraph, weirdAccent,backwardSlash, semicolon
//
//    init(unicodeScalarLiteral value: Character) {
//        switch value {
//        case "1": self = .n1
//        default: fatalError("Non-existing ")
//        }
//    }
//}

func createStringForKey(keyCode: CGKeyCode) -> String
{
    let currentKeyboard = TISCopyCurrentKeyboardInputSource().takeRetainedValue()
    let layoutData = Unmanaged<CFData>.fromOpaque(
        TISGetInputSourceProperty(
            currentKeyboard,
            kTISPropertyUnicodeKeyLayoutData)).takeUnretainedValue()
    let ptr = CFDataGetBytePtr(layoutData)!

    var keysDown: UInt32 = 0;
    var chars: [UniChar] = .init(repeating: 0, count: 4)
    var realLength: Int = 0;

    let r = UCKeyTranslate(UnsafeRawPointer(ptr).assumingMemoryBound(to: UCKeyboardLayout.self),
                   keyCode as UInt16,
                   UInt16(kUCKeyActionDisplay),
                   0 as UInt32,
                   UInt32(LMGetKbdType()),
                   1 << kUCKeyTranslateNoDeadKeysBit,
                   &keysDown,
                   5,
                   &realLength,
                   &chars);

    return CFStringCreateWithCharacters(kCFAllocatorDefault, chars, 1) as String
}

//let keycodeForString: [String: CGKeyCode] = {
//    var charToCodeDict: [String: CGKeyCode] = [:]
//    for i in [0 ..< 128] {
//        var string: CFString = createStringForKey((CGKeyCode)i);
//
//    }
//
//    // Using (void *) casting on an Int to put it into a dictionary ??
//
//    charStr = CFStringCreateWithCharacters(kCFAllocatorDefault, &character, 1);
//
//    /* Our values may be NULL (0), so we need to use this function. */
//    if (!CFDictionaryGetValueIfPresent(charToCodeDict, charStr,
//                                       (const void **)&code)) {
//        code = UINT16_MAX;
//    }
//
//    CFRelease(charStr);
//    return code;
//}()
