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
        
        let aWord = WordAndClueDAO.retrieveWordAndClue(aWordAndClue)
        
        if aWord != nil {
            return WordAndClueServices.wordAndClueFromDataBase(aWord!)
        }
        else {
            return nil
        }
    }
    
    static func retriveWordAndCluesWithWord(word: String) -> [WordAndClue]{

        var wordsList: [WordAndClue] = []
        
        let persistedWords = WordAndClueDAO.retriveWordAndCluesWithWord(word)
        
        for word in persistedWords {
            wordsList.append(WordAndClueServices.wordAndClueFromDataBase(word))
        }
        return wordsList
    }
    
    static func retriveAllWordAndClues() -> [WordAndClue] {
        
        var wordsList: [WordAndClue] = []
        let persistedWords = WordAndClueDAO.retriveAllWordAndClues()
        
        for word in persistedWords {
            wordsList.append(WordAndClueServices.wordAndClueFromDataBase(word))
        }
        return wordsList
    }
    
    static func saveWordAndClue(wordAndClue: WordAndClue) {
        
        let operation = NSBlockOperation {
            if WordAndClueDAO.retrieveWordAndClue(wordAndClue) == nil {
                WordAndClueDAO.insert(wordAndClue)
            }
        }
        
        let auxiliarQueue = NSOperationQueue()
        auxiliarQueue.addOperation(operation)
    }
    
    //auxiliar method to create WordAndClue from LGCDWordAndClue
    static func wordAndClueFromDataBase(word: LGCDWordAndClue) -> WordAndClue {
        
        let aClue = Clue(aImageID: word.imageID, anAudioPath: word.audioPath)
        return WordAndClue(aWord: word.word!, aClue: aClue)
    }
}