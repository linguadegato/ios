//
//  WordManager.swift
//  miniChallenge2
//
//  Created by Andre Scherma Soleo on 09/11/15.
//  Copyright © 2015 Kobayashi. All rights reserved.
//
//  An object that manages, in BoardView, trigger to responses (either visual behavior and
//  model related operations) to events ocurred in a specific word in a crossword
//  game. Kind of an view controller anexus.

import Foundation

class WordManager {
    
    //MARK: - Properties
    let word: WordAndClue
    let board: BoardView
    var counter: Int = 0
    
    
    //MARK: - Initializers
    init(aWord: WordAndClue, aBoard: BoardView) {
        word = aWord
        board = aBoard
    }
    
    //MARK: - Management methods
    /** operations using word.length considers the fact that clue
    is counted in length, so it's skipped in iterations and discounted
    on verifications (clue size = 3 "squares")
    **/
    
    //a tile was placed in the right square
    func increaseCounter() {
        counter += 1
        
        if counter == word.lenght - 3 {
            allCorrect()
        }
    }
    
    //a tile was taken of the right square
    func decreaseCounter() {
        counter -= 1
        
        //(clue size minus 1 - cause it WAS all correct, but isn't anymore)
        if counter == (word.lenght - 4) {
            wasAllCorrect()
        }
    }
    
    
    //all square was correct filled
    fileprivate func allCorrect() {
        
        if word.coordinate!.vertical {
            for i in 3...(word.lenght - 1) {
                let cell = board.getCell(word.coordinate!.row + i, col: word.coordinate!.col)
                (cell as! SquareView).filled!.visualFeedbackIfWordIsCorrect()
            }
        } else {
            for i in 3...(word.lenght - 1) {
                let cell = board.getCell(word.coordinate!.row, col: word.coordinate!.col + i)
                (cell as! SquareView).filled!.visualFeedbackIfWordIsCorrect()
            }
        }
        
        board.correctWords += 1
    }
    
    //a tile was taken from a correct filled word
    fileprivate func wasAllCorrect() {
        
        if word.coordinate!.vertical {
            for i in 3...(word.lenght - 1) {
                let cell = board.getCell(word.coordinate!.row + i, col: word.coordinate!.col) as! SquareView
                if cell.filled != nil {
                    cell.filled!.decreaseCorrectWordCounter()
                }
            }
        } else {
            for i in 3...(word.lenght - 1) {
                let cell = board.getCell(word.coordinate!.row, col: word.coordinate!.col + i) as! SquareView
                if cell.filled != nil {
                    cell.filled!.decreaseCorrectWordCounter()
                }
            }
        }
        
        board.correctWords -= 1
    }
}
