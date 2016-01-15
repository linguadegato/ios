//
//  SavedGamesViewController.swift
//  LinguaDeGato
//
//  Created by Kobayashi on 1/7/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import UIKit

class GamesCollectionViewController : UICollectionViewController{
    
    var allGames = [Game]()
    
    private let reuseIdentifier = "ClueCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //DataSource
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
            return headerView

        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellSizeForGame = collectionView.bounds.size.width/6.8
        return CGSizeMake(cellSizeForGame, cellSizeForGame)
        
    }

}