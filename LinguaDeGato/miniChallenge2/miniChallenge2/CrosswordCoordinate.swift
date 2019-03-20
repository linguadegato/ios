//
//  CrosswordCoordinate.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 27/10/15.
//  Copyright © 2015 Kobayashi. All rights reserved.
//
//  An object that stores information about a word position in a crossword game.

import Foundation

class CrosswordCoordinate {
    var col: Int
    var row: Int
    var vertical: Bool

//  used for 2x2 clues - deprecated
//  var clueOffsetLeft: Bool

    var score: Int = 1
    
    init (col: Int, row: Int, vertical: Bool, clueOffsetLeft: Bool) {
        self.col = col
        self.row = row
        self.vertical = vertical
//      self.clueOffsetLeft = clueOffsetLeft
    }
}
