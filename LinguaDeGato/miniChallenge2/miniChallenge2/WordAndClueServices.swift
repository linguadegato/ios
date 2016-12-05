//
//  WordAndClueServices.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 19/01/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation

class WordAndClueServices {
    
    static func retrieveWordAndClue(_ aWordAndClue: WordAndClue, completion: @escaping ((WordAndClue?) -> Void)) {
        
        let operation = BlockOperation(block: {
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
    
    static func retriveWordAndCluesWithWord(_ word: String, completion:@escaping (([WordAndClue]) -> Void)) {
        
        let operation = BlockOperation(block: {
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
    
    static func retriveAllWordAndClues(_ completion: @escaping (([WordAndClue]) -> Void)) {
        
        
        let operation = BlockOperation(block: {
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
    
    static func saveWordAndClue(_ wordAndClue: WordAndClue) {
        
        let operation = BlockOperation(block: {
            if WordAndClueDAO.retrieveWordAndClue(wordAndClue) == nil {
                _ = WordAndClueDAO.insert(wordAndClue)
            }
        })
        
        //call DAO's method asyncronaly
        DatabaseManager.sharedInstance.databaseQueue.addOperation(operation)

    }
    
    //auxiliar method to create WordAndClue from LGCDWordAndClue
    static func wordAndClueFromDataBase(_ word: LGCDWordAndClue) -> WordAndClue {
        
        let aClue = Clue(aImageID: word.imageID, anAudioPath: word.audioPath)
        return WordAndClue(aWord: word.word!, aClue: aClue)
    }
}
