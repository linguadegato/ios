//
//  GalleryAndGamesViewController.swift
//  LinguaDeGato
//
//  Created by Kobayashi on 1/14/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import UIKit

class GalleryAndGamesViewController: UIViewController {
    
    private var allGames = [Game]()
    private var gallery = [WordAndClue]()
    
    // Remove this function (for test)
    private func createExampleGames() -> [Game]{
        
        var games = [Game]()
        
        let clue = Clue.init(aImageID: "4C702013-B31B-4697-A5A8-D1112997D11B/L0/001", anAudioPath: "")
        
        let gameAnimais = Game(gameName: "Animais", wordsAndClue: [WordAndClue]())
        gameAnimais.wordsAndClueArray.append(WordAndClue.init(aWord: "cachorro", aClue: clue))
        gameAnimais.wordsAndClueArray.append(WordAndClue.init(aWord: "gato", aClue: clue))
          
        let gamePessoas = Game(gameName: "Pessoas", wordsAndClue: [WordAndClue]())
        gamePessoas.wordsAndClueArray.append(WordAndClue.init(aWord: "Huguinho", aClue: clue))
        gamePessoas.wordsAndClueArray.append(WordAndClue.init(aWord: "Zezinho", aClue: clue))
        gamePessoas.wordsAndClueArray.append(WordAndClue.init(aWord: "Luizinho", aClue: clue))
        
        let gameMonica = Game(gameName:"Turma da Mônica", wordsAndClue: [WordAndClue]())
        gameMonica.wordsAndClueArray.append(WordAndClue.init(aWord: "Cebelinha", aClue: clue))
        gameMonica.wordsAndClueArray.append(WordAndClue.init(aWord: "Cascão", aClue: clue))
        gameMonica.wordsAndClueArray.append(WordAndClue.init(aWord: "Mônica", aClue: clue))
        gameMonica.wordsAndClueArray.append(WordAndClue.init(aWord: "Magali", aClue: clue))
        gameMonica.wordsAndClueArray.append(WordAndClue.init(aWord: "Anginho", aClue: clue))
        gameMonica.wordsAndClueArray.append(WordAndClue.init(aWord: "Dudu", aClue: clue))
        
        games.append(gameAnimais)
        games.append(gamePessoas)
        games.append(gameMonica)
        
        return games
        
    }
    
    private func createExampleGallery() -> [WordAndClue]{
        
        var words = [WordAndClue]()
        let clue = Clue.init(aImageID: "iconPlayPink", anAudioPath: "")
        
        words.append(WordAndClue.init(aWord: "cachorro", aClue: clue))
        words.append(WordAndClue.init(aWord: "gato", aClue: clue))
        words.append(WordAndClue.init(aWord: "Huguinho", aClue: clue))
        words.append(WordAndClue.init(aWord: "Zezinho", aClue: clue))
        words.append(WordAndClue.init(aWord: "Luizinho", aClue: clue))
        words.append(WordAndClue.init(aWord: "Cebelinha", aClue: clue))
        words.append(WordAndClue.init(aWord: "Cascão", aClue: clue))
        words.append(WordAndClue.init(aWord: "Mônica", aClue: clue))
        words.append(WordAndClue.init(aWord: "Magali", aClue: clue))
        words.append(WordAndClue.init(aWord: "Anginho", aClue: clue))
        words.append(WordAndClue.init(aWord: "Dudu", aClue: clue))
        
        return words
    }

    
    // MARK: - NAVIGATION
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        allGames = createExampleGames()
        gallery = createExampleGallery()
        
        if (segue.identifier == "AllGamesSegue") {
            
            (segue.destinationViewController as! GamesCollectionViewController).allGames = allGames
            
        }else if (segue.identifier == "GallerySegue"){

            (segue.destinationViewController as! GalleryCollectionViewController).gallery = self.gallery
        }
    }

}
