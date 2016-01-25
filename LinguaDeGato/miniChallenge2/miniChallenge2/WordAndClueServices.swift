//
//  WordAndClueServices.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 19/01/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation

class WordAndClueServices {
    
    static func retrieveWordAndClue(aWordAndClue: WordAndClue, completion: (WordAndClue? -> Void)) {
        
        let operation = NSBlockOperation(block: {
            let aWord = WordAndClueDAO.retrieveWordAndClue(aWordAndClue)
            
            if aWord != nil {
                completion(WordAndClueServices.wordAndClueFromDataBase(aWord!))
            }
            else {
                completion(nil)
            }
        })
    
        //call DAO's method asyncronaly
        DatabaseManager.sharedInstance.databaseQueue.addOperation(operation)
    }
    
    static func retriveWordAndCluesWithWord(word: String, completion:([WordAndClue] -> Void)) {
        
        let operation = NSBlockOperation(block: {
                var wordsList: [WordAndClue] = []
            
                let persistedWords = WordAndClueDAO.retriveWordAndCluesWithWord(word)
                
                for word in persistedWords {
                    wordsList.append(WordAndClueServices.wordAndClueFromDataBase(word))
                }
            completion(wordsList)
        })
        
        //call DAO's method asyncronaly
        DatabaseManager.sharedInstance.databaseQueue.addOperation(operation)

    }
    
    static func retriveAllWordAndClues(completion: ([WordAndClue] -> Void)) {
        
        
        let operation = NSBlockOperation(block: {
            var wordsList: [WordAndClue] = []
            let persistedWords = WordAndClueDAO.retriveAllWordAndClues()
            
            for word in persistedWords {
                wordsList.append(WordAndClueServices.wordAndClueFromDataBase(word))
            }
            
            completion(wordsList)
        })
        
        //call DAO's method asyncronaly
        DatabaseManager.sharedInstance.databaseQueue.addOperation(operation)

    }
    
    static func saveWordAndClue(wordAndClue: WordAndClue) {
        
        let operation = NSBlockOperation(block: {
            if WordAndClueDAO.retrieveWordAndClue(wordAndClue) == nil {
                WordAndClueDAO.insert(wordAndClue)
            }
        })
        
        //call DAO's method asyncronaly
        DatabaseManager.sharedInstance.databaseQueue.addOperation(operation)

    }
    
    //auxiliar method to create WordAndClue from LGCDWordAndClue
    static func wordAndClueFromDataBase(word: LGCDWordAndClue) -> WordAndClue {
        
        let aClue = Clue(aImageID: word.imageID, anAudioPath: word.audioPath)
        return WordAndClue(aWord: word.word!, aClue: aClue)
    }
}