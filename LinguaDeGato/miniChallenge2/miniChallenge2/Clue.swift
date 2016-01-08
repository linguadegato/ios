//
//  Clue.swift
//  miniChallenge2
//
//  Created by Andre Scherma Soleo on 23/10/15.
//  Copyright © 2015 Kobayashi. All rights reserved.
//
//  Represents a multimedia clue for a word in a crosswords game.

import Foundation
import UIKit

class Clue {
    
    var imageID: String?
    var audioPath: String?
    
    var imageURL:NSURL?
    
    init(aImageID: String?, anAudioPath: String?){
        imageID = aImageID
        audioPath = anAudioPath
    }
}