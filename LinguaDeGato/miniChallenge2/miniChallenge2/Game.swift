//
//  Game.swift
//  LinguaDeGato
//
//  Created by Kobayashi on 1/15/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation

class Game {
    
    var name: String
    var wordsAndClueArray: [WordAndClue]
    
    init(gameName: String, wordsAndClue: [WordAndClue]){
        name = gameName
        wordsAndClueArray = wordsAndClue
    }
}