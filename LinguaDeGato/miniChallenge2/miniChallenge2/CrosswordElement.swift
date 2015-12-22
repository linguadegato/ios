//
//  CrosswordElement.swift
//  miniChallenge2
//
//  This (for now, maybe forever, empty) class encapsulates the
//  the objects used by a BoardViewDatasource to generate a
//  matrix with the crossword elements
//
//  Created by Andre Scherma Soleo on 13/10/15.
//  Copyright © 2015 Kobayashi. All rights reserved.
//
//  Abstract class that represents either a character or a clue in a matrix that
//  represents a crossword game.


import UIKit

//MARK TODO: Implement an "abstract class" mechanism
//NOW IT SHOULD BE A PROTOCOL (or just implement a CrosswordViewsGenerator protocol)
class CrosswordElement {

    
    func generateSquareView (squareSize: CGSize, elementCoordX: Int, elementCoordY: Int, board: BoardView) -> BoardCellView? {
        return nil
    }
}
