//
//  ClueView.swift
//  miniChallenge2
//
//  This class is a View that renders and manage the gesture
//  recognition and medias of a Crossword BoardView clue
//
//  Created by Andre Scherma Soleo on 13/10/15.
//  Copyright © 2015 Kobayashi. All rights reserved.
//
//  Subclass of BoardCellView that renders the multimedia clues of crossword
//  game

import UIKit
import AVFoundation
import Photos

class ClueView: BoardCellView, UIGestureRecognizerDelegate {
    
    //MARK: - PROPERITIES
    //MARK: TODO: - Implement Inspectable and Designable
    
    //MARK: clue data and metadata
    var image: UIImage?
    var audio: AVAudioPlayer?
    var isVertical: Bool
    var delegate: ClueViewDelegate!
    
    //MARK: View
    //var arrowView: UIImageView!
    
    // MARK: visual properties
    let imageViewBackgroundColor = UIColor.whiteColor()
    let imageViewContentMode = UIViewContentMode.ScaleAspectFit
    let imageViewBorderColor = UIColor.greenWaterPalete()
    let imageViewBorderSize: CGFloat = 1.0
    
    static let downArrowImage = UIImage(named:"arrowDownOrange")
    static let rightArrowImage = UIImage(named:"arrowRightOrange")
    static let audioIconImage = UIImage(named: "IconPlayAudioGreenTransparent")
    
    static let defaultImage = UIImage(named: "imageDefaultAudio")
    
    
    //MARK: - INITIALIZERS
    
    init(frame: CGRect, vertical: Bool, aDelegate: BoardView, anImageID: String?, anAudioPath: String?) {
       
        self.isVertical = vertical
        
        super.init(frame: frame)
        
        //set image
        if anImageID != nil {
            
            let results = PHAsset.fetchAssetsWithLocalIdentifiers([anImageID!], options: nil)
            
            if results.firstObject != nil {

                PHImageManager.defaultManager().requestImageForAsset(results.firstObject as! PHAsset, targetSize: CGSize(width: 1024,height: 1024), contentMode: .AspectFit, options: nil, resultHandler: { (aImage, _) -> Void in
                    
                    self.image = aImage
                })
            }
        }
        else {
            self.image = ClueView.defaultImage
        }
        
        //set audio
        if anAudioPath != nil {
            do{
                try self.audio = AVAudioPlayer(contentsOfURL: AudioFilesManager.URLForAudioWithFileName(anAudioPath!))
                //try self.audio = AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(LGStandarts.pathForAudioWithFileName(anAudioPath!)))
            } catch{
                print("Doent have a sound")
            }
        }
        
        self.delegate = aDelegate
        
        self.backgroundColor = nil
        
        //set and add imageView
        let imageViewSize = CGSize(width: self.frame.width * 5/6, height: self.frame.height * 5/6)
        var imageViewOrigin: CGPoint
        
        if self.isVertical {
            imageViewOrigin = CGPoint (x: self.frame.width / 12, y: 0)
        }
        else{
            imageViewOrigin = CGPoint (x: 0, y: self.frame.width / 12)
        }
        
        let imageViewRect = CGRect(origin: imageViewOrigin, size: imageViewSize)
        let imageView = UIImageView(frame: imageViewRect)
        
        imageView.layer.backgroundColor = imageViewBackgroundColor.CGColor
        imageView.contentMode = imageViewContentMode
        imageView.layer.borderColor = imageViewBorderColor.CGColor
        imageView.layer.borderWidth = imageViewBorderSize
        imageView.image = self.image
        
        //set and add gesture recognizer
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ClueView.handleTapGesture))
        gestureRecognizer.delegate = self
        gestureRecognizer.delaysTouchesEnded = true
        
        self.addGestureRecognizer(gestureRecognizer)
        self.addSubview(imageView)
        
        //add arrow image
        var arrowViewRect: CGRect
        var arrowImage: UIImage
        
        if vertical {
            let originY = imageViewRect.height
            let height = self.frame.height - imageView.frame.height
            let width = height
            let originX = (self.frame.width - width) / 2
            
            arrowViewRect = CGRect(x: originX, y: originY, width: width, height: height)
            arrowImage = ClueView.downArrowImage!
        }
        else {
            let originX = imageViewRect.width
            let width = self.frame.width - imageViewRect.width
            let height = width
            let originY = (self.frame.height - height) / 2

            arrowViewRect = CGRect(x: originX, y: originY, width: width, height: height)
            arrowImage = ClueView.rightArrowImage!
        }
        
        let arrowView = UIImageView(frame: arrowViewRect)
        arrowView.image = arrowImage
        self.addSubview(arrowView)
        
        //add audio icon (if there's sound)
        if audio != nil {
            let audioIconView = UIImageView(image: ClueView.audioIconImage)
            audioIconView.frame.size = arrowView.frame.size
            
            if vertical {
                audioIconView.frame.origin.y = arrowView.frame.origin.y
                audioIconView.frame.origin.x = arrowView.frame.origin.x + (arrowView.frame.size.width * 1.5)
            }
            else {
                audioIconView.frame.origin.x = arrowView.frame.origin.x
                audioIconView.frame.origin.y = arrowView.frame.origin.y - (arrowView.frame.size.height * 1.5)
            }
            self.addSubview(audioIconView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - GESTURE RECOGNIZER
    func handleTapGesture(){
        delegate.handleClueTapGesture(self)
    }
}


//MARK: - CLUEVIEW DELEGATE PROTOCOL
protocol ClueViewDelegate{
    
    func handleClueTapGesture(aClue: ClueView)
}

