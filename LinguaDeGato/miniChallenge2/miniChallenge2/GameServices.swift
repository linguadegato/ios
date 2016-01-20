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
    static func saveGame(game: Game) -> Bool {
        if GameDAO.retrieveGameByName(game.name) == nil {
            GameDAO.insert(game)
            return true
        }
        return false
    }
    
    //if there's already a game with it's name, this function remove from DB, than
    //creates a LGCDGame and save it (calling saveGame)
    static func overwriteGame(newGame: Game) {
        
        if let oldGame = GameDAO.retrieveGameByName(newGame.name) {
            GameDAO.delete(oldGame)
        }
        GameServices.saveGame(newGame)
    }
    
    static func retrieveGameByName(aName: String) -> Game? {
        
        let aPersistedGame = GameDAO.retrieveGameByName(aName)
        
        if aPersistedGame != nil {
            return gameFromDataBase(aPersistedGame!)
        }
        else {
            return nil
        }
    }
    
    static func retrieveAllGames() -> [Game]{
        
        var games: [Game] = []
        let dbGames = GameDAO.retrieveAllGames()
        
        for game in dbGames {
            games.append(GameServices.gameFromDataBase(game))
        }
        return games
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
