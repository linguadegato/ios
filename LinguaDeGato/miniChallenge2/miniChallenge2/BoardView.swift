//
//  BoardView.swift
//  miniChallenge2
//
//  This class is a UIView that generates a crossword game (empty squares,
//  clues and character tiles) and manages their movement.
//
//  Created by Andre Scherma Soleo on 22/08/15.
//  Copyright (c) 2015 Kobayashi. All rights reserved.
//
//
//  Custom View that embbed and manage all the views that compound a crosswords
//  game and manage their behaviors.

import UIKit

class BoardView: UIView, TileViewDelegate, ClueViewDelegate{
    
    //MARK: - PROPERTIES
    
    //MARK: Data
    @IBInspectable var dataSource: BoardViewDataSource?
    @IBInspectable var delegate: BoardViewDelegate?
    
    var inputMatrix: [[CrosswordElement?]]!
    var crosswordMatrix: [[BoardCellView?]]!
    var wordManagers = [WordManager]()
    var wordsInGame: Int!
    var correctWords = 0 {
        didSet{
            if correctWords == wordsInGame{
                delegate!.gameEnded()
            }
        }
    }
    
    // MARK: measures
    
    var crosswordColNumber: Int!
    var crosswordRowNumber: Int!
    
    let centerBoardProportion: CGFloat = 0.75
    
    // centerBoard / tile vertical proportion
    // must be avaible before BoardView instatiation, then, it's static
    static let maxSquaresInCol = 12
    static let maxSquaresinRow = 18
    
    var tileSize: CGFloat?
    var squareSize: CGFloat?

    
    //MARK: Views
    var centerBoard: UIView! = nil
    
    //MARK: - INITIALIZERS
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    //MARK: - DESIGN
    
    //I don't think it's realy a DRAW, but who cares, if it works well?
    override func drawRect(rect: CGRect) {

        // Drawing code
        
        //get an input matrix
        if (dataSource != nil){
            inputMatrix = dataSource!.getCrossWordMatrix()
            
            let words = dataSource!.getCrossWordWords()
            
            for word in words {
                wordManagers.append(WordManager(aWord: word, aBoard: self))
            }
            
            wordsInGame = wordManagers.count
        }
        
        if (inputMatrix != nil){
            
            //get input matrix dimensions (you can transform it in a private method, for the sake of good code)

            crosswordRowNumber = inputMatrix!.count
            crosswordColNumber = inputMatrix[0].count
            
            determineTileSize()
            determineSquareSize()
            
            //generate center board
            generateCenterBoard()
        
            //generate board's squares
            generateBoardSquares()
            
            //generate tiles
            generateTiles()
        }
    }
    
    //MARK: - GAME GENERATION METHODS
    
    //generate center board
    private func generateCenterBoard() {
        
        
        //centerboards proportions can be modified just changing sizeMultiplier
        
        let aRect = CGRect()
        
        let aCenterBoard = UIView(frame: aRect)
        self.centerBoard = aCenterBoard
        
        self.centerBoard.frame.size.width = CGFloat(crosswordColNumber) * tileSize!
        self.centerBoard.frame.size.height = CGFloat(crosswordRowNumber) * tileSize!
        
        centerBoard.center = superview!.convertPoint(superview!.center, toView: superview!)
        
        self.centerBoard.backgroundColor = nil
        self.centerBoard.layer.zPosition = -1
        self.centerBoard.userInteractionEnabled = false
        //self.centerBoard.layer.borderColor = UIColor.blackColor().CGColor
        //self.centerBoard.layer.borderWidth = 0.5
        
        self.addSubview(centerBoard)
    }

    //generate the board's squares, clues and the crosswordMatrix
    private func generateBoardSquares() {
        
        let squareSize = CGSize(width: tileSize!, height: tileSize!)
        
        if (inputMatrix != nil){
            //to be attributed to crosswordMatrix
            var auxMatrix = [[BoardCellView?]]()
            
            //iterate rows (always exist)
            for rowIdx in 0 ..< crosswordRowNumber {
                var matrixLine = [BoardCellView?]()
                
                //iterate columns
                for colIdx in 0 ..< crosswordColNumber {
                    
                    //just a warranty against ragged arrays, in case of LGCrosswordGenerator has been modified
                    if (colIdx < inputMatrix![rowIdx].count){

                        if let element = inputMatrix![rowIdx][colIdx] {
                            
                            let square = element.generateSquareView(squareSize, elementCoordX: colIdx, elementCoordY: rowIdx, board: self)
                            
                            if (square != nil) {
                                self.addSubview(square!)
                            }
                            
                            matrixLine.append(square)
                        }
                        else {
                            matrixLine.append(nil)
                        }
                    }
                }
                auxMatrix.append(matrixLine)
            }
        crosswordMatrix = auxMatrix
        }
    }
    
    //generate the tiles
    private func generateTiles() {
        if (inputMatrix != nil){
            
            let size = CGSize(width: tileSize!, height: tileSize!)

            for line in inputMatrix! {
                for element in line {
                    if let element = element as? CrosswordChar {
                        
                        //create a random origin for the tile (outside the board
                        let aXcoord = CGFloat(arc4random()) % (self.frame.width - tileSize!)
                        let aYcoord: CGFloat!
                        if (aXcoord < (centerBoard.frame.origin.x - tileSize!) ||
                            aXcoord > centerBoard.frame.origin.x + centerBoard.frame.width){
                                aYcoord = CGFloat(arc4random()) % (self.frame.height - tileSize!)
                        }
                        else{
                            aYcoord = CGFloat(arc4random()) % (centerBoard.frame.origin.y - tileSize!)
                        }
                        
                        //create TileView
                        let origin = CGPoint(x: aXcoord, y: aYcoord)
                        
                        let aRect = CGRect(origin: origin, size: size)
                        let tile = TileView(frame: aRect, char: element.theChar, aDelegate: self)
                        tile.layer.zPosition = 1
                        
                        tile.visualFeedbackIfIsNormal()
                    
                        self.addSubview(tile)
                    }
                }
            }
        }
    }
    
