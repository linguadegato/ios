//
//  AudioFilesManager.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 04/02/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//
//  This class manages recording and retrieving of clue's audio files.

import Foundation
import AVKit

class AudioFilesManager {
    
    static let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]

    static func pathForAudioWithFileName (fileName: String) -> String {
        
        return "\(paths)/\(fileName).m4a"
    }
    
    static func URLForAudioWithFileName (fileName: String) -> NSURL {
        
        return NSURL(fileURLWithPath: pathForAudioWithFileName(fileName))
    }

    static func saveAudioDataWithFileName(data: NSData, fileName: String) {
        
        data.writeToURL(URLForAudioWithFileName(fileName), atomically: true)
    }
    
    static func audioDataWithFileName(fileName: String) -> NSData? {
        
        return NSData(contentsOfURL: URLForAudioWithFileName(fileName))
    }
}