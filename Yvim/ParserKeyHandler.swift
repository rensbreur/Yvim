//
//  ParserKeyHandler.swift
//  Yvim
//
//  Created by Admin on 05.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

class ParserKeyHandler<T> {
    let createParser: () -> AnyParser<T>

    var parser: AnyParser<T>

    private var result: ParseResult<T>?

    init(createParser: @escaping () -> AnyParser<T>) {
        self.createParser = createParser
        self.parser = createParser()
    }

    func feed(_ keyEvent: KeyEvent, _ handle: (T) -> Void) -> Bool {
        if case .down = keyEvent.event {
            let (_,r) = self.parser.feed(keyEvent.char)
            self.result = r
            switch r {
            case .fail:
                return false
            case .needMore:
                return true
            case .success(let t):
                handle(t)
                return true
            }
        }
        else {
            guard let r = self.result else {
                return true
            }
            self.result = nil
            switch r {
            case .fail:
                self.parser = createParser()
                return false
            case .needMore:
                return true
            case .success:
                self.parser = createParser()
                return true
            }
        }
    }

    static var movementWithMultiplierHandler: ParserKeyHandler<(Int, VimMovement)> {
        ParserKeyHandler<(Int, VimMovement)>(createParser: { return AnyParser(ZipParser(first: AnyParser(MultiplierParser()), then: AnyParser(MovementParser()))) })
    }
}
