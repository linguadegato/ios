//
//  GalleryCollectionViewController.swift
//  LinguaDeGato
//
//  Created by Kobayashi on 1/15/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation
import UIKit

class GalleryCollectionViewController : UICollectionViewController{
    
    @IBOutlet var allWordsCollectionView: UICollectionView!
    
    var gallery = [WordAndClue]()

    private let reuseIdentifier = "ClueCell"
    private let collectionTitle = "Galeria"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //DataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GalleryCollectionViewCell
        
        cell.labelCell.text = gallery[indexPath.row].word
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "GalleryHeader",forIndexPath: indexPath) as! GalleryHeaderView
            headerView.title.text = collectionTitle
            return headerView
            
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellSizeForGallery = collectionView.bounds.size.width/3.2
        return CGSizeMake(cellSizeForGallery, cellSizeForGallery)
        
    }
    
}