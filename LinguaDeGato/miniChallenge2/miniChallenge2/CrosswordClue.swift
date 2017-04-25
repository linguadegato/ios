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

//MARK: Is UIImage the best type to use?
class CrosswordClue: CrosswordElement {
    
    //it should really be optinal, since other types of clue will be implemented
    //and not all clue will have all kinds of media as clue.
    var imageID: String?
    var audioPath: String?
    
    //data to generate a 3x3 "squares" ClueView at right position
    //var offsetToLeft: Bool!
    var isVertical: Bool!
    
    /*
    init(anImage: UIImage, anAudio: AVAudioPlayer){
        self.imageID = anImage
        self.audio = anAudio
    }
    */
    
    init(anImageID: String?, anAudioPath: String?) {
        self.imageID = anImageID
        self.audioPath = anAudioPath
    }
    
    //create a 3x3 (in "squares") clue view, adjusting the rect with its offset
    func generateSquareView(_ squareSize: CGSize, elementCoordX: Int, elementCoordY: Int, board: BoardView) -> BoardCellView? {
        
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
        let square = ClueView(frame: aRect, vertical: isVertical!, aDelegate: board, anImageID: self.imageID, anAudioPath: self.audioPath)
        
        return square
    }
}
