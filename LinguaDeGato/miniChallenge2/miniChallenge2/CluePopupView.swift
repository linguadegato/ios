//
//  CluePopupView.swift
//  miniChallenge2
//
//  This class is a View that renders and manage the gesture 
//  recognition and medias of a Crossword BoardView Popup clue
//
//  Created by Andre Scherma Soleo on 16/10/15.
//  Copyright © 2015 Kobayashi. All rights reserved.
//
//  Subclass of UIView that renders a popup showing a large scale visualization
//  of a visual clue in a crossword game.


import UIKit
import AVFoundation

class CluePopupView: UIView {
    
    
    //MARK: - PROPERTIES
    //MARK: Clue Data
    var image: UIImage?
    var audio: AVAudioPlayer?
    
    //MARK: Visual Elements
    var imageView: UIImageView!
    var frameView: UIView!
    
    //MARK: Buttons
    var closeButton: UIButton!
    var replayButton: UIButton!

    //MARK: Colors
    let popupFrameColor = UIColor.greenWaterPalete()
    
    //MARK: Images
    let closeButtonImage = UIImage(named: "btnDelete")
    let replayButtonImage = UIImage(named: "IconPlayAudioWhiteGreen")
    
    //MARK: - INITIALIZERS
    init(frame: CGRect, aImage: UIImage?, anAudio: AVAudioPlayer?){
        super.init(frame: frame)
        
        //set properties
        image = aImage
        audio = anAudio
        
        //set view
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3) // value that was used before the clue have animation: alpha 0.0
        self.layer.zPosition = 5

        //set image "frame"
        
        let frameViewRect = CGRect(x: 0, y: 0, width: self.frame.height * 0.6,
            height: self.frame.height * 0.6)
        
        frameView = UIView(frame: frameViewRect)
        frameView.backgroundColor = popupFrameColor
        //centralize frameView in CluePopupView
        frameView.center = CGPoint(x: self.frame.size.width / 2 , y: self.frame.size.height / 2)
        frameView.layer.cornerRadius = frameView.frame.width / 20
        
        self.addSubview(frameView)
        
        //set image view
        let imageViewRect = CGRect(x: 0, y: 0, width: frameView.frame.height * 0.9,
                height: frameView.frame.height * 0.9) 
        
        imageView = UIImageView(frame: imageViewRect)
        imageView.image = self.image
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        frameView.addSubview(imageView)
        
        //Centralize imageView in frameView
        imageView.center = frameView.convert(frameView.center, from: frameView.superview!)
        
        //set gesture recognizer
        let aGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CluePopupView.tapped(_:)))
        self.addGestureRecognizer(aGestureRecognizer)
        
        //add closeButton
        let closeButtonSize = CGSize(width: frameViewRect.height / 10, height: frameViewRect.height / 10)
        let closeButtonOriginX = frameView.frame.size.width - (closeButtonSize.width * 0.6)
        let closeButtonOriginY = -(closeButtonSize.height * 0.4)
        let closeButtonOrigin = CGPoint(x: closeButtonOriginX, y: closeButtonOriginY)
        let closeButtonRect = CGRect(origin: closeButtonOrigin, size: closeButtonSize)
        
        closeButton = UIButton(frame: closeButtonRect)
        frameView.addSubview(closeButton)
        
        //set closeButton appearance
        closeButton.setImage(closeButtonImage, for: UIControl.State())
        closeButton.layer.cornerRadius = closeButton.bounds.height / 2
        
        //set closeButton Action
        closeButton.addTarget(self, action: #selector(UIView.removeFromSuperview), for: .touchUpInside)

        if audio != nil {
            //add replayButton
            let replayButtonSize = CGSize(width: frameViewRect.height / 8, height: frameViewRect.height / 8)
            let replayButtonOriginX = frameView.frame.size.width - (replayButtonSize.width * 1)
            let replayButtonOriginY = frameView.frame.size.height - (replayButtonSize.height * 1)
            let replayButtonOrigin = CGPoint(x: replayButtonOriginX, y: replayButtonOriginY)
            let replayButtonRect = CGRect(origin: replayButtonOrigin, size: replayButtonSize)
            
            replayButton = UIButton(frame: replayButtonRect)
            frameView.addSubview(replayButton)
            
            //set replayButton appearance
            replayButton.setImage(replayButtonImage, for: UIControl.State())
            replayButton.layer.cornerRadius = replayButton.bounds.height / 2
            
            replayButton.addTarget(self, action: #selector(CluePopupView.playAudio), for: .touchUpInside)
            
            //play audio
            self.playAudio()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    //MARK: - Button actions
    
    func closePopup() {
        AudioCluePlayer.stopAudio()
        self.removeFromSuperview()
    }
    
    //MARK: - Gesture Handler
    @objc func tapped(_ sender: UITapGestureRecognizer){
        
        if imageView.point(inside: sender.location(ofTouch: 0, in: frameView), with: nil) {
            self.playAudio()
        }
        else {
            self.closePopup()
        }
    }
    
    //MARK: - Audio control
    @objc func playAudio() {
        
        if self.audio != nil {
            AudioCluePlayer.playAudio(audio!)
        }
    }
}
