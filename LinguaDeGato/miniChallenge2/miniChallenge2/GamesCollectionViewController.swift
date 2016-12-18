//
//  SavedGamesViewController.swift
//  LinguaDeGato
//
//  Created by Kobayashi on 1/7/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class GamesCollectionViewController : UICollectionViewController{
    
    @IBOutlet var gamesCollectionView: UICollectionView!
    
    var allGames = [Game]()
    
    fileprivate let reuseIdentifier = "ClueCell"
    
    static let onlyAudioImage = UIImage(named: "imageDefaultAudio")
        
    //MARK: - LIFECYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GameServices.retrieveAllGames({ result in
            
            self.allGames = result
            self.gamesCollectionView.reloadData()
        })
    }
    
    //MARK: - DATASOURCE
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return allGames.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allGames[section].wordsAndClueArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GameCollectionViewCell
        let clueWord = allGames[indexPath.section].wordsAndClueArray[indexPath.row].word
        let imageID = allGames[indexPath.section].wordsAndClueArray[indexPath.row].clue.imageID
        let audioPath = allGames[indexPath.section].wordsAndClueArray[indexPath.row].clue.audioPath
        
        //set image
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
        
        cell.labelCell.text = clueWord
        
        if (audioPath != nil){
            cell.audioImage.isHidden = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let cellSizeForGame = collectionView.bounds.size.width/6.8
        return CGSize(width: cellSizeForGame, height: cellSizeForGame)
        
    }
    
}
