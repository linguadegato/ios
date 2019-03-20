//
//  GamesViewController.swift
//  LinguaDeGato
//
//  Created by Kobayashi on 1/31/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class GamesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{

    @IBOutlet weak var gamesCollectionView: UICollectionView!
    @IBOutlet weak var bottomView: UIView!
    
    fileprivate var allGames = [Game]()
    fileprivate let reuseIdentifier = "ClueCell"
    fileprivate let numberOfVisibleSections = 2
    fileprivate var selectedSection : Int?
    
    static let onlyAudioImage = UIImage(named: "imageDefaultAudio")
    
    //MARK: - LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        GalleryGlobalValues.gamesViewController = (self.gamesCollectionView.delegate! as! GamesViewController)
        
        self.gamesCollectionView.allowsMultipleSelection = false
        
        GameServices.retrieveAllGames({ result in
            self.allGames = result
            DispatchQueue.main.async {
                self.gamesCollectionView.reloadData()
                if (self.allGames.count > self.numberOfVisibleSections){
                    self.bottomView.isHidden = false
                }else{
                    self.bottomView.isHidden = true
                }
            }
        })
    }
    
    //MARK: - DATASOURCE
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return allGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allGames[section].wordsAndClueArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GameCollectionViewCell
        let clueWord = allGames[indexPath.section].wordsAndClueArray[indexPath.row].word
        let imageID = allGames[indexPath.section].wordsAndClueArray[indexPath.row].clue.imageID
        let audioPath = allGames[indexPath.section].wordsAndClueArray[indexPath.row].clue.audioPath
        
        // Clue Image
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
        
        // Word
        cell.labelCell.text = clueWord
        
        // Clue audio
        if (audioPath != nil){
            cell.audioImage.isHidden = false
        }else{
            cell.audioImage.isHidden = true
        }
        
        
        // Border color and width
        cell.layer.borderColor = UIColor.greenPalete().cgColor
        if (self.selectedSection != nil) && (indexPath.section == self.selectedSection){
            cell.layer.borderWidth = 3
        }else{
            cell.layer.borderWidth = 0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AllGamesHeader",for: indexPath) as! GamesHeaderView
            headerView.title.text = allGames[indexPath.section].name
            headerView.setPlayBtnID(sectionNumber: indexPath.section)
            headerView.setDeleteBtnID(sectionNumber: indexPath.section)
            return headerView
            
        
        case UICollectionView.elementKindSectionFooter:
            
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AllGamesFooter",for: indexPath) 
            return footerView

        default:
            assert(false, "Unexpected element kind")
        }
        
        return UICollectionReusableView()
    }
    
    // MARK: - DELEGATE
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSizeForGame = collectionView.bounds.size.width/6.8
        return CGSize(width: cellSizeForGame, height: cellSizeForGame)
        
    }
    
    //MARK: - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "CreateGameFromSelectedGame"){
            let senderBtn = sender as! UIButton
            let selectedGameID = senderBtn.tag
            let selectedGame = allGames[selectedGameID].wordsAndClueArray
            let indicator = LGStandarts.standartLGActivityIndicator(self.view)
            
            self.view.addSubview(indicator)
            indicator.startAnimating()
            
            let aGenerator = LGCrosswordGenerator(rows: BoardView.maxSquaresInCol, cols: BoardView.maxSquaresinRow, maxloops: 2000, avaiableWords: selectedGame)
            aGenerator.computeCrossword(3, spins: 6)
            
            (segue.destination as! GamePlayViewController).crosswordMatrix = aGenerator.grid
            (segue.destination as! GamePlayViewController).words = aGenerator.currentWordlist
            
            indicator.removeFromSuperview()
        }
        
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func scrollArrowButton(_ sender: Any) {
        
        let visibleItens = self.gamesCollectionView.indexPathsForVisibleItems
        let firstSectionVisible = visibleItens[self.numberOfVisibleSections]
        let firstPosition = UICollectionView.ScrollPosition.top
        self.gamesCollectionView.scrollToItem(at: firstSectionVisible, at: firstPosition, animated: true)
        
    }
    
    @IBAction func deleteSelectedGame(_ sender: UIButton) {
        
        let gameID = sender.tag
        selectGame(gameID)
        
        let deleteGameAlert = UIAlertController(
            title: NSLocalizedString("gamesViewController.deleteGameAlert.title", value:"Delete this game?", comment:"Ask the user if he wants to go remove the game."),
            message: NSLocalizedString("gamesViewController.deleteGameAlert.message", value:"The selected game will be deleted, but its words will remain in your list of words.", comment:"Message informing the user that only the game will be deleted (not the words)."),
            preferredStyle: UIAlertController.Style.alert
        )
        
        deleteGameAlert.addAction(UIAlertAction(
            title: NSLocalizedString("gamesViewController.deleteGameAlert.button.cancel", value:"Cancel", comment:"Button to cancel the action of deleting game."),
            style: UIAlertAction.Style.default,
            handler:{_ in
                self.deselectGame(gameID)
            }
        ))
        
        deleteGameAlert.addAction(UIAlertAction(
            title: NSLocalizedString("gamesViewController.deleteGamelert.button.continue", value:"Delete", comment:"Button to continue the action and delete game."),
            style: UIAlertAction.Style.destructive,
            handler: {_ in
                self.deleteGame(gameID)
            }
        ))
        
        self.present(deleteGameAlert, animated: true, completion: {})
    }
    
    //MARK: - Delete game functions
    private func deleteGame(_ gameID: Int){
        print("delete btn \(gameID)")
        
        let toBeDeletedGame = allGames[gameID]
        
        GameServices.deleteGame(game: toBeDeletedGame)
        self.loadFromDataBase()
        
        self.selectedSection = nil
        gamesCollectionView.reloadData()
    }
    
    private func selectGame(_ gameID: Int){
        self.selectedSection = gameID
        gamesCollectionView.reloadSections([gameID])
    }
    
    private func deselectGame(_ gameID: Int){
        self.selectedSection = nil
        gamesCollectionView.reloadSections([gameID])
    }
    
    
    //MARK: - DATABASE AUXILIAR METHOD
    
    func loadFromDataBase() {
        GameServices.retrieveAllGames { result in
            self.allGames = result
        }
    }
}
