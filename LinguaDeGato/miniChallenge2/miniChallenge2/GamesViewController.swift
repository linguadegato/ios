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
    
    fileprivate var allGames = [Game]()
    fileprivate let reuseIdentifier = "ClueCell"
    fileprivate var selectedSection : Int?
    fileprivate let numberOfVisibleSections = 2
    
    static let onlyAudioImage = UIImage(named: "imageDefaultAudio")
    
    //MARK: - LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollArrowButton.isHidden = true
        self.gamesCollectionView.allowsMultipleSelection = false
        
        GameServices.retrieveAllGames({ result in
            self.allGames = result
            self.gamesCollectionView.reloadData()
            
            if (self.allGames.count > self.numberOfVisibleSections){
                self.scrollArrowButton.isHidden = false
            }
        })
        
        
    }
    
    //MARK: - DATASOURCE
    
    func numberOfSectionsInCollectionView(_ collectionView: UICollectionView) -> Int {
        
        return allGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allGames[section].wordsAndClueArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GameCollectionViewCell
        let clueWord = allGames[indexPath.section].wordsAndClueArray[indexPath.row].word
        let imageID = allGames[indexPath.section].wordsAndClueArray[indexPath.row].clue.imageID
        let audioPath = allGames[indexPath.section].wordsAndClueArray[indexPath.row].clue.audioPath
        
        // Clue Image
        if imageID != nil {
            
            let results = PHAsset.fetchAssets(withLocalIdentifiers: [imageID!], options: nil)
            
            if results.firstObject != nil {
                
                PHImageManager.default().requestImage(for: results.firstObject!, targetSize: CGSize(width: 1024,height: 1024), contentMode: .aspectFit, options: nil, resultHandler:
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
            cell.audioImage.isHidden = false
        }else{
            cell.audioImage.isHidden = true
        }
        
        // Selection design to the cell (green border or not)
        cell.layer.borderColor = UIColor.greenPalete().cgColor
        if (self.selectedSection != nil) && (indexPath.section == self.selectedSection){
            cell.layer.borderWidth = 3
        }else{
            cell.layer.borderWidth = 0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AllGamesHeader",for: indexPath) as! GamesHeaderView
            headerView.title.text = allGames[indexPath.section].name
            return headerView
            
        
        case UICollectionElementKindSectionFooter:
            
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AllGamesFooter",for: indexPath) 
            return footerView

        default:
            assert(false, "Unexpected element kind")
        }
        
        return UICollectionReusableView()
    }
    
    // MARK: - DELEGATE
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSizeForGame = collectionView.bounds.size.width/6.8
        return CGSize(width: cellSizeForGame, height: cellSizeForGame)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
            self.playButton.isHidden = false
            self.playTextButton.isHidden = false
        }else{
            self.playButton.isHidden = true
            self.playTextButton.isHidden = true
        }
        
    }
    
    //MARK: - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (selectedSection != nil){
            
            let indicator = LGStandarts.standartLGActivityIndicator(self.view)
            self.view.addSubview(indicator)
            indicator.startAnimating()
            
            let selectedGame = allGames[selectedSection!].wordsAndClueArray
            
            let aGenerator = LGCrosswordGenerator(rows: BoardView.maxSquaresInCol, cols: BoardView.maxSquaresinRow, maxloops: 2000, avaiableWords: selectedGame)
            aGenerator.computeCrossword(3, spins: 6)
            
            if (segue.identifier == "CreateGameFromSelectedGame" ) {
                (segue.destination as! GamePlayViewController).crosswordMatrix = aGenerator.grid
                (segue.destination as! GamePlayViewController).words = aGenerator.currentWordlist
            }
            
            indicator.removeFromSuperview()
        }
        
    }
    
}
