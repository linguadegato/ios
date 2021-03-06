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
    
    static func insert(_ game: Game) -> LGCDGame {
        
        //adding wordAndClues
        var wordsList: [LGCDWordAndClue] = []
        
        for word in game.wordsAndClueArray {
            wordsList.append(WordAndClueDAO.insert(word))
        }
        
        //inserting game
        let newGame = LGCDGame(newGameName: game.name, newWordsAndClues: wordsList)
        
        //saving context
        do {
            try DatabaseManager.sharedInstance.managedObjectContext?.save()
        } catch{
            print("error while saving game - insert(game: Game) -> LGCDGame")
        }
        
        return newGame
    }
    
    //need to be tested
    static func delete(_ game: LGCDGame) {
        DatabaseManager.sharedInstance.managedObjectContext?.delete(game)
        do {
            try DatabaseManager.sharedInstance.managedObjectContext?.save()
        }
        catch {
            print("error deleting game - delete(game: LGCDGame)")
        }
    }
    
    static func retrieveGameByName(_ name: String) -> LGCDGame? {
        //create request
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LGCDGame")
        
        request.predicate = NSPredicate(format: "name == %@", name)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        //executing request
        
        var results: [LGCDGame]? = nil
        
        do {
            results = try DatabaseManager.sharedInstance.managedObjectContext?.fetch(request) as? [LGCDGame]
        }
        catch {
            print("error executing request - retrieveGameByName(name: String) -> LGCDGame?")
        }
        
        //returns
        if results == nil || results!.count == 0 {
            return nil
        }
        else {
            return results![0]
        }
    }
    
    static func retrieveAllGames() -> [LGCDGame] {

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LGCDGame")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        var results: [LGCDGame] = []
        
        do {
            results = try DatabaseManager.sharedInstance.managedObjectContext?.fetch(request) as! [LGCDGame]
        }
        catch{
            print("error executing request - retrieveAllGames()")
        }
        
        return results
    }
}
