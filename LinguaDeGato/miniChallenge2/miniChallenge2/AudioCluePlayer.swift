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
    
    private static var instance = AudioCluePlayer()
    
    private static var audio: AVAudioPlayer?
    
    private init(){
        
    }
    
    class func sharedPlayer() -> AudioCluePlayer {
        
        return instance
    }
    
    class func playAudio(anAudio: AVAudioPlayer) {
        
        var audioPlayerTimer: NSTimer
        
        MusicSingleton.sharedMusic().playBackgroundAudio(false)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            //try AVAudioSession.sharedInstance().setActive(true)
            
            audio = anAudio
            audio!.play()
            audioPlayerTimer = NSTimer.scheduledTimerWithTimeInterval(audio!.duration, target: AudioCluePlayer.sharedPlayer(), selector: "stopAudioAfterTimer:", userInfo: nil, repeats: false)
            
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
                try AVAudioSession.sharedInstance().setActive(false, withOptions: AVAudioSessionSetActiveOptions.NotifyOthersOnDeactivation)
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, withOptions: .MixWithOthers)
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
    @objc func stopAudioAfterTimer(timer: NSTimer) {
        
        AudioCluePlayer.stopAudio()
    }
}