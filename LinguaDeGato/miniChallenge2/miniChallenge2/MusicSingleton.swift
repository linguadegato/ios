//
//  MusicSingleton.swift
//  LinguaDeGato
//
//  Created by Jheniffer Jordao Leonardi on 1/13/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import UIKit
import AVFoundation

class MusicSingleton: NSObject {
    
    var backgroundMusic = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("backgroundMusic", ofType: "wav")!)
    var backgroundMusicPlay:AVAudioPlayer!
    var isMute: Bool = false

    private static var instance:MusicSingleton = MusicSingleton()
    
    internal  static func  sharedMusic() -> MusicSingleton {
        return instance
    }

    private override init() {
        super.init()
        
        do {
            try backgroundMusicPlay = AVAudioPlayer(contentsOfURL: backgroundMusic)
        }
        catch _ {
            // Error handling
        }
        
    }
    
    //plays the background music
    func playBackgroundAudio(playAudio: Bool) {
        
        backgroundMusicPlay.volume = 0.2
        backgroundMusicPlay.numberOfLoops = (-1) // always repeat music
        
        if playAudio{
            backgroundMusicPlay.play()
        } else {
            backgroundMusicPlay.stop()
        }
        
    }
}
