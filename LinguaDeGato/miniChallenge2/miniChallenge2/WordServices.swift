//
//  WordServices.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 16/01/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation

class WordServices {
    
    //guess this will not be used
    static func retrieveWord(word: String) -> LGCDWord? {
        return WordDAO.retrieveWord(word)
    }
        
    static func writeAudio(word: String, audioPath: String) {
        
        if let wordData = WordDAO.retrieveWord(word) {
            wordData.appendAudio(audioPath)
        }
        else {
            WordDAO.insert(word, audioPath: audioPath)
        }
    }
}