//
//  CrosswordClue.swift
//  miniChallenge2
//
//  This class store the clue data for a Crossword BoardView
//
//  Created by Andre Scherma Soleo on 09/10/15.
//  Copyright © 2015 Kobayashi. All rights reserved.
//
//  An object that stores multimedia clue information.

import UIKit
import AVFoundation
import Photos

//MARK: Is UIImage the best type to use?
class CrosswordClue: CrosswordElement {
    
    static let defaultImage = UIImage(named: "imageDefaultAudio")
    
    //it should really be optinal, since other types of clue will be implemented
    //and not all clue will have all kinds of media as clue.
    var image: UIImage?
    var audio: AVAudioPlayer?
    
    //data to generate a 3x3 "squares" ClueView at right position
    //var offsetToLeft: Bool!
    var isVertical: Bool!
    
    init(anImage: UIImage, anAudio: AVAudioPlayer){
        self.image = anImage
        self.audio = anAudio
    }
    
    init(imagePath: String?, audioPath: String?) {
        super.init()
        
        if imagePath != nil {
            
            let results = PHAsset.fetchAssetsWithLocalIdentifiers([imagePath!], options: nil)
            
            PHImageManager.defaultManager().requestImageForAsset(results.firstObject as! PHAsset, targetSize: CGSize(width: 1024,height: 1024), contentMode: .AspectFit, options: nil, resultHandler:
                { (aImage, _) -> Void in
                    
                    self.image = aImage
                }
            )
            
            
            
            if let aData = NSData(contentsOfURL: NSURL(fileURLWithPath: imagePath!)) {
                self.image = UIImage(data: aData)
            }
        }
        else {
            self.image = CrosswordClue.defaultImage
        }
        
        if audioPath != nil {
            do{
                try self.audio = AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(audioPath!))
            } catch{
                print("Doent have a sound")
            }
        }
    }
    
    //create a 3x3 (in "squares") clue view, adjusting the rect with its offset
    override func generateSquareView(squareSize: CGSize, elementCoordX: Int, elementCoordY: Int, board: BoardView) -> BoardCellView? {
        
        var originXoffset: CGFloat = 0
        var originYoffset: CGFloat = 0
        
        //set the clue origin offset
        if isVertical! {
            originXoffset = -squareSize.width
        }
        else {
            originYoffset = -squareSize.height
        }
        
        let originX = board.centerBoard!.frame.origin.x + (CGFloat(elementCoordX) * squareSize.width) + originXoffset
        let originY = board.centerBoard!.frame.origin.y + (CGFloat(elementCoordY) * squareSize.height) + originYoffset
        
        let aRect = CGRect(x: originX, y: originY, width: squareSize.width * 3, height: squareSize.height * 3)
        let square = ClueView(frame: aRect, vertical: isVertical!, aDelegate: board, aImage: self.image, anAudio: self.audio)
        
        return square
    }
}