    //MARK:- TODO: GENERATORS AUXILIAR METHODS
    private func determineTileSize(){
        
        let maximumHeight = self.frame.height * centerBoardProportion
        
        tileSize = maximumHeight / CGFloat(BoardView.maxSquaresInCol)
    }
    
    private func determineSquareSize(){
        
        let maximumHeight = self.frame.height * centerBoardProportion
        
        squareSize = maximumHeight / CGFloat(BoardView.maxSquaresInCol)
    }
    
    //MARK: - TILEVIEW DELEGATE
    func tileGrabed(tile: TileView) {
        
        //brings to front
        tile.layer.zPosition = 3
        
        //capture position on crosswordMatrix
        let coordX = Int(floor(tile.center.x - centerBoard.frame.origin.x) / tileSize!) // capture col index
        let coordY = Int(floor(tile.center.y - centerBoard.frame.origin.y) / tileSize!) // capture row index
       
        let cell = getCell(coordY, col: coordX)
        
        if cell is SquareView{
            
            let aSquare = cell as! SquareView
            
            //verify if the tile is on an square
            if tile == aSquare.filled {
                aSquare.filled = nil
                
                //verify if the square was correct filled and update "square's words" counters
                if tile.isCorrect != nil && tile.isCorrect! {
                    for word in aSquare.words {
                        
                        for manager in wordManagers {
                            if manager.word == word {
                                manager.decreaseCounter()
                            }
                        }
                    }
                }
                tile.visualFeedbackIfIsNormal()
            }
        }
    }
    
    func tileMoved(tile: TileView) {
        
        let newPosition = tile.gestureRecognizer.translationInView(tile)
        
        tile.frame.origin.x += newPosition.x
        tile.frame.origin.y += newPosition.y
        
        tile.gestureRecognizer.setTranslation(CGPointZero, inView: tile)
        
        //prevents tile from escape out off Crossword BoardView
        
        //in X axis
        if(tile.frame.origin.x > self.frame.size.width - tile.frame.size.width) {
            tile.frame.origin.x = self.frame.size.width - tile.frame.size.width
        }
        
        if(tile.frame.origin.x < 0) {
            tile.frame.origin.x = 0
        }
        
        //in Y axis
        if(tile.frame.origin.y > self.frame.size.height - tile.frame.size.height) {
            tile.frame.origin.y = self.frame.size.height - tile.frame.size.height
        }
        
        if(tile.frame.origin.y < 0) {
            tile.frame.origin.y = 0
        }
        
        tile.setNeedsDisplay()
    }
    
    func tileReleased(tile: TileView){
        
        //capture position
        let coordX = Int(floor(tile.center.x - centerBoard.frame.origin.x) / tileSize!) // capture col index
        let coordY = Int(floor(tile.center.y - centerBoard.frame.origin.y) / tileSize!) // capture row index
        var isOnSquare = false
        
        //verify if it's over a square
        let cell = getCell(coordY, col: coordX)
        
        if cell is SquareView{
            let aSquare = cell as! SquareView
            
            //if the square is empty, attach tile to square
            if (aSquare.filled == nil) {
                tile.center = aSquare.center
                tile.layer.zPosition = 1
                aSquare.filled = tile
                isOnSquare = true
                
                //if tile is placed in right square
                if tile.letter == aSquare.letter {
                    
                    tile.FeedbackIfIsCorrect()
                    
                    for word in aSquare.words {
                        //upadate word managers counters
                        for manager in wordManagers {
                            if manager.word == word {
                                manager.increaseCounter()
                            }
                        }
                    }
                }
                //if tile is place in wrong square
                else {
                    tile.FeedbackIfIsWrong()
                }
            }
        }
        //sets zPostion if it's out of square
        if (!isOnSquare){
            tile.layer.zPosition = 2
        }
    }
    
    //MARK: - CLUEVIEW DELEGATE
    func handleClueTapGesture(aClue: ClueView) {
        
        let aFrame = self.superview!.frame
        let popup = CluePopupView(frame: aFrame, aImage: aClue.image, anAudio: aClue.audio)
        let animationTime = 0.5
        
        // animate the clue, with the pop-up effect
        UIView.animateWithDuration(NSTimeInterval(animationTime), animations: {
            popup.frameView.transform = CGAffineTransformMakeScale(0.9, 0.9)
            popup.imageView.transform = CGAffineTransformMakeScale(0.9, 0.9)
            
            self.addSubview(popup)
            
            },completion:{completion in
                UIView.animateWithDuration(NSTimeInterval(animationTime), animations: { () -> Void in
                    popup.frameView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    popup.imageView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    
                    self.addSubview(popup)
                    
                })
        })

    }

    //MARK: - AUXILIAR METHODS
    
    func getCell(row: Int, col: Int) -> BoardCellView? {
        if (row >= 0 && row < crosswordMatrix!.count){
            if (col >= 0 && col < crosswordMatrix![row].count){
                let view = crosswordMatrix[row][col]
                return view
            }
        }
        return nil
    }
}


// MARK: - BOARDVIEW DATASOURCE PROTOCOL
protocol BoardViewDataSource {

    func getCrossWordMatrix() -> [[CrosswordElement?]]?
    
    func getCrossWordWords() -> [WordAndClue]
    
}

//MARK: - BOARDVIEW DELEGATE PROTOCOL
protocol BoardViewDelegate {
    
    func gameEnded()
}