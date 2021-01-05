//
//  Parser.swift
//  Yvim
//
//  Created by Admin on 04.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

enum ParseResult<T> {
    case success(T)
    case needMore
    case fail

    func map<U>(_ f: (T) -> U) -> ParseResult<U> {
        switch self {
        case .success(let t): return .success(f(t))
        case .needMore: return .needMore
        case .fail: return .fail
        }
    }
}

protocol ActionParser: AnyObject {
    associatedtype T
    func feed(_ character: Character) -> (Bool, ParseResult<T>)
}

class AnyParser<T>: ActionParser {
    private var _feed: (Character) -> (Bool, ParseResult<T>)

    func feed(_ character: Character) -> (Bool, ParseResult<T>) {
        _feed(character)
    }

    private init(feed: @escaping (Character) -> (Bool, ParseResult<T>)) {
        self._feed = feed
    }

    init<P: ActionParser>(_ parser: P) where P.T == T {
        self._feed = parser.feed
    }

    func map<U>(_ f: @escaping (T) -> U) -> AnyParser<U> {
        return AnyParser<U>.init(feed: { (char) in
            let (consumed, r) = self.feed(char)
            return (consumed, r.map(f))
        })
    }
}

class MultiplierParser: ActionParser {
    private var multiplier: Int?

    func feed(_ character: Character) -> (Bool, ParseResult<Int>) {
        guard let digit = Int(String(character)), !(multiplier == nil && digit == 0) else {
            return (false, .success(multiplier ?? 1))
        }
        self.multiplier = ((self.multiplier ?? 0) * 10) + digit
        return (true, .needMore)
    }
}

class PrefixParser: ActionParser {
    func feed(_ character: Character) -> (Bool, ParseResult<Void>) {
        if character == prefix {
            return (true, .success(()))
        }
        return (false, .fail)
    }

    let prefix: Character
    init(prefix:Character) {
        self.prefix = prefix
    }
}

class LetterParser: ActionParser {
    func feed(_ character: Character) -> (Bool, ParseResult<Character>) {
        return (true, .success(character))
    }
}

class ZipParser<A, B>: ActionParser {
    func feed(_ character: Character) -> (Bool, ParseResult<(A, B)>) {
        if let a = firstResult {
            return then.map { (a, $0) }.feed(character)
        }
        let (consumed, r) = first.feed(character)
        switch r {
        case .fail: return (consumed, .fail)
        case .needMore: return (consumed, .needMore)
        case .success(let a):
            self.firstResult = a
            if consumed { return (consumed, .needMore) }
            return then.map { (a, $0) }.feed(character)
        }
    }

    let first: AnyParser<A>
    let then: AnyParser<B>

    private var firstResult: A?

    init(first: AnyParser<A>, then: AnyParser<B>) {
        self.first = first
        self.then = then
    }
    typealias T = (A, B)

}
