//
//  AllWordsViewController.swift
//  LinguaDeGato
//
//  Created by Kobayashi on 1/7/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

private let reuseIdentifier = "Cell"

class AllWordsViewController: UICollectionViewController {

    private let defaultImage = UIImage(named: "imageDefault")

    //MARK: [TODO] Revove this function later
    private var arrayNewWords: [WordAndClue] = []
    private func arrayJogo(){
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let imagePath = "\(paths)/image0.png"
        let aClue = Clue(aImageID: imagePath, anAudioPath: nil)
        let aWord = WordAndClue(aWord: "teste", aClue: aClue)
        
        arrayNewWords.append(aWord)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return arrayNewWords.count
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : GameCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ClueCell", forIndexPath: indexPath) as! GameCollectionViewCell

    
        // Configure the cell
        if indexPath.row < arrayNewWords.count {
            
            let aWord = arrayNewWords[indexPath.row]
            let wordLabel = aWord.word as NSString
            
            //Limits the length of the word when show in label
            //Just if it has an audio
            if (wordLabel.length > 0 && aWord.clue.audioPath != nil) {
                var wordLabelCut = wordLabel.substringWithRange(NSRange(location: 0, length: wordLabel.length > 9 ? 9 : wordLabel.length))
                
                if (wordLabel.length > 9) {
                    wordLabelCut = wordLabelCut + ("...")
                }
                cell.labelCell.text = wordLabelCut
            } else {
                cell.labelCell.text = wordLabel as String
            }
            
            cell.wordAndClue = aWord
            cell.index = indexPath.row
            
//            cell.delegate = self

            
//            let getImagePath = aWord.clue.imagePath!
            
//            if (aWord.clue.imagePath != nil){
//                if (aFileManager.fileExistsAtPath(getImagePath)){
//                    
//                    let selectedImage: UIImage = UIImage(contentsOfFile: getImagePath)!
//                    //let data: NSData = UIImagePNGRepresentation(selectedImage)!
//                    cell.imageCell.image = selectedImage
//                    
//                    if (aWord.clue.audioPath != nil){
//                        cell.audioImage.hidden = false
//                    }else{
//                        cell.audioImage.hidden = true
//                    }
//                    
//                }else{
//                    print("FILE NOT AVAILABLE");
//                }
//            }
            
            cell.labelCell.hidden = false
//            cell.deleteButton.hidden = false
        }
            
        else {
            cell.labelCell.hidden = true
//            cell.deleteButton.hidden = true
            cell.imageCell.image = defaultImage
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
