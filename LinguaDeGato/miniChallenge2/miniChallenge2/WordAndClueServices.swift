//
//  WordAndClueServices.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 19/01/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation

class WordAndClueServices {
    
    static func retrieveWordAndClue(aWordAndClue: WordAndClue) -> WordAndClue? {
        //return WordAndClueDAO.retrieveWordAndClue(aWordAndClue)
        return nil
    }
    
    static func retriveWordAndCluesWithWord(word: String) -> [WordAndClue]{
        //return WordAndClueDAO.retriveWordAndCluesWithWord(word)
        return []
    }
    
    static func retriveAllWordAndClues() -> [WordAndClue] {
        //return WordAndClueDAO.retriveAllWordAndClues()
        return []
    }
    
    static func saveWordAndClue(wordAndClue: WordAndClue) {
        if WordAndClueDAO.retrieveWordAndClue(wordAndClue) == nil {
            WordAndClueDAO.insert(wordAndClue)
        }
    }
}