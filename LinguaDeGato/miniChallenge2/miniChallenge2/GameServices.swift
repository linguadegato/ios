//
//  GameServices.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 19/01/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//
// It's GameServices responsability to avoid that two games have the same name'

import Foundation

class GameServices {
    
    //creates a LGCDGame from Game and save it
    //return true if game was saved, false if there's already a game with that name
    static func saveGame(game: Game, completion: (Bool) -> Void) {
        
        let operation = NSBlockOperation(block: {
            
            let savedGame = GameDAO.retrieveGameByName(game.name)
            if savedGame == nil {
                GameDAO.insert(game)
                completion(true)
            }
            else {
                print(savedGame!.name)
                completion(false)
            }
        })
        
        //call DAO's method asyncronaly
        DatabaseManager.sharedInstance.databaseQueue.addOperation(operation)
    }
    
    //if there's already a game with it's name, this function remove from DB, than
    //creates a LGCDGame and save it (calling saveGame)
    static func overwriteGame(newGame: Game) {
        
        let operation = NSBlockOperation(block: {
            if let oldGame = GameDAO.retrieveGameByName(newGame.name) {
                GameDAO.delete(oldGame)
            }
            GameDAO.insert(newGame)
        })
        
        //call DAO's method asyncronaly
        DatabaseManager.sharedInstance.databaseQueue.addOperation(operation)

    }
    
    static func retrieveGameByName(aName: String, completion: (Game?) -> Void) {
        
        let operation = NSBlockOperation(block: {
            let aPersistedGame = GameDAO.retrieveGameByName(aName)
            
            if aPersistedGame != nil {
                completion(gameFromDataBase(aPersistedGame!))
            }
            else {
                completion(nil)
            }
        })
        
        //call DAO's method asyncronaly
        DatabaseManager.sharedInstance.databaseQueue.addOperation(operation)

    }
    
    static func retrieveAllGames(completion: ([Game] -> Void)) {
        
        let operation = NSBlockOperation(block: {
            var games: [Game] = []
            let dbGames = GameDAO.retrieveAllGames()
            
            for game in dbGames {
                games.append(GameServices.gameFromDataBase(game))
            }
            completion(games)
        })
        
        //call DAO's method asyncronaly
        DatabaseManager.sharedInstance.databaseQueue.addOperation(operation)

    }
    
    //auxiliar method to create a Game from a LGCDGame
    static func gameFromDataBase(persistedGame: LGCDGame) -> Game {

        var words: [WordAndClue] = []
        
        for object in persistedGame.words! {
            
            if let aWord = object as? LGCDWordAndClue {
                words.append(WordAndClueServices.wordAndClueFromDataBase(aWord))
            }
        }
        return Game(gameName: persistedGame.name!, wordsAndClue: words)
    }
}
