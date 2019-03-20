//
//  CrosswordChar.swift
//  LinguaDeGato
//
//
//  This class store the characters data for a Crossword BoardView
//
//  Created by Andre Scherma Soleo on 13/10/15.
//  Copyright © 2015 Kobayashi. All rights reserved.
//
//  An object that stores informations of a letter in a crossword game. Used by
//  an algorithm to generate a custom crossword game.

import UIKit

class CrosswordChar: CrosswordElement, Equatable {
    
    let theChar: Character
    var belongsTo = [WordAndClue]()
    
    init(aChar: Character){
        self.theChar = aChar
    }

    override func generateSquareView(_ squareSize: CGSize, elementCoordX: Int, elementCoordY: Int, board: BoardView) -> BoardCellView? {
        
        let originX = board.centerBoard!.frame.origin.x + (CGFloat(elementCoordX) * squareSize.width)
        let originY = board.centerBoard!.frame.origin.y + (CGFloat(elementCoordY) * squareSize.height)
        let aRect = CGRect(x: originX, y: originY, width: squareSize.width, height: squareSize.height)
        
        let square = SquareView(frame: aRect, char: self.theChar, words: self.belongsTo)
        square.layer.zPosition = 0
        
        return square
    }
}

func ==(lhs:CrosswordChar, rhs:CrosswordChar) -> Bool {
    return lhs.theChar == rhs.theChar
}

func ==(lhs:CrosswordChar?, rhs:CrosswordChar?) -> Bool {
    if (lhs == nil && rhs == nil){
        return true
    }
    if (lhs == nil || rhs == nil) {
        return false
    }
    return lhs! == rhs!
}
