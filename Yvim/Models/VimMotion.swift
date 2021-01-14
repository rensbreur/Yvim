//
//  VimMotion.swift
//  Yvim
//
//  Created by Admin on 04.01.21.
//  Copyright © 2021 Rens Breur. All rights reserved.
//

import Foundation

protocol VimMotion {
    func move(_ position: inout TextPosition)
}

extension VimMotion {
    func index(from index: Int, in text: NSString) -> Int {
        var position = TextPosition(text: text, position: index)
        move(&position)
        return position.position
    }
}

protocol ParametrizedVimMotion: VimMotion {
    init(parameter: unichar)
}
