//
//  InitialViewController.swift
//  miniChallenge2
//
//  Created by Kobayashi on 6/22/15.
//  Copyright (c) 2015 Kobayashi. All rights reserved.
//

import UIKit
import MobileCoreServices


class InitialViewController: StatusBarViewController {
    
    @IBOutlet weak var createCrosswordButton: UIButton!
    @IBOutlet weak var playRandomGameButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    
    private let muteOnImage = UIImage(named: "btnMuteOnLightBlue")
    private let muteOffImage = UIImage(named: "btnMuteOffLightBlue")
    
    // MARK - BUTTON ACTIONS
    // "mute" button
    @IBAction func muteMusic(sender: AnyObject) {
        if MusicSingleton.sharedMusic().isMute {
            // music will play
            muteButton.setImage(muteOffImage, forState: .Normal)
            MusicSingleton.sharedMusic().isMute = false
            MusicSingleton.sharedMusic().playBackgroundAudio(true)
        } else {
            // music will stop
            muteButton.setImage(muteOnImage, forState: .Normal)
            MusicSingleton.sharedMusic().isMute = true
            MusicSingleton.sharedMusic().playBackgroundAudio(false)

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //starts the background music
        MusicSingleton.sharedMusic().playBackgroundAudio(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        //set image of mute button
        if MusicSingleton.sharedMusic().isMute {
            muteButton.setImage(muteOnImage, forState: .Normal)
        } else {
            muteButton.setImage(muteOffImage, forState: .Normal)
        }
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
