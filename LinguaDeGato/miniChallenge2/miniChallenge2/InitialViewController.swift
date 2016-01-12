//
//  InitialViewController.swift
//  miniChallenge2
//
//  Created by Kobayashi on 6/22/15.
//  Copyright (c) 2015 Kobayashi. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

class InitialViewController: StatusBarViewController {
    
    @IBOutlet weak var createCrosswordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!

    var backgroundMusic = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("backgroundMusic", ofType: "wav")!)
    var backgroundMusicPlay = AVAudioPlayer()
    
    //play the background audio
    func playBackgroundAudio(playAudio: Bool) {
        
        do {
            try backgroundMusicPlay = AVAudioPlayer(contentsOfURL: backgroundMusic)
        }
        catch _ {
            // Error handling
        }
        
        
        backgroundMusicPlay.volume = 0.2
        backgroundMusicPlay.numberOfLoops = (-1) // always repeat music

        if playAudio{
            backgroundMusicPlay.play()
        } else {
            backgroundMusicPlay.stop()
        }
   
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        playBackgroundAudio(true)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dis pose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
