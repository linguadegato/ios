//
//  GalleryAndGamesViewController.swift
//  LinguaDeGato
//
//  Created by Kobayashi on 1/14/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import UIKit

class GalleryAndGamesViewController: UIViewController {
    
    private var wordsMatrixGames = [[WordAndClue]]()
    private var wordsMatrixGallery = [[WordAndClue]]()
    
    // Remove this function (for test)
    private func createExampleMatrixGame() -> [[WordAndClue]]{
        
        var wordsMatrix = [[WordAndClue]]()
        let clue = Clue.init(aImageID: "iconPlayPink", anAudioPath: "")
        
        var arrayAnimais = [WordAndClue]()
        arrayAnimais.append(WordAndClue.init(aWord: "cachorro", aClue: clue))
        arrayAnimais.append(WordAndClue.init(aWord: "gato", aClue: clue))
        wordsMatrix.append(arrayAnimais)
        
        var arrayPessoas = [WordAndClue]()
        arrayPessoas.append(WordAndClue.init(aWord: "Huguinho", aClue: clue))
        arrayPessoas.append(WordAndClue.init(aWord: "Zezinho", aClue: clue))
        arrayPessoas.append(WordAndClue.init(aWord: "Luizinho", aClue: clue))
        wordsMatrix.append(arrayPessoas)
        
        
        arrayPessoas.append(WordAndClue.init(aWord: "Pink", aClue: clue))
        arrayPessoas.append(WordAndClue.init(aWord: "Cérebro", aClue: clue))
        arrayPessoas.append(WordAndClue.init(aWord: "Mônica", aClue: clue))
        wordsMatrix.append(arrayPessoas)
        
        return wordsMatrix
        
    }
    
    private func createExampleMatrixGallery() -> [[WordAndClue]]{
        
        var wordsMatrix = [[WordAndClue]]()
        let clue = Clue.init(aImageID: "iconPlayPink", anAudioPath: "")
        
        var arrayAnimais = [WordAndClue]()
        arrayAnimais.append(WordAndClue.init(aWord: "cachorro", aClue: clue))
        arrayAnimais.append(WordAndClue.init(aWord: "gato", aClue: clue))
        wordsMatrix.append(arrayAnimais)
        
        return wordsMatrix
        
    }

    
    // MARK: - NAVIGATION
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        wordsMatrixGames = createExampleMatrixGame()
        wordsMatrixGallery = createExampleMatrixGallery()
        
        if (segue.identifier == "AllGamesSegue") {
            
            (segue.destinationViewController as! AllGamesCollectionViewController).collectionType = "AllGames"
            (segue.destinationViewController as! AllGamesCollectionViewController).words = wordsMatrixGames
            
        }else if (segue.identifier == "GallerySegue"){
            (segue.destinationViewController as! AllGamesCollectionViewController).collectionType = "Gallery"
            (segue.destinationViewController as! AllGamesCollectionViewController).words = wordsMatrixGallery
        }
    }

}
