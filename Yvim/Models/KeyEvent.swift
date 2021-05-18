//
//  KeyEvent.swift
//  Yvim
//
//  Created by Admin on 05.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

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
