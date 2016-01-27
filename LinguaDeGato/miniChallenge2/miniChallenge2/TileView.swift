//
//  TileView.swift
//  miniChallenge2
//
//  This class is a View that renders and manage the
//  gesture recognition of a Crossword BoardView tile.
//
//  Created by Andre Scherma Soleo on 20/08/15.
//  Copyright (c) 2015 Kobayashi. All rights reserved.
//
//  Subclass of UIView that renders the interactive "letter tiles" of a
//  crossword game

import UIKit
import AVFoundation

//@IBDesignable
class TileView: UIView, UIGestureRecognizerDelegate {

    //MARK: - PROPERTIES
    
    @IBInspectable var letter: Character = "x" {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var delegate: TileViewDelegate! = nil
    
    var gestureRecognizer: UIPanGestureRecognizer! = nil
    var isCorrect: Bool?
    var inCorrectWordsCounter: Int = 0
    
    var correctFeedbackAudioURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("correctSound", ofType: "wav")!)
    
    // plays an audio when tile is put in wrong square
    var wrongFeedbackAudioURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("wrongSound", ofType: "wav")!)
    var wrongFeedbackPlay = AVAudioPlayer()
    var correctFeedbackPlay = AVAudioPlayer()
    
    //MARK: - COLORS AND VISUAL ATTRIBUTES
    
    // General
    let tileBorderWidth = CGFloat(2)
    
    // Default tile
    let tileBackgroundColorDefault = UIColor.whiteColor()
    let tileTextColorDefault = UIColor.bluePalete()
    let tileBorderColorDefault = UIColor.bluePalete()

    // Tile in the right place on the crossword
    let tileBackgroundColorRightLetter = UIColor.whiteColor()
    let tileTextColorRightLetter = UIColor.greenPalete()
    let tileBorderColorRightLetter = UIColor.bluePalete()
    
    // Tile in the wrong place on the crossword
    let tileBackgroundColorWrongLetter = UIColor.whiteColor()
    let tileTextColorColorWrongLetter = UIColor.redColor()
    let tileBorderColorColorWrongLetter = UIColor.bluePalete()
    
    // When finish a right word
    let tileBackgroundColorFinishedWord = UIColor.greenPalete()
    let tileTextColorFinishedWord = UIColor.whiteColor()
    let tileBorderColorFinishedWord = UIColor.greenPalete()
    
    //MARK: - INITIALIZERS
    
    init(frame: CGRect, char: Character, aDelegate: TileViewDelegate) {
        super.init(frame: frame)
        
        self.letter = char
        self.delegate = aDelegate
        
        self.gestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture")
        gestureRecognizer.delegate = self
        gestureRecognizer.maximumNumberOfTouches = 1
        gestureRecognizer.delaysTouchesEnded = true
        
        self.addGestureRecognizer(gestureRecognizer)
        
        //ta aqui de gambiarra! resolve a treta direito, caraio!
        self.backgroundColor = tileBackgroundColorDefault

    }
    
    //whats the use? be visible on story board?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - TILE DESIGN
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    //MARK: TODO: Style the Tile
    
    override func drawRect(rect: CGRect) {
        
        let text = "\(letter)"
        
        let textStyle : NSMutableParagraphStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = .Center
        textStyle.lineBreakMode = .ByClipping
        
        //centralizes the letter in tile
        let fontSize: CGFloat = frame.width / 1.2
        
        self.layer.borderWidth = tileBorderWidth
        
        var textFontAttributes: [String: AnyObject]
        
        //tile not placed in any square
        if isCorrect == nil {
            textFontAttributes = [
                NSFontAttributeName: UIFont.boldSystemFontOfSize(fontSize),
                NSForegroundColorAttributeName: tileTextColorDefault,
                NSBaselineOffsetAttributeName: 0,
                NSParagraphStyleAttributeName: textStyle
            ]
        }
            
        //tile placed in a square
        else {
            //if it's correct
            if isCorrect! {
                if inCorrectWordsCounter == 0 {
                    textFontAttributes = [
                        NSFontAttributeName: UIFont.boldSystemFontOfSize(fontSize),
                        NSForegroundColorAttributeName: tileTextColorRightLetter,
                        NSBaselineOffsetAttributeName: 0,
                        NSParagraphStyleAttributeName: textStyle
                    ]
                }
                //if the whole word is correct
                else {
                    textFontAttributes = [
                        NSFontAttributeName: UIFont.boldSystemFontOfSize(fontSize),
                        NSForegroundColorAttributeName: tileTextColorFinishedWord,
                        NSBaselineOffsetAttributeName: 0,
                        NSParagraphStyleAttributeName: textStyle
                    ]
                }
            }
            //if tile is placed in the wrong square
            else {
                textFontAttributes = [
                    NSFontAttributeName: UIFont.boldSystemFontOfSize(fontSize),
                    NSForegroundColorAttributeName: tileTextColorColorWrongLetter,
                    NSBaselineOffsetAttributeName: 0,
                    NSParagraphStyleAttributeName: textStyle
                ]
            }
        }
        text.drawInRect(self.bounds, withAttributes: textFontAttributes)
    }
    
    
    private func prepareToRedraw(){
        
        //tile not placed in any square
        if isCorrect == nil {
            self.layer.borderColor = tileBorderColorDefault.CGColor
            self.backgroundColor = tileBackgroundColorDefault
        }
            
        //tile placed in a square
        else {
            
            //if it's correct
            if isCorrect! {
                if inCorrectWordsCounter == 0 {
                    self.layer.borderColor = tileBorderColorRightLetter.CGColor
                    self.backgroundColor = tileBackgroundColorRightLetter
                }
                
                //if the whole word is correct
                else {
                    self.layer.borderColor = tileBorderColorFinishedWord.CGColor
                    self.backgroundColor = tileBackgroundColorFinishedWord
                }
            }
                
            //if tile is placed in the wrong square
            else {
                self.layer.borderColor = tileBorderColorColorWrongLetter.CGColor
                self.backgroundColor = tileBackgroundColorWrongLetter
            }
        }
        setNeedsDisplay()
    }
    
    //MARK: -  FEEDBACKS
    func FeedbackIfIsCorrect() {
        isCorrect = true
        
        do {
            try correctFeedbackPlay = AVAudioPlayer(contentsOfURL: correctFeedbackAudioURL)
        }
        catch _ {
            // Error handling
        }
        
        if !MusicSingleton.sharedMusic().isAudioMute {
            correctFeedbackPlay.volume = 1.0
            correctFeedbackPlay.play()
        }

        
        //setNeedsDisplay is needed since tile can change from
        //FeedbackIfWordIsCorrect to visualFeedbackIfIsCorrect
        setNeedsDisplay()
    }

    func FeedbackIfIsWrong() {
        isCorrect = false
        inCorrectWordsCounter = 0

        do {
            try wrongFeedbackPlay = AVAudioPlayer(contentsOfURL: wrongFeedbackAudioURL)
        }
        catch _ {
            // Error handling
        }
        
        if !MusicSingleton.sharedMusic().isAudioMute {
            wrongFeedbackPlay.volume = 0.5
            wrongFeedbackPlay.play()
        }

        prepareToRedraw()
    }
    
    func visualFeedbackIfIsNormal() {
        isCorrect = nil
        inCorrectWordsCounter = 0
        prepareToRedraw()
    }
    
    func visualFeedbackIfWordIsCorrect(){
        inCorrectWordsCounter++
        prepareToRedraw()
    }
    
    func decreaseCorrectWordCounter() {
        inCorrectWordsCounter--
        prepareToRedraw()
    }
    
    //MARK: - GESTURE RECOGNIZER
    
    func handlePanGesture(){
        delegate.tileMoved(self)
        if(self.gestureRecognizer.state == UIGestureRecognizerState.Ended){
            delegate.tileReleased(self)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        delegate.tileGrabed(self)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        delegate.tileReleased(self)
    }
}

//MARK: - TILE VIEW DELEGATE PROTOCOL

protocol TileViewDelegate {
    
    func tileGrabed(tile: TileView)
    
    func tileMoved(tile: TileView)
    
    func tileReleased(tile: TileView)
    
}
