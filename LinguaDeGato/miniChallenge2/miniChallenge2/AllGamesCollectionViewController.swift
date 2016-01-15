//
//  SavedGamesViewController.swift
//  LinguaDeGato
//
//  Created by Kobayashi on 1/7/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import UIKit

class AllGamesCollectionViewController : UICollectionViewController{
    
    @IBOutlet var allWordsCollectionView: UICollectionView!
    
    var words = [Game]()
    var collectionType = String()
    
    private let reuseIdentifier = "ClueCell"
    private let gamesViewController = "AllGames"
    private let galleryViewController = "Gallery"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //DataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return words.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words[section].wordsAndClueArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ClueCollectionViewCell
        
        cell.labelCell.text = words[indexPath.section].wordsAndClueArray[indexPath.row].word

        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "AllGamesHeader",forIndexPath: indexPath) as! AllGamesHeaderView
            headerView.title.text = words[indexPath.section].name
            return headerView

        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        // Design:
        let cellSizeForGallery = collectionView.bounds.size.width/3.2
        let cellSizeForGame = collectionView.bounds.size.width/6.8
        
        if (collectionType == gamesViewController){
            return CGSizeMake(cellSizeForGame, cellSizeForGame)
        }else{
            return CGSizeMake(cellSizeForGallery, cellSizeForGallery)
        }
        
    }

}