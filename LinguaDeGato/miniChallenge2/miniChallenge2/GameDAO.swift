//
//  GameDAO.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 19/01/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation
import CoreData

class GameDAO {
    
    static func insert(game: Game) -> LGCDGame {
        
        var wordsList: [LGCDWordAndClue] = []
        
        for word in game.wordsAndClueArray {
            wordsList.append(WordAndClueDAO.insert(word))
        }
        try! DatabaseManager.sharedInstance.managedObjectContext?.save()
        
        return LGCDGame(newGameName: game.name, newWordsAndClues: wordsList)
    }
    
    static func delete(game: LGCDGame) {
        DatabaseManager.sharedInstance.managedObjectContext?.deleteObject(game)
        try! DatabaseManager.sharedInstance.managedObjectContext?.save()
    }
    
    static func retrieveGameByName(name: String) -> LGCDGame? {
        //create request
        let request = NSFetchRequest(entityName: "LGCDGame")
        
        request.predicate = NSPredicate(format: "name == %@", name)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let results = try? DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request)
        
        if results == nil || results!!.count == 0 {
            return nil
        }
        else {
            return (results!![0] as! LGCDGame)
        }


    }
    
    static func retrieveAllGames() -> [LGCDGame] {

        let request = NSFetchRequest(entityName: "LGCDGame")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let results = try! DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request) as! [LGCDGame]
        
        return results
    }
}