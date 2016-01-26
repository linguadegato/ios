//
//  GalleryCollectionViewController.swift
//  LinguaDeGato
//
//  Created by Kobayashi on 1/15/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation
import UIKit
import Photos

class GalleryCollectionViewController : UICollectionViewController{
    
    @IBOutlet var galleryCollectionView: UICollectionView!
    
    var gallery = [WordAndClue]()
    var selectedWords = [WordAndClue]()

    private let maximumNumberOfWords = 6
    private let reuseIdentifier = "ClueCell"
    private let collectionTitle = "Palavras Salvas"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        galleryCollectionView.allowsMultipleSelection = true
        WordAndClueServices.retriveAllWordAndClues({result in
            
            self.gallery = result
            self.galleryCollectionView.reloadData()
        })

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellSizeForGallery = collectionView.bounds.size.width/3.2
        return CGSizeMake(cellSizeForGallery, cellSizeForGallery)
        
    }
    
    //MARK: - DATASOURCE
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GalleryCollectionViewCell
        let clueWord = gallery[indexPath.row].word
        let imageID = gallery[indexPath.row].clue.imageID
        
        //set image
        if imageID != nil {
            
            let results = PHAsset.fetchAssetsWithLocalIdentifiers([imageID!], options: nil)
            
            if results.firstObject != nil {
            
                PHImageManager.defaultManager().requestImageForAsset(results.firstObject as! PHAsset, targetSize: CGSize(width: 1024,height: 1024), contentMode: .AspectFit, options: nil, resultHandler:
                    { (aImage, _) -> Void in
                        cell.imageCell.image = aImage
                })
            }
            else {
                cell.imageCell.image = AppImages.onlyAudioImage
            }
        }
        else {
            cell.imageCell.image = AppImages.onlyAudioImage
        }
        
        cell.labelCell.text = clueWord
        
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
        if (selectedWords.count < maximumNumberOfWords){
            selectedWords.append(gallery[indexPath.row])
            selectCell(indexPath)
        }
        
        if (selectedWords.count == maximumNumberOfWords){
            opaqueCells()
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let wordToRemove = gallery[indexPath.row].word
        let imageToRemove = gallery[indexPath.row].clue.imageID
        
        for count in 0...selectedWords.count-1{
            if ((selectedWords[count].word == wordToRemove) && (selectedWords[count].clue.imageID == imageToRemove)){
                selectedWords.removeAtIndex(count)
                deselectCell(indexPath)
                break
            }
        }
        
        if (selectedWords.count == maximumNumberOfWords-1){
            removeOpaqueCells()
        }
    }
    
    // MARK: - Behavior when select and deselect cells
    private func selectCell(indexPath: NSIndexPath){
        
        
        let selectedCell = galleryCollectionView.cellForItemAtIndexPath(indexPath) as! GalleryCollectionViewCell

        selectedCell.layer.borderWidth = 3
        selectedCell.layer.borderColor = UIColor.greenPalete().CGColor
        selectedCell.selectImage.hidden = false
        
        let header = galleryCollectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "GalleryHeader", forIndexPath: indexPath) as! GalleryHeaderView
        header.playButton.hidden = false

    }
    
    private func deselectCell(indexPath: NSIndexPath){
        let selectedCell = galleryCollectionView.cellForItemAtIndexPath(indexPath) as! GalleryCollectionViewCell

        selectedCell.layer.borderWidth = 0
        selectedCell.layer.borderColor = UIColor.greenPalete().CGColor
        selectedCell.selectImage.hidden = true
        
        if (selectedWords.isEmpty){
            let header = galleryCollectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "GalleryHeader", forIndexPath: indexPath) as! GalleryHeaderView
            header.playButton.hidden = true
        }
    }
    
    private func deselectAllCells(){
        let selectedCells = galleryCollectionView.indexPathsForSelectedItems()
        if (selectedCells?.isEmpty == false){
            let numberOfSelectedCells = selectedCells!.count
            for count in 0...numberOfSelectedCells-1{
                let indexPath = selectedCells![count]
                
                let selectedCell = galleryCollectionView.cellForItemAtIndexPath(indexPath) as! GalleryCollectionViewCell
                
                selectedCell.layer.borderWidth = 0
                selectedCell.layer.borderColor = UIColor.greenPalete().CGColor
                selectedCell.selectImage.hidden = true
                galleryCollectionView.deselectItemAtIndexPath(indexPath, animated: false)
                
                // Disable play button on header
                let header = galleryCollectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "GalleryHeader", forIndexPath: indexPath) as! GalleryHeaderView
                header.playButton.hidden = true

            }
        }
        
        
    }
    
    private func opaqueCells(){
        let selectedCells = galleryCollectionView.indexPathsForSelectedItems()
        if (selectedCells?.isEmpty == false){
            
            let numberOfCells = galleryCollectionView.numberOfItemsInSection(0)
            
            for cellIndex in 0...numberOfCells-1{
                let indexPath = NSIndexPath(forItem: cellIndex, inSection: 0)
                
                //not selected item
                if (selectedCells!.contains(indexPath) == false){
                    let notSelecteCell = self.galleryCollectionView.cellForItemAtIndexPath(indexPath)
                    notSelecteCell?.alpha = 0.5
                }
            }
        }
    }
    
    private func removeOpaqueCells(){
        let numberOfCells = galleryCollectionView.numberOfItemsInSection(0)
        
        for cellIndex in 0...numberOfCells-1{
            let indexPath = NSIndexPath(forItem: cellIndex, inSection: 0)
            let cell = self.galleryCollectionView.cellForItemAtIndexPath(indexPath)
            if (cell?.alpha == 0.5){
                cell?.alpha = 1
            }
        }
    }
    
    // MARK: For debug
    private func printSelecteWords(){
        if (selectedWords.count > 0){
            for count in 0...selectedWords.count-1{
                print("pos\(count): \(selectedWords[count].word)")
            }
            print("-----")
        }else{
            print("nenhuma palavra selecionada")
        }
    }
    
    //MARK: - NAVIGATION
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //MARK: HARRY-TODO: ACTIVITY INDICATOR
        
        let aGenerator = LGCrosswordGenerator(rows: BoardView.maxSquaresInCol, cols: BoardView.maxSquaresinRow, maxloops: 2000, avaiableWords: selectedWords)
        aGenerator.computeCrossword(2, spins: 4)
        
        if (segue.identifier == "CreateGameFromGallery" ) {
            
            (segue.destinationViewController as! GamePlayViewController).crosswordMatrix = aGenerator.grid
            (segue.destinationViewController as! GamePlayViewController).words = aGenerator.currentWordlist
            
            deselectAllCells()
            selectedWords = []
        }
        
    }
    
}