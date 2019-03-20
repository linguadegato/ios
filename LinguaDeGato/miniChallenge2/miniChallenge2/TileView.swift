//
//  TileView.swift
//  LinguaDeGato
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
    #warning ("Make it @IBInspectable")
    var letter: Character = "x" {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    #warning ("Make it @IBInspectable")
    var delegate: TileViewDelegate! = nil
    
    var gestureRecognizer: UIPanGestureRecognizer! = nil
    var isCorrect: Bool?
    var inCorrectWordsCounter: Int = 0
    
    var correctFeedbackAudioURL = URL(fileURLWithPath: Bundle.main.path(forResource: "correctSound", ofType: "wav")!)
    
    // plays an audio when tile is put in wrong square
    var wrongFeedbackAudioURL = URL(fileURLWithPath: Bundle.main.path(forResource: "wrongSound", ofType: "wav")!)
    var wrongFeedbackPlay = AVAudioPlayer()
    var correctFeedbackPlay = AVAudioPlayer()
    
    //MARK: - COLORS AND VISUAL ATTRIBUTES
    
    // General
    let tileBorderWidth = CGFloat(2)
    
    // Default tile
    let tileBackgroundColorDefault = UIColor.white
    let tileTextColorDefault = UIColor.bluePalete()
    let tileBorderColorDefault = UIColor.bluePalete()

    // Tile in the right place on the crossword
    let tileBackgroundColorRightLetter = UIColor.white
    let tileTextColorRightLetter = UIColor.greenPalete()
    let tileBorderColorRightLetter = UIColor.bluePalete()
    
    // Tile in the wrong place on the crossword
    let tileBackgroundColorWrongLetter = UIColor.white
    let tileTextColorColorWrongLetter = UIColor.red
    let tileBorderColorColorWrongLetter = UIColor.bluePalete()
    
    // When finish a right word
    let tileBackgroundColorFinishedWord = UIColor.greenPalete()
    let tileTextColorFinishedWord = UIColor.white
    let tileBorderColorFinishedWord = UIColor.greenPalete()
    
    //MARK: - INITIALIZERS
    
    init(frame: CGRect, char: Character, aDelegate: TileViewDelegate) {
        super.init(frame: frame)
        
        self.letter = char
        self.delegate = aDelegate
        
        self.gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(TileView.handlePanGesture))
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
    
    override func draw(_ rect: CGRect) {
        
        let text = "\(letter)"
        
        let textStyle : NSMutableParagraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = .center
        textStyle.lineBreakMode = .byClipping
        
        //centralizes the letter in tile
        let fontSize: CGFloat = frame.width / 1.2
        
        self.layer.borderWidth = tileBorderWidth
        
        var textFontAttributes: [String: AnyObject]
        
        //tile not placed in any square
        if isCorrect == nil {
            textFontAttributes = [
                convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.boldSystemFont(ofSize: fontSize),
                convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): tileTextColorDefault,
                convertFromNSAttributedStringKey(NSAttributedString.Key.baselineOffset): 0 as AnyObject,
                convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): textStyle
            ]
        }
            
        //tile placed in a square
        else {
            //if it's correct
            if isCorrect! {
                if inCorrectWordsCounter == 0 {
                    textFontAttributes = [
                        convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.boldSystemFont(ofSize: fontSize),
                        convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): tileTextColorRightLetter,
                        convertFromNSAttributedStringKey(NSAttributedString.Key.baselineOffset): 0 as AnyObject,
                        convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): textStyle
                    ]
                }
                //if the whole word is correct
                else {
                    textFontAttributes = [
                        convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.boldSystemFont(ofSize: fontSize),
                        convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): tileTextColorFinishedWord,
                        convertFromNSAttributedStringKey(NSAttributedString.Key.baselineOffset): 0 as AnyObject,
                        convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): textStyle
                    ]
                }
            }
            //if tile is placed in the wrong square
            else {
                textFontAttributes = [
                    convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.boldSystemFont(ofSize: fontSize),
                    convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): tileTextColorColorWrongLetter,
                    convertFromNSAttributedStringKey(NSAttributedString.Key.baselineOffset): 0 as AnyObject,
                    convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): textStyle
                ]
            }
        }
        text.draw(in: self.bounds, withAttributes: convertToOptionalNSAttributedStringKeyDictionary(textFontAttributes))
    }
    
    
    fileprivate func prepareToRedraw(){
        
        //tile not placed in any square
        if isCorrect == nil {
            self.layer.borderColor = tileBorderColorDefault.cgColor
            self.backgroundColor = tileBackgroundColorDefault
        }
            
        //tile placed in a square
        else {
            
            //if it's correct
            if isCorrect! {
                if inCorrectWordsCounter == 0 {
                    self.layer.borderColor = tileBorderColorRightLetter.cgColor
                    self.backgroundColor = tileBackgroundColorRightLetter
                }
                
                //if the whole word is correct
                else {
                    self.layer.borderColor = tileBorderColorFinishedWord.cgColor
                    self.backgroundColor = tileBackgroundColorFinishedWord
                }
            }
                
            //if tile is placed in the wrong square
            else {
                self.layer.borderColor = tileBorderColorColorWrongLetter.cgColor
                self.backgroundColor = tileBackgroundColorWrongLetter
            }
        }
        setNeedsDisplay()
    }
    
    //MARK: -  FEEDBACKS
    func FeedbackIfIsCorrect() {
        isCorrect = true
        
        do {
            try correctFeedbackPlay = AVAudioPlayer(contentsOf: correctFeedbackAudioURL)
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
            try wrongFeedbackPlay = AVAudioPlayer(contentsOf: wrongFeedbackAudioURL)
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
        inCorrectWordsCounter += 1
        prepareToRedraw()
    }
    
    func decreaseCorrectWordCounter() {
        inCorrectWordsCounter -= 1
        prepareToRedraw()
    }
    
    //MARK: - GESTURE RECOGNIZER
    
    @objc func handlePanGesture(){
        delegate.tileMoved(self)
        if(self.gestureRecognizer.state == UIGestureRecognizer.State.ended){
            delegate.tileReleased(self)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate.tileGrabed(self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate.tileReleased(self)
    }
}

//MARK: - TILE VIEW DELEGATE PROTOCOL

protocol TileViewDelegate {
    
    func tileGrabed(_ tile: TileView)
    
    func tileMoved(_ tile: TileView)
    
    func tileReleased(_ tile: TileView)
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
