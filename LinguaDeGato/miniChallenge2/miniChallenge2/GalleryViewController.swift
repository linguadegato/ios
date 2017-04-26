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

class GalleryViewController: UIViewController, UICollectionViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var scrollArrowButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var galleryAndGamesVC: GalleryAndGamesViewController!
    
    fileprivate var gallery = [WordAndClue]()
    fileprivate var selectedWords = [WordAndClue]()
    
    fileprivate let maximumNumberOfWords = 6
    fileprivate let numberOfVisibleColumns = 4
    fileprivate let numberOfVisibleLines = 3
    fileprivate let reuseIdentifier = "ClueCell"
    fileprivate let collectionTitle = NSLocalizedString("GalleryViewController.collectionTitle", value: "Saved words", comment: "Collection view title to saved words")

    //MARK: - LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollArrowButton.isHidden = true
        self.galleryCollectionView.allowsMultipleSelection = true
        self.galleryCollectionView.flashScrollIndicators()
        
        WordAndClueServices.retriveAllWordAndClues({result in
            self.gallery = result
            self.galleryCollectionView.reloadData()
            
            let numberOfVisibleCells = self.numberOfVisibleColumns * self.numberOfVisibleLines
            if (self.gallery.count > numberOfVisibleCells){
                self.scrollArrowButton.isHidden = false
            }

        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        WordAndClueServices.retriveAllWordAndClues { (result) in
            self.gallery = result
        }
    }
    
    //MARK: - DATASOURCE
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSizeForGallery = collectionView.bounds.size.height/3.1
        return CGSize(width: cellSizeForGallery, height: cellSizeForGallery)
        
    }
    
    @objc(numberOfSectionsInCollectionView:) func numberOfSections(in: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryCollectionViewCell
        let clueWord = self.gallery[indexPath.row].word
        let imageID = self.gallery[indexPath.row].clue.imageID
        let audioClue = self.gallery[indexPath.row].clue.audioPath
        
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
        }else{
            cell.audioImage.isHidden = true
        }
        
        //set layout if the cell is selected
        cell.isSelected = (self.selectedWords.contains(self.gallery[indexPath.row])) ? true : false
        if cell.isSelected {
            cell.layer.borderWidth = 3
            cell.layer.borderColor = UIColor.greenPalete().cgColor
            cell.selectImage.isHidden = false
            
            self.showButtons()
            
            galleryCollectionView.reloadInputViews()
        }
        else {
            cell.layer.borderWidth = 0
            cell.layer.borderColor = UIColor.greenPalete().cgColor
            cell.selectImage.isHidden = true
            
            if (self.selectedWords.isEmpty){
                self.hideButtons()
                galleryCollectionView.reloadInputViews()
            }
        }
        
        return cell
    }
    
    // MARK: - DELEGATE
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (selectedWords.count < maximumNumberOfWords){
            selectedWords.append(gallery[indexPath.row])
            selectCell(indexPath)
        }
        
        if (selectedWords.count == maximumNumberOfWords){
            opaqueCells()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
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
    
    //MARK: - BUTTON ACTIONS
    @IBAction func createNewGame(_ sender: AnyObject) {
        
        let saveAlert = UIAlertController(
            
            title: NSLocalizedString("GalleryViewController.saveAlert.title", value: "Save this game?", comment: "Alert title asking if the user wants to save the new game"),
            message: NSLocalizedString("GalleryViewController.saveAlert.message", value: "Give a name for this new game", comment: "Alert message when is saving a new game saying the user to give a name to this game"),
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        saveAlert.addTextField(configurationHandler: { alertTextField in
            alertTextField.placeholder = NSLocalizedString("GalleryViewController.saveAlert.placeholder", value: "Name of the game", comment: "TextField placeholder to the game name")
        })
        let alertTextField = saveAlert.textFields![0]
        alertTextField.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        
        saveAlert.addAction(UIAlertAction(
            title: NSLocalizedString("GalleryViewController.saveAlert.SaveBtn", value: "Save", comment: "Save button on alert popup that asks if the user wants to save a new game."),
            style: UIAlertActionStyle.cancel,
            handler:{
                _ in
                if alertTextField.text != nil && alertTextField.text!.characters.count > 0 {
                    let newGame = Game(gameName: alertTextField.text!, wordsAndClue: self.selectedWords)
                    
                    let indicator = LGStandarts.standartLGActivityIndicator(self.view)
                    self.view.addSubview(indicator)
                    indicator.startAnimating()
                    
                    GameServices.saveGame(newGame, completion: { success in
                        OperationQueue.main.addOperation(BlockOperation(block: {
                            indicator.removeFromSuperview()
                            if success {
                               self.performSegue(withIdentifier: "CreateGameFromGallery", sender: nil)
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
            title: NSLocalizedString("GalleryViewController.saveAlert.CancelBtn", value: "No", comment: "Cancel action button on alert popup that asks if the user wants to save a new game."),
            style: UIAlertActionStyle.default,
            handler: {_ in self.performSegue(withIdentifier: "CreateGameFromGallery", sender: nil)}
            ))
        
        self.present(saveAlert, animated: true, completion: {
        })
    }
    
    @IBAction func scrollButton(_ sender: AnyObject) {
        let visibleItens = self.galleryCollectionView.indexPathsForVisibleItems
        let firstCellVisible = visibleItens[self.numberOfVisibleColumns]
        let firstPosition = UICollectionViewScrollPosition.top
        self.galleryCollectionView.scrollToItem(at: firstCellVisible, at: firstPosition, animated: true)
    }
    
    @IBAction func deleteWordsButton(_ sender: UIButton) {
        
        let deleteWordsAlert = UIAlertController(
            title: NSLocalizedString("galleryViewController.deleteWordsAlert.title", value:"Delete these words?", comment:"Ask the user if he wants to go delete words."),
            message: NSLocalizedString("galleryViewController.deleteWordsAlert.message", value:"The selected words will be deleted from your list and from your saved games.", comment:"Message informing the user that only the game will be deleted (not the words)."),
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        deleteWordsAlert.addAction(UIAlertAction(
            title: NSLocalizedString("galleryViewController.deleteWordsAlert.button.cancel", value:"Cancel", comment:"Button to cancel the action of deleting game."),
            style: UIAlertActionStyle.default,
            handler:nil
        ))
        
        deleteWordsAlert.addAction(UIAlertAction(
            title: NSLocalizedString("galleryViewController.deleteWordsAlert.button.continue", value:"Delete", comment:"Button to continue the action and delete game."),
            style: UIAlertActionStyle.destructive,
            handler: {_ in
                self.deleteWords()
            }
        ))
        
        self.present(deleteWordsAlert, animated: true, completion: {})

    }
    
    //MARK: - DATABASE RELATED METHODS
    
    fileprivate func overwriteGame(_ aGame: Game) {
        
        let overwriteAlert = UIAlertController(
            title: NSLocalizedString("GalleryViewController.overwriteGameAlert.title", value: "Overwrite game?", comment: "Alert title asking if the user wants to overwrite the game with the same name."),
            
            message: NSLocalizedString("GalleryViewController.overwriteGameAlert.message", value: "You already have a game named \(aGame.name). Do you want to overwrite it?", comment: "Alert message saying that there is game with the same name and asking if the user wants to overwrite it."),
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        overwriteAlert.addAction(UIAlertAction(
            title: NSLocalizedString("GalleryViewController.overwriteGameAlert.YesBtn", value: "Yes", comment: "Yes button on alert popup that save the game and overwrite the other with the same name."),
            style: UIAlertActionStyle.default,
            handler: {_ in
                let indicator = LGStandarts.standartLGActivityIndicator(self.view)
                self.view.addSubview(indicator)
                indicator.startAnimating()
                
                GameServices.overwriteGame(aGame, completion: {
                    OperationQueue.main.addOperation(BlockOperation(block: {
                        indicator.removeFromSuperview()
                    }))
                    
                })
                self.performSegue(withIdentifier: "CreateGameFromGallery", sender: nil)
        }
        ))
        
        overwriteAlert.addAction(UIAlertAction(
            title: NSLocalizedString("GalleryViewController.overwriteGameAlert.NoBtn", value: "No", comment: "No button on alert popup that cancel the saving process."),
            style: UIAlertActionStyle.cancel,
            handler: {_ in
                self.createNewGame(self)
        }
        ))
        
        self.present(overwriteAlert, animated: true, completion: nil)
    }
    
    fileprivate func deleteWords(){
        for word in selectedWords {
            WordAndClueServices.deleteWordAndClue(wac: word)
        }
        
        self.selectedWords = []
        WordAndClueServices.retriveAllWordAndClues { (result) in
            self.gallery = result
        }
        self.galleryCollectionView.reloadData()
        self.galleryAndGamesVC.gamesVC.loadFromDataBase()
        self.galleryAndGamesVC.gamesVC.gamesCollectionView.reloadData()
    }
    
    //MARK: - AUXILIAR PRIVATE METHODS
    
    // MARK: Behavior when select and deselect cells
    fileprivate func selectCell(_ indexPath: IndexPath){
        
        let selectedCell = galleryCollectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell
        
        selectedCell.layer.borderWidth = 3
        selectedCell.layer.borderColor = UIColor.greenPalete().cgColor
        selectedCell.selectImage.isHidden = false
        
        self.showButtons()
        
        galleryCollectionView.reloadInputViews()
    }
    
    fileprivate func deselectCell(_ indexPath: IndexPath){
        
        let selectedCell = galleryCollectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell
        
        selectedCell.layer.borderWidth = 0
        selectedCell.layer.borderColor = UIColor.greenPalete().cgColor
        selectedCell.selectImage.isHidden = true
        
        if (selectedWords.isEmpty){
            hideButtons()
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
    
    //MARK: Show and hide delete/play buttons
    fileprivate func hideButtons(){
        self.playButton.isHidden = true
        self.deleteButton.isHidden = true
    }
    
    fileprivate func showButtons(){
        self.playButton.isHidden = false
        self.deleteButton.isHidden = false
    }
    
    //MARK: - NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "CreateGameFromGallery" ) {
            (segue.destination as! GamePlayViewController).words = selectedWords
            deselectAllCells()
            selectedWords = []
        }
    }
}
