//
//  WordAndClueDAO.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 19/01/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation
import CoreData

class WordAndClueDAO {
    
    // it's WordAndClueDAO responsability to avoid insertion of redundand objects
    // (same word, audioPath and imageID)
    static func insert(wac: WordAndClue) -> LGCDWordAndClue {
        
        var aPersistedClue = WordAndClueDAO.retrieveWordAndClue(wac)
        
        if aPersistedClue == nil {
            aPersistedClue = LGCDWordAndClue(aWord: wac.word, anAudioPath: wac.clue.audioPath, anImageID: wac.clue.imageID)
            
            do {
                try DatabaseManager.sharedInstance.managedObjectContext?.save()
            }
            catch {
                print("error while saving context - insert(wac: WordAndClue) -> LGCDWordAndClue")
                print(error)
            }
        }
        return aPersistedClue!
    }
    
    static func retrieveWordAndClue(aWordAndClue: WordAndClue) -> LGCDWordAndClue? {
        
        //create fetch request
        let request = NSFetchRequest(entityName: "LGCDWordAndClue")
        
        //assign predicates
        let aWord = aWordAndClue.word
        let anAudioPath = aWordAndClue.clue.audioPath
        let anImageID = aWordAndClue.clue.imageID
        
        var formatString = "word == %@"
        var arguments: [AnyObject] = [aWord]
        
        if anAudioPath != nil {
            formatString += " AND audioPath == %@"
            arguments.append(anAudioPath!)
        }
        
        if anImageID != nil {
            formatString += " AND imageID == %@"
            arguments.append(anImageID!)
        }
        
        request.predicate = NSPredicate(format: formatString, argumentArray: arguments)
        
        var results: [LGCDWordAndClue]?
        
        // execute request
        do {
            results = try DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request) as? [LGCDWordAndClue]
        }
        catch {
            print("error executing FetchRequest - retrieveWordAndClue(aWordAndClue: WordAndClue) -> LGCDWordAndClue?")
            results = nil
        }
        
        
        // returns
        if results != nil && results!.count > 0 {
            return results![0]
        }
        else {
            return nil
        }
    }
    
    static func retriveWordAndCluesWithWord(word: String)  -> [LGCDWordAndClue] {
        
        // create fetch request
        let request = NSFetchRequest(entityName: "LGCDWordAndClue")
        request.predicate = NSPredicate(format: "word == %@", word)
        request.sortDescriptors = [NSSortDescriptor(key: "word", ascending: true)]
        
        
        //execute request
        var results: [LGCDWordAndClue]
        
        do {
            results = try DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request) as! [LGCDWordAndClue]
            
        }
        catch {
            print("error executing FetchRequest - retrieveWordAndClueWithWord(word: String) -> [LGCDWordAndClue]")
            results = []
        }
        
        return results
    }
    
    static func retriveAllWordAndClues() -> [LGCDWordAndClue] {
        let request = NSFetchRequest(entityName: "LGCDWordAndClue")
        request.sortDescriptors = [NSSortDescriptor(key: "word", ascending: true)]
        
        var results: [LGCDWordAndClue]
        
        do {
            results = try DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request) as! [LGCDWordAndClue]
        }
        catch {
            print("error executing FetchRequest - retrieveAllWordAndClues()")
            results = []
        }
        
        return results
    }
}