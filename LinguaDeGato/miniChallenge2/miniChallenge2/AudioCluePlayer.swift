//
//  AudioCluePlayer.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 10/02/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//
//  This class centralizes the processes of play recorded (clues) audios,
//  allowing not shatter audio session configuration code througt project.


import Foundation
import AVFoundation

class AudioCluePlayer {
    
    fileprivate static var instance = AudioCluePlayer()
    
    fileprivate static var audio: AVAudioPlayer?
    
    fileprivate init(){
        
    }
    
    class func sharedPlayer() -> AudioCluePlayer {
        
        return instance
    }
    
    class func playAudio(_ anAudio: AVAudioPlayer) {
        
        var audioPlayerTimer: Timer
        
        MusicSingleton.sharedMusic().playBackgroundAudio(false)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            //try AVAudioSession.sharedInstance().setActive(true)
            
            audio = anAudio
            audio!.play()
            audioPlayerTimer = Timer.scheduledTimer(timeInterval: audio!.duration, target: AudioCluePlayer.sharedPlayer(), selector: #selector(AudioCluePlayer.stopAudioAfterTimer(_:)), userInfo: nil, repeats: false)
            
        } catch {
            //MARK: TODO: [audio] error message
        }
    }
    
    class func stopAudio() {
        
        if audio != nil {
            audio!.stop()
            audio!.currentTime = 0
            audio = nil
            
            do {
                try AVAudioSession.sharedInstance().setActive(false, with: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation)
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, with: .mixWithOthers)
                try AVAudioSession.sharedInstance().setActive(true)
            }
            catch {
                //error handling
            }
            

            if !MusicSingleton.sharedMusic().isMusicMute {
                MusicSingleton.sharedMusic().playBackgroundAudio(true)
            }
        }
    }
    
    //A little macGayverism, so timer can call stopAudio
    @objc func stopAudioAfterTimer(_ timer: Timer) {
        
        AudioCluePlayer.stopAudio()
    }
}
