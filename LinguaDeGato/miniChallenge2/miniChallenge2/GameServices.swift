//
//  GameServices.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 16/01/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation

class GameServices {
    
    //creates a LGCDGame from Game and save it
    //return true if game was saved, false if there's already a game with that name
    static func saveGame(game: Game) -> Bool {
        if GameDAO.retrieveGameByName(game.name) == nil {
            GameDAO.insert(game)
            //save context
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
    
    static func retrieveAllGames() -> [LGCDGame]{
        return GameDAO.retrieveAllGames()
    }
}