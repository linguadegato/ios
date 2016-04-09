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
    
    private let gameViewControler = GamePlayViewController()
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
        
        let cellSizeForGallery = collectionView.bounds.size.width/5
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
        let audioClue = gallery[indexPath.row].clue.audioPath
        
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
        } else {
            cell.imageCell.image = AppImages.onlyAudioImage
        }
        
        //set image name
        cell.labelCell.text = clueWord
        
        //set audio button or not
        if (audioClue != nil) {
            cell.audioImage.hidden = false
        }
        
        //set layout if the cell is selected
        cell.selected = (selectedWords.contains(gallery[indexPath.row])) ? true : false
        if cell.selected {
            cell.layer.borderWidth = 3
            cell.layer.borderColor = UIColor.greenPalete().CGColor
            cell.selectImage.hidden = false
            
//            self.header.playButton.hidden = false
            galleryCollectionView.reloadInputViews()
        }
        else {
            cell.layer.borderWidth = 0
            cell.layer.borderColor = UIColor.greenPalete().CGColor
            cell.selectImage.hidden = true
            
            if (selectedWords.isEmpty){
//                if header != nil {
//                    header.playButton.hidden = true
//                }
                galleryCollectionView.reloadInputViews()
            }
        }
        
        return cell
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
        
//        self.header.playButton.hidden = false
        galleryCollectionView.reloadInputViews()
    }
    
    private func deselectCell(indexPath: NSIndexPath){
        
        let selectedCell = galleryCollectionView.cellForItemAtIndexPath(indexPath) as! GalleryCollectionViewCell

        selectedCell.layer.borderWidth = 0
        selectedCell.layer.borderColor = UIColor.greenPalete().CGColor
        selectedCell.selectImage.hidden = true
        
        if (selectedWords.isEmpty){
//            header.playButton.hidden = true
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
    
    //MARK: - CREATE GAME BUTTON
    @IBAction func createNewGame(sender: AnyObject) {
        
        let saveAlert = UIAlertController(title: "Deseja salvar esse jogo?", message: "Dê um nome ao jogo para que possa ser salvo", preferredStyle: UIAlertControllerStyle.Alert)
        
        saveAlert.addTextFieldWithConfigurationHandler({ alertTextField in
            alertTextField.placeholder = "Nome do jogo"
        })
        let alertTextField = saveAlert.textFields![0]
        
        saveAlert.addAction(UIAlertAction(
            title: "Salvar",
            style: UIAlertActionStyle.Cancel,
            handler:{
                _ in
                if alertTextField.text != nil && alertTextField.text!.characters.count > 0 {
                    let newGame = Game(gameName: alertTextField.text!, wordsAndClue: self.selectedWords)
                    GameServices.saveGame(newGame, completion: {
                        success in
                        if success {
                            let operation = NSBlockOperation(block: {
                                () -> Void in self.performSegueWithIdentifier("CreateGameFromGallery", sender: nil)
                            })
                            NSOperationQueue.mainQueue().addOperation(operation)
                        }else{
                            NSOperationQueue.mainQueue().addOperation(NSBlockOperation(block: {
                                self.overwriteGame(newGame)
                            }))
                        }
                    })
                }else {
                    print("empty text field!")
                }
            }
        ))
        
        saveAlert.addAction(UIAlertAction(
            title: "Não",
            style: UIAlertActionStyle.Default,
            handler: {_ in self.performSegueWithIdentifier("CreateGameFromGallery", sender: nil)}
        ))
        
        self.presentViewController(saveAlert, animated: true, completion: {
        })
    }
    
    private func overwriteGame(aGame: Game) {
        let overwriteAlert = UIAlertController(title: "Sobreescrever jogo?", message: "Já existe um jogo salvo com o nome \(aGame.name).\nDeseja sobreescrevê-lo?", preferredStyle: UIAlertControllerStyle.Alert)
        
        overwriteAlert.addAction(UIAlertAction(title: "Sim", style: UIAlertActionStyle.Default, handler: {_ in
            GameServices.overwriteGame(aGame, completion: {})
            self.performSegueWithIdentifier("GenerateCrossword", sender: nil)
        }))
        
        overwriteAlert.addAction(UIAlertAction(title: "Não", style: UIAlertActionStyle.Cancel, handler: {_ in
            self.createNewGame(self)
        }))
        
        self.presentViewController(overwriteAlert, animated: true, completion: nil)
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