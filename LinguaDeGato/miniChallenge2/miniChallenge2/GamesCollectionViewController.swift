//
//  SavedGamesViewController.swift
//  LinguaDeGato
//
//  Created by Kobayashi on 1/7/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import UIKit

class GamesCollectionViewController : UICollectionViewController{
    
    
    @IBOutlet var gamesCollectionView: UICollectionView!
    
    var allGames = [Game]()
    
    private let reuseIdentifier = "ClueCell"
    private var selectedSection : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - DATASOURCE
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return allGames.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allGames[section].wordsAndClueArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GameCollectionViewCell
        
        cell.labelCell.text = allGames[indexPath.section].wordsAndClueArray[indexPath.row].word
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "AllGamesHeader",forIndexPath: indexPath) as! GamesHeaderView
            headerView.title.text = allGames[indexPath.section].name
            headerView.playButton.setTitle("\(indexPath.section)", forState: UIControlState.Selected)
            return headerView

        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellSizeForGame = collectionView.bounds.size.width/6.8
        return CGSizeMake(cellSizeForGame, cellSizeForGame)
        
    }
    
    //MARK: - NAVIGATION
    @IBAction func playGame(sender: UIButton) {
        let buttonTitle = sender.titleForState(UIControlState.Selected)
        selectedSection = Int(buttonTitle!)

        self.performSegueWithIdentifier("CreateGameFromSelectedGame", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //MARK: HARRY-TODO: ACTIVITY INDICATOR
        if (selectedSection != nil){
            let selectedGame = allGames[selectedSection!].wordsAndClueArray
            
            let aGenerator = LGCrosswordGenerator(rows: BoardView.maxSquaresInCol, cols: BoardView.maxSquaresinRow, maxloops: 2000, avaiableWords: selectedGame)
            aGenerator.computeCrossword(2, spins: 4)
            
            if (segue.identifier == "CreateGameFromSelectedGame" ) {
                (segue.destinationViewController as! GamePlayViewController).crosswordMatrix = aGenerator.grid
                (segue.destinationViewController as! GamePlayViewController).words = aGenerator.currentWordlist
            }
        }
        
    }
    
}