//
//  WordAndClue.swift
//  miniChallenge2
//
//  Created by Andre Scherma Soleo on 23/10/15.
//  Copyright © 2015 Kobayashi. All rights reserved.
//
//  An object that represents the pair word-clue, and stores information that
//  allows the words to be allocated in a matrix by an algorithm


import Foundation

class WordAndClue: Equatable{
    
    //word and clue properties
    var word: String
    var clue: Clue
    var lenght: Int
    
    var coordinate: CrosswordCoordinate?
    
    init(aWord: String, aClue: Clue){
        word = aWord
        clue = aClue
        //length is incresead by 3 due the clue space in crossword
        lenght = word.characters.count + 3
    }
}

//MARK: Equatable Protocol
func ==(lhs: WordAndClue, rhs: WordAndClue) -> Bool {
    return (lhs === rhs)
}
