//
//  AudioCluePlayer.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 10/02/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation
import AVFoundation

class AudioCluePlayer {
    
    private static var audio: AVAudioPlayer?
    
    class func playAudio(anAudio: AVAudioPlayer) {
        var audioPlayerTimer = NSTimer()
        
        MusicSingleton.sharedMusic().playBackgroundAudio(false)
        do {
            //try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audio = anAudio
            audio!.play()
            audioPlayerTimer = NSTimer.scheduledTimerWithTimeInterval(audio!.duration, target: AudioCluePlayer, selector: "stopAudio", userInfo: nil, repeats: false)
            
        } catch {
            //MARK: TODO: [audio] error message
        }
    }
    
    class func stopAudio() {
        
        if audio != nil {
            audio!.stop()
            audio!.currentTime = 0
            
            do {
                //try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
                try AVAudioSession.sharedInstance().setActive(false)

            }
            catch {
                //error handling
            }
            
            if !MusicSingleton.sharedMusic().isMusicMute {
                MusicSingleton.sharedMusic().playBackgroundAudio(true)
            }
        }
    }
    
    
}