//
//  GalleryViewController.swift
//  LinguaDeGato
//
//  Created by Kobayashi on 1/30/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation
import UIKit
import Photos

class GalleryViewController: UIViewController, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playTextButton: UIButton!
    
    @IBOutlet weak var scrollArrowButton: UIButton!
    
    private var gallery = [WordAndClue]()
    private var selectedWords = [WordAndClue]()
    private let gameViewControler = GamePlayViewController()
    private let maximumNumberOfWords = 6
    private let numberOfVisibleColumns = 4
    private let numberOfVisibleLines = 3
    private let reuseIdentifier = "ClueCell"
    private let collectionTitle = "Palavras Salvas"

    //MARK: - LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollArrowButton.hidden = true
        self.galleryCollectionView.allowsMultipleSelection = true
        self.galleryCollectionView.flashScrollIndicators()
        
        WordAndClueServices.retriveAllWordAndClues({result in
            self.gallery = result
            self.galleryCollectionView.reloadData()
            
            let numberOfVisibleCells = self.numberOfVisibleColumns * self.numberOfVisibleLines
            if (self.gallery.count > numberOfVisibleCells){
                self.scrollArrowButton.hidden = false
            }

        })
        
    }
    
    //MARK: - DATASOURCE
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellSizeForGallery = collectionView.bounds.size.height/3.1
        return CGSizeMake(cellSizeForGallery, cellSizeForGallery)
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GalleryCollectionViewCell
        let clueWord = self.gallery[indexPath.row].word
        let imageID = self.gallery[indexPath.row].clue.imageID
        let audioClue = self.gallery[indexPath.row].clue.audioPath
        
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
        } else {
            cell.imageCell.image = AppImages.onlyAudioImage
        }
        
        //set image name
        cell.labelCell.text = clueWord
        
        //set audio button or not
        if (audioClue != nil) {
            cell.audioImage.hidden = false
        }else{
            cell.audioImage.hidden = true
        }
        
        //set layout if the cell is selected
        cell.selected = (self.selectedWords.contains(self.gallery[indexPath.row])) ? true : false
        if cell.selected {
            cell.layer.borderWidth = 3
            cell.layer.borderColor = UIColor.greenPalete().CGColor
            cell.selectImage.hidden = false
            
            self.playButton.hidden = false
            self.playTextButton.hidden = false
            
            galleryCollectionView.reloadInputViews()
        }
        else {
            cell.layer.borderWidth = 0
            cell.layer.borderColor = UIColor.greenPalete().CGColor
            cell.selectImage.hidden = true
            
            if (self.selectedWords.isEmpty){
                self.playButton.hidden = true
                self.playTextButton.hidden = true
                
                galleryCollectionView.reloadInputViews()
            }
        }
        
        return cell
    }
    
    // MARK: - DELEGATE
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (selectedWords.count < maximumNumberOfWords){
            selectedWords.append(gallery[indexPath.row])
            selectCell(indexPath)
        }
        
        if (selectedWords.count == maximumNumberOfWords){
            opaqueCells()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
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
        
        self.playButton.hidden = false
        self.playTextButton.hidden = false
        
        galleryCollectionView.reloadInputViews()
    }
    
    private func deselectCell(indexPath: NSIndexPath){
        
        let selectedCell = galleryCollectionView.cellForItemAtIndexPath(indexPath) as! GalleryCollectionViewCell
        
        selectedCell.layer.borderWidth = 0
        selectedCell.layer.borderColor = UIColor.greenPalete().CGColor
        selectedCell.selectImage.hidden = true
        
        if (selectedWords.isEmpty){
            self.playButton.hidden = true
            self.playTextButton.hidden = true
            
            galleryCollectionView.reloadInputViews()
        }
    }
    
    private func deselectAllCells(){
        
        selectedWords = []
        
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
    
    //MARK: - CREATE GAME BUTTON
    @IBAction func createNewGame(sender: AnyObject) {
        
        let saveAlert = UIAlertController(title: "Deseja salvar esse jogo?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        saveAlert.addTextFieldWithConfigurationHandler({ alertTextField in
            alertTextField.placeholder = "Nome do jogo"
        })
        let alertTextField = saveAlert.textFields![0]
        alertTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        
        saveAlert.addAction(UIAlertAction(
            title: "Salvar",
            style: UIAlertActionStyle.Default,
            handler:{
                _ in
                if alertTextField.text != nil && alertTextField.text!.characters.count > 0 {
                    let newGame = Game(gameName: alertTextField.text!, wordsAndClue: self.selectedWords)
                    
                    let indicator = LGStandarts.standartLGActivityIndicator(self.view)
                    self.view.addSubview(indicator)
                    indicator.startAnimating()
                    
                    GameServices.saveGame(newGame, completion: { success in
                        NSOperationQueue.mainQueue().addOperation(NSBlockOperation(block: {
                            indicator.removeFromSuperview()
                            if success {
                               self.performSegueWithIdentifier("CreateGameFromGallery", sender: nil)
                            }else{
                                self.overwriteGame(newGame)
                                
                            }
                        }))
                    })
                }else {
                    print("empty text field!")
                }
            }
            ))
        
        saveAlert.addAction(UIAlertAction(
            title: "Não",
            style: UIAlertActionStyle.Cancel,
            handler: {_ in self.performSegueWithIdentifier("CreateGameFromGallery", sender: nil)}
            ))
        
        self.presentViewController(saveAlert, animated: true, completion: {
        })
    }
    
    private func overwriteGame(aGame: Game) {
        let overwriteAlert = UIAlertController(title: "Sobreescrever jogo?", message: "Já existe um jogo salvo com o nome \(aGame.name).\nDeseja sobreescrevê-lo?", preferredStyle: UIAlertControllerStyle.Alert)
        
        overwriteAlert.addAction(UIAlertAction(title: "SIM", style: UIAlertActionStyle.Default, handler: {_ in
            
            let indicator = LGStandarts.standartLGActivityIndicator(self.view)
            self.view.addSubview(indicator)
            indicator.startAnimating()
            
            GameServices.overwriteGame(aGame, completion: {
                NSOperationQueue.mainQueue().addOperation(NSBlockOperation(block: {
                    indicator.removeFromSuperview()
                }))
            
            })
            self.performSegueWithIdentifier("CreateGameFromGallery", sender: nil)
        }))
        
        overwriteAlert.addAction(UIAlertAction(title: "NÃO", style: UIAlertActionStyle.Default, handler: {_ in
            self.createNewGame(self)
        }))
        
        self.presentViewController(overwriteAlert, animated: true, completion: nil)
    }
    
    //MARK: - SCROLL BUTOON
    
    @IBAction func scrollButton(sender: AnyObject) {
        let visibleItens = self.galleryCollectionView.indexPathsForVisibleItems()
        let firstCellVisible = visibleItens[self.numberOfVisibleColumns]
        let firstPosition = UICollectionViewScrollPosition.Top
        self.galleryCollectionView.scrollToItemAtIndexPath(firstCellVisible, atScrollPosition: firstPosition, animated: true)
    }
    
    //MARK: - NAVIGATION
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let indicator = LGStandarts.standartLGActivityIndicator(self.view)
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
        let aGenerator = LGCrosswordGenerator(rows: BoardView.maxSquaresInCol, cols: BoardView.maxSquaresinRow, maxloops: 2000, avaiableWords: selectedWords)
        aGenerator.computeCrossword(3, spins: 6)
        
        if (segue.identifier == "CreateGameFromGallery" ) {
            
            (segue.destinationViewController as! GamePlayViewController).crosswordMatrix = aGenerator.grid
            (segue.destinationViewController as! GamePlayViewController).words = aGenerator.currentWordlist
            
            deselectAllCells()
            selectedWords = []
        }
        
        indicator.removeFromSuperview()
    }
    
}
