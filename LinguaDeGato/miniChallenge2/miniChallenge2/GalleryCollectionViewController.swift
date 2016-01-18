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
    
    @IBOutlet var galleryCollectionView: UICollectionView!
    
    var gallery = [WordAndClue]()
    var selectedWords = [WordAndClue]()

    private let reuseIdentifier = "ClueCell"
    private let collectionTitle = "Galeria"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        galleryCollectionView.allowsMultipleSelection = true
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellSizeForGallery = collectionView.bounds.size.width/3.2
        return CGSizeMake(cellSizeForGallery, cellSizeForGallery)
        
    }
    
    //MARK: -DataSource
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
    
    // MARK: Selection and deselection of a celll
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (selectedWords.count < 6){
            selectedWords.append(gallery[indexPath.row])
            setSelectedDesignToCell(indexPath)
        }
        
        /*
        TODO: else exibir alerta de que o máximo de palavras são 6
        */
        
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let wordToRemove = gallery[indexPath.row].word
        let imageToRemove = gallery[indexPath.row].clue.imageID
        
        for count in 0...selectedWords.count-1{
            if ((selectedWords[count].word == wordToRemove) && (selectedWords[count].clue.imageID == imageToRemove)){
                selectedWords.removeAtIndex(count)
                setDeselectedDesignToCell(indexPath)
                break
            }
        }
    }
    
    // MARK: - Design
    private func setSelectedDesignToCell(indexPath: NSIndexPath){
        let selectedCell = galleryCollectionView.cellForItemAtIndexPath(indexPath) as! GalleryCollectionViewCell

        selectedCell.layer.borderWidth = 3
        selectedCell.layer.borderColor = UIColor.greenPalete().CGColor
        selectedCell.selectImage.hidden = false
        
    }
    
    private func setDeselectedDesignToCell(indexPath: NSIndexPath){
        let selectedCell = galleryCollectionView.cellForItemAtIndexPath(indexPath) as! GalleryCollectionViewCell

        selectedCell.layer.borderWidth = 0
        selectedCell.layer.borderColor = UIColor.greenPalete().CGColor
        selectedCell.selectImage.hidden = true
        
    }
    
}