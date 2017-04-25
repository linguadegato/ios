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
    
    static let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

    static func pathForAudioWithFileName (_ fileName: String) -> String {
        
        return "\(paths)/\(fileName).m4a"
    }
    
    static func URLForAudioWithFileName (_ fileName: String) -> URL {
        
        return URL(fileURLWithPath: pathForAudioWithFileName(fileName))
    }

    static func saveAudioDataWithFileName(_ data: Data, fileName: String) {
        
        try? data.write(to: URLForAudioWithFileName(fileName), options: [.atomic])
    }
    
    static func audioDataWithFileName(_ fileName: String) -> Data? {
        
        return (try? Data(contentsOf: URLForAudioWithFileName(fileName)))
    }
}
