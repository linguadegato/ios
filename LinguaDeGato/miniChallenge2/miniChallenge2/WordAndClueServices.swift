//
//  WordAndClueServices.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 19/01/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation

class WordAndClueServices {
    
    static func saveWordAndClue(_ wordAndClue: WordAndClue) {
        
        let operation = BlockOperation(block: {
            if WordAndClueDAO.retrieveWordAndClue(wordAndClue) == nil {
                _ = WordAndClueDAO.insert(wordAndClue)
            }
        })
        
        //call DAO's method asyncronaly
        DatabaseManager.sharedInstance.databaseQueue.addOperation(operation)
        
    }
    
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
    
    
    static func deleteWordAndClue(wac: WordAndClue) {
        if let toBeDeleted = WordAndClueDAO.retrieveWordAndClue(wac) {
            
            //before delete a word, it must be removed from all games
            if let games = toBeDeleted.games {
                for game in games {
                    if let words = (game as! LGCDGame).words {
                        words.remove(toBeDeleted)
                    }
                }
            }
        WordAndClueDAO.delete(toBeDeleted)
        }
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
    
    //auxiliar method to create WordAndClue from LGCDWordAndClue
    static func wordAndClueFromDataBase(_ word: LGCDWordAndClue) -> WordAndClue {
        
        let aClue = Clue(aImageID: word.imageID, anAudioPath: word.audioPath)
        return WordAndClue(aWord: word.word!, aClue: aClue)
    }
}
