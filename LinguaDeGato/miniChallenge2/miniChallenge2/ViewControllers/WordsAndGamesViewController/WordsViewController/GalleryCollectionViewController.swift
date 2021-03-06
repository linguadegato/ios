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
    
    fileprivate let gameViewControler = GamePlayViewController()
    fileprivate let maximumNumberOfWords = 6
    fileprivate let reuseIdentifier = "ClueCell"
    fileprivate let collectionTitle = NSLocalizedString("GalleryCollectionViewController.collectionTitle", value: "Saved words", comment: "Title da collection view where are shown the saved words in 'saved games' view")
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        galleryCollectionView.allowsMultipleSelection = true
        WordAndClueServices.retriveAllWordAndClues({result in
            
            self.gallery = result
            self.galleryCollectionView.reloadData()
        })

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let cellSizeForGallery = collectionView.bounds.size.width/5
        return CGSize(width: cellSizeForGallery, height: cellSizeForGallery)
        
    }
    
    //MARK: - DATASOURCE
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryCollectionViewCell
        let clueWord = gallery[indexPath.row].word
        let imageID = gallery[indexPath.row].clue.imageID
        let audioClue = gallery[indexPath.row].clue.audioPath
        
        //set image
        if imageID != nil {
            let results = PHAsset.fetchAssets(withLocalIdentifiers: [imageID!], options: nil)
            
            if results.firstObject != nil {
            
                PHImageManager.default().requestImage(for: results.firstObject!, targetSize: CGSize(width: 1024,height: 1024), contentMode: .aspectFit, options: nil, resultHandler:
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
            cell.audioImage.isHidden = false
        }
        
        //set layout if the cell is selected
        cell.isSelected = (selectedWords.contains(gallery[indexPath.row])) ? true : false
        if cell.isSelected {
            cell.layer.borderWidth = 3
            cell.layer.borderColor = UIColor.greenPalete().cgColor
            cell.selectImage.isHidden = false
            
//            self.header.playButton.hidden = false
            galleryCollectionView.reloadInputViews()
        }
        else {
            cell.layer.borderWidth = 0
            cell.layer.borderColor = UIColor.greenPalete().cgColor
            cell.selectImage.isHidden = true
            
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
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (selectedWords.count < maximumNumberOfWords){
            selectedWords.append(gallery[indexPath.row])
            selectCell(indexPath)
        }
        
        if (selectedWords.count == maximumNumberOfWords){
            opaqueCells()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let wordToRemove = gallery[indexPath.row].word
        let imageToRemove = gallery[indexPath.row].clue.imageID
        
        for count in 0...selectedWords.count-1{
            if ((selectedWords[count].word == wordToRemove) && (selectedWords[count].clue.imageID == imageToRemove)){
                selectedWords.remove(at: count)
                deselectCell(indexPath)
                break
            }
        }
        
        if (selectedWords.count == maximumNumberOfWords-1){
            removeOpaqueCells()
        }
    }
    
    // MARK: - Behavior when select and deselect cells
    fileprivate func selectCell(_ indexPath: IndexPath){
        
        let selectedCell = galleryCollectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell

        selectedCell.layer.borderWidth = 3
        selectedCell.layer.borderColor = UIColor.greenPalete().cgColor
        selectedCell.selectImage.isHidden = false
        
//        self.header.playButton.hidden = false
        galleryCollectionView.reloadInputViews()
    }
    
    fileprivate func deselectCell(_ indexPath: IndexPath){
        
        let selectedCell = galleryCollectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell

        selectedCell.layer.borderWidth = 0
        selectedCell.layer.borderColor = UIColor.greenPalete().cgColor
        selectedCell.selectImage.isHidden = true
        
        if (selectedWords.isEmpty){
//            header.playButton.hidden = true
            galleryCollectionView.reloadInputViews()
        }
    }
    
    fileprivate func deselectAllCells(){
        
        selectedWords = []

    }
    
    fileprivate func opaqueCells(){
        let selectedCells = galleryCollectionView.indexPathsForSelectedItems
        if (selectedCells?.isEmpty == false){
            
            let numberOfCells = galleryCollectionView.numberOfItems(inSection: 0)
            
            for cellIndex in 0...numberOfCells-1{
                let indexPath = IndexPath(item: cellIndex, section: 0)
                
                //not selected item
                if (selectedCells!.contains(indexPath) == false){
                    let notSelecteCell = self.galleryCollectionView.cellForItem(at: indexPath)
                    notSelecteCell?.alpha = 0.5
                }
            }
        }
    }
    
    fileprivate func removeOpaqueCells(){
        let numberOfCells = galleryCollectionView.numberOfItems(inSection: 0)
        
        for cellIndex in 0...numberOfCells-1{
            let indexPath = IndexPath(item: cellIndex, section: 0)
            let cell = self.galleryCollectionView.cellForItem(at: indexPath)
            if (cell?.alpha == 0.5){
                cell?.alpha = 1
            }
        }
    }
    
    // MARK: For debug
    fileprivate func printSelecteWords(){
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
    @IBAction func createNewGame(_ sender: AnyObject) {
        
        let saveAlert = UIAlertController(
            title: NSLocalizedString("GalleryCollectionViewController.saveAlert.title", value: "Save this game?", comment: "Alert title asking if the user wants to save the new game"),
            message: NSLocalizedString("GalleryCollectionViewController.saveAlert.message", value: "Give a name for this game", comment: "Alert message when is saving a new game saying the user to give a name to this game"),
            preferredStyle: UIAlertController.Style.alert
        )
        
        saveAlert.addTextField(configurationHandler: { alertTextField in
            alertTextField.placeholder = NSLocalizedString("GalleryCollectionViewController.saveAlert.placeholder", value: "Name of the game", comment: "TextField placeholder to the game name")
        })
        let alertTextField = saveAlert.textFields![0]
        
        saveAlert.addAction(UIAlertAction(
            title: NSLocalizedString("GalleryCollectionViewController.saveAlert.SaveBtn", value: "Save", comment: "Save button on alert popup that asks if the user wants to save a new game."),
            style: UIAlertAction.Style.cancel,
            handler:{
                _ in
                if alertTextField.text != nil && alertTextField.text!.count > 0 {
                    let newGame = Game(gameName: alertTextField.text!, wordsAndClue: self.selectedWords)
                    GameServices.saveGame(newGame, completionHandler: {
                        success in
                        if success {
                            let operation = BlockOperation(block: {
                                () -> Void in self.performSegue(withIdentifier: "CreateGameFromGallery", sender: nil)
                            })
                            OperationQueue.main.addOperation(operation)
                        }else{
                            OperationQueue.main.addOperation(BlockOperation(block: {
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
            title: NSLocalizedString("GalleryCollectionViewController.saveAlert.CancelBtn", value: "No", comment: "Cancel action button on alert popup that asks if the user wants to save a new game."),
            
            style: UIAlertAction.Style.default,
            
            handler: {_ in self.performSegue(
                withIdentifier: "CreateGameFromGallery", sender: nil
            )}
        ))
        
        self.present(saveAlert, animated: true, completion: {
        })
    }
    
    fileprivate func overwriteGame(_ aGame: Game) {
        let overwriteAlert = UIAlertController(
            title: NSLocalizedString("GalleryCollectionViewController.overwriteGameAlert.title", value: "Overwrite game?", comment: "Alert title asking if the user wants to overwrite the game with the same name."),
            
            message: NSLocalizedString("GalleryCollectionViewController.overwriteGameAlert.message", value: "You already have a game named \(aGame.name). Do you want to overwrite it?", comment: "Alert message saying that there is game with the same name and asking if the user wants to overwrite it."),
            
            preferredStyle: UIAlertController.Style.alert
        )
        
        overwriteAlert.addAction(UIAlertAction(
            title: NSLocalizedString("GalleryCollectionViewController.overwriteGameAlert.YesBtn", value: "Yes", comment: "Yes button on alert popup that save the game and overwrite the other with the same name."),
            style: UIAlertAction.Style.default, handler: {_ in
                GameServices.overwriteGame(aGame, completionHandler: {})
                self.performSegue(withIdentifier: "GenerateCrossword", sender: nil)
            }
        ))
        
        overwriteAlert.addAction(UIAlertAction(
            title: NSLocalizedString("GalleryCollectionViewController.overwriteGameAlert.NoBtn", value: "No", comment: "No button on alert popup that cancel the saving process."),
            style: UIAlertAction.Style.cancel,
            handler: {_ in
                self.createNewGame(self)
            }
        ))
        
        self.present(overwriteAlert, animated: true, completion: nil)
    }
    
}
