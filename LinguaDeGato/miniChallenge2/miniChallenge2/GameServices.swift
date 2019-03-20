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
    static func saveGame(_ game: Game, completionHandler: @escaping (Bool) -> Void) {
        
        let operation = BlockOperation(block: {
            
            //moves audio files to a word-related URL
            for word in game.wordsAndClueArray {
                if word.clue.audioPath != nil {
                    
                    let audioData = AudioFilesManager.audioDataWithFileName(word.clue.audioPath!)
                    
                    AudioFilesManager.saveAudioDataWithFileName(audioData!, fileName: word.word)
                    word.clue.audioPath = word.word
                }
            }
            
            let savedGame = GameDAO.retrieveGameByName(game.name)
            if savedGame == nil {
                let _ = GameDAO.insert(game)
                completionHandler(true)
            }
            else {
                print(savedGame!.name!)
                completionHandler(false)
            }
        })
        
        //call DAO's method asyncronaly
        DatabaseManager.sharedInstance.databaseQueue.addOperation(operation)
    }
    
    //if there's already a game with it's name, this function remove from DB, than
    //creates a LGCDGame and save it (calling saveGame)
    static func overwriteGame(_ newGame: Game, completionHandler: @escaping () -> Void) {
        
        let operation = BlockOperation(block: {
            if let oldGame = GameDAO.retrieveGameByName(newGame.name) {
                GameDAO.delete(oldGame)
            }
            let _ = GameDAO.insert(newGame)
            completionHandler()
        })
        
        //call DAO's method asyncronaly
        DatabaseManager.sharedInstance.databaseQueue.addOperation(operation)
        
    }
    
    static func retrieveGameByName(_ aName: String, completionHandler: @escaping (Game?) -> Void) {
        
        let operation = BlockOperation(block: {
            let aPersistedGame = GameDAO.retrieveGameByName(aName)
            
            if aPersistedGame != nil {
                completionHandler(gameFromDataBase(aPersistedGame!))
            }
            else {
                completionHandler(nil)
            }
        })
        
        //call DAO's method asyncronaly
        DatabaseManager.sharedInstance.databaseQueue.addOperation(operation)

    }
    
    static func deleteGame(game: Game) {
        
        if let toBeDeleted = GameDAO.retrieveGameByName(game.name) {
            //before delete a game, it has to be removed from relationship with all words
            let words = toBeDeleted.words
            for word in words! {
                (word as! LGCDWordAndClue).games!.remove(toBeDeleted)
            }
            GameDAO.delete(toBeDeleted)
        }
    }
    
    static func retrieveAllGames(_ completionHandler: @escaping (([Game]) -> Void)) {
        
        let operation = BlockOperation(block: {
            var games: [Game] = []
            let dbGames = GameDAO.retrieveAllGames()
            
            for game in dbGames {
                games.append(GameServices.gameFromDataBase(game))
            }
            completionHandler(games)
        })
        
        //call DAO's method asyncronaly
        DatabaseManager.sharedInstance.databaseQueue.addOperation(operation)

    }
    
    //auxiliar method to create a Game from a LGCDGame
    static func gameFromDataBase(_ persistedGame: LGCDGame) -> Game {

        var words: [WordAndClue] = []
        
        for object in persistedGame.words! {
            
            if let aWord = object as? LGCDWordAndClue {
                words.append(WordAndClueServices.wordAndClueFromDataBase(aWord))
            }
        }
        return Game(gameName: persistedGame.name!, wordsAndClue: words)
    }
}
