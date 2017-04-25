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
    
    var backgroundMusic = URL(fileURLWithPath: Bundle.main.path(forResource: "backgroundMusic", ofType: "wav")!)
    var backgroundMusicPlay:AVAudioPlayer!
    var isMusicMute: Bool = false
    var isAudioMute: Bool = false
    
    fileprivate static var instance: MusicSingleton = MusicSingleton()
    
    internal static func sharedMusic() -> MusicSingleton {
        return instance
    }

    fileprivate override init() {
        super.init()
        
        do {
            try backgroundMusicPlay = AVAudioPlayer(contentsOf: backgroundMusic)
        }
        catch _ {
            // Error handling
        }
    }
    
    //plays the background music
    func playBackgroundAudio(_ playAudio: Bool) {
        
        backgroundMusicPlay.volume = 0.2
        backgroundMusicPlay.numberOfLoops = (-1) // always repeat music
        
        if playAudio{
            backgroundMusicPlay.play()
        } else {
            backgroundMusicPlay.stop()
        }
    }
}
