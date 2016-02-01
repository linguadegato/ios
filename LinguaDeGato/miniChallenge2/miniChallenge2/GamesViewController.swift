//
//  GamesViewController.swift
//  LinguaDeGato
//
//  Created by Kobayashi on 1/31/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class GamesViewController: UIViewController, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var gamesCollectionView: UICollectionView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playTextButton: UIButton!
    @IBOutlet weak var scrollArrowButton: UIButton!
    
    private var allGames = [Game]()
    private let reuseIdentifier = "ClueCell"
    private var selectedSection : Int?
    private let numberOfVisibleSections = 2
    
    static let onlyAudioImage = UIImage(named: "imageDefaultAudio")
    
    //MARK: - LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollArrowButton.hidden = true
        self.gamesCollectionView.allowsMultipleSelection = false
        
        GameServices.retrieveAllGames({ result in
            self.allGames = result
            self.gamesCollectionView.reloadData()
            
            if (self.allGames.count > self.numberOfVisibleSections){
                self.scrollArrowButton.hidden = false
            }
        })
        
        
    }
    
    //MARK: - DATASOURCE
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return allGames.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allGames[section].wordsAndClueArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GameCollectionViewCell
        let clueWord = allGames[indexPath.section].wordsAndClueArray[indexPath.row].word
        let imageID = allGames[indexPath.section].wordsAndClueArray[indexPath.row].clue.imageID
        let audioPath = allGames[indexPath.section].wordsAndClueArray[indexPath.row].clue.audioPath
        
        // Clue Image
        if imageID != nil {
            
            let results = PHAsset.fetchAssetsWithLocalIdentifiers([imageID!], options: nil)
            
            if results.firstObject != nil {
                
                PHImageManager.defaultManager().requestImageForAsset(results.firstObject as! PHAsset, targetSize: CGSize(width: 1024,height: 1024), contentMode: .AspectFit, options: nil, resultHandler:
                    { (aImage, _) -> Void in
                        cell.imageCell.image = aImage
                })
            }
            else{
                cell.imageCell.image = AppImages.onlyAudioImage
            }
        }
        else {
            cell.imageCell.image = AppImages.onlyAudioImage
        }
        
        // Word
        cell.labelCell.text = clueWord
        
        // Clue audio
        if (audioPath != nil){
            cell.audioImage.hidden = false
        }
        
        // Selection design to the cell (green border or not)
        cell.layer.borderColor = UIColor.greenPalete().CGColor
        if (self.selectedSection != nil) && (indexPath.section == self.selectedSection){
            cell.layer.borderWidth = 3
        }else{
            cell.layer.borderWidth = 0
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "AllGamesHeader",forIndexPath: indexPath) as! GamesHeaderView
            headerView.title.text = allGames[indexPath.section].name
            return headerView
            
        
        case UICollectionElementKindSectionFooter:
            
            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "AllGamesFooter",forIndexPath: indexPath) 
            return footerView

        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    // MARK: - DELEGATE
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellSizeForGame = collectionView.bounds.size.width/6.8
        return CGSizeMake(cellSizeForGame, cellSizeForGame)
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if (self.selectedSection == nil) || (indexPath.section != self.selectedSection){
            self.selectedSection = indexPath.section
            self.gamesCollectionView.reloadData()
        }else{
            if (indexPath.section == self.selectedSection){
                self.selectedSection =  nil
                self.gamesCollectionView.reloadData()
            }
        }
        
        if (self.selectedSection != nil){
            self.playButton.hidden = false
            self.playTextButton.hidden = false
        }else{
            self.playButton.hidden = true
            self.playTextButton.hidden = true
        }
        
    }
    
    //MARK: - NAVIGATION
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