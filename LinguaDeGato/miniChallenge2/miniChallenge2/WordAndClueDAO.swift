//
//  WordAndClueDAO.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 16/01/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation

class WordAndClueDAO {
    
    //insert has the responsability of avoid creation of redunand objects (same word and same imageID)
    static func insert(wordAndClue: WordAndClue) {
        
    }
    
    static func delete(wordAndClue: LGCDWordAndClue) {
        
    }
    
    static func retrieveWordAndClue(aWordAndClue: WordAndClue) -> WordAndClue? {
        
        return nil
    }
    
    static func retriveWordAndCluesWithWord(word: String) -> [WordAndClue]{
        
        return []
    }
    
    static func retriveAllWordAndClues() -> [WordAndClue] {
        
        return []
    }
}