//
//  WordAndClueServices.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 16/01/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation

class WordAndClueServices {
    
    static func retrieveWordAndClue(aWordAndClue: WordAndClue) -> WordAndClue? {
        return WordAndClueDAO.retrieveWordAndClue(aWordAndClue)
    }
    
    static func retriveWordAndCluesWithWord(word: String) -> [WordAndClue]{
        return WordAndClueDAO.retriveWordAndCluesWithWord(word)
    }
    
    static func retriveAllWordAndClues() -> [WordAndClue] {
        return WordAndClueDAO.retriveAllWordAndClues()
    }
    
    static func saveWordAndClue(wordAndClue: WordAndClue) {
        if WordAndClueDAO.retrieveWordAndClue(wordAndClue) == nil {
            WordAndClueDAO.insert(wordAndClue)
        }
    }
}