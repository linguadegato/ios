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
    
    static func appendImageToWord(imageID: String, word: String) {
        
        var wordData: LGCDWord?
        var imageData: LGCDPhoto?
        
        wordData = WordDAO.retrieveWord(word)
        if wordData == nil {
            wordData = LGCDWord()
            WordDAO.insert(wordData!)
        }
        
        imageData = ImageDAO.retriveImage(imageID)
        if imageData == nil {
            imageData = LGCDPhoto()
            ImageDAO.insert(imageData!)
        }
        
        wordData!.appendImageToWord(imageData!)
    }
    
    static func writeAudio(word: String, audioPath: String) {
        
        if let wordData = WordDAO.retrieveWord(word) {
            wordData.writeAudio(audioPath)
        }
        else {
            let newWordData = LGCDWord()
            newWordData.writeAudio(audioPath)
            WordDAO.insert(newWordData)
        }
    }
}