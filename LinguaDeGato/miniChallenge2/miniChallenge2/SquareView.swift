//
//  SquareView.swift
//  miniChallenge2
//
//  This class is a View that renders and manages
//  a Crossword BoardView Square
//
//  Created by Andre Scherma Soleo on 20/08/15.
//  Copyright (c) 2015 Kobayashi. All rights reserved.
//
//  Subclass of BoardCellView that renders the "receptacles" of letters "tiles"
//  of a crossword game

import UIKit

class SquareView: BoardCellView {
    
    //MARK: - PROPERTIES
    let letter: Character
    var filled: TileView?
    var words: [WordAndClue]
    
    //MARK: - COLORS AND VISUAL ATTRIBUTES
    let squareBackgroundColor = UIColor.whiteColor().CGColor
    let squareBorderColor = UIColor.bluePalete().CGColor
    let squareBorderWidth = CGFloat(2)
    
    
    //MARK: - INITIALIZERS
    
    init(frame: CGRect, char: Character, words: [WordAndClue]) {
        self.letter = char
        self.words = words
        
        super.init(frame: frame)
        
        //MARK: TODO: fix the strange appearance of the borders in the edge
        //they look thinner, since it`s only one border, not two side by side
        self.layer.borderWidth = squareBorderWidth
        self.layer.borderColor = squareBorderColor
        self.layer.backgroundColor = squareBackgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - DESIGN
    
    /*
    //vai precisar?
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
 
    }
    */
    
    //MARK: - TOUCHING MANAGEMENT
    //prevent square of being hitting instead of a tile
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return false
    }
}
