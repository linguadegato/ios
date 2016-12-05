//
//  GalleryAndGamesViewController.swift
//  LinguaDeGato
//
//  Created by Kobayashi on 1/21/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation
import UIKit

class GalleryAndGamesViewController: UIViewController {
    
//    private var allGames = [Game]()
//    private var gallery = [WordAndClue]()
    fileprivate var backButton : UIBarButtonItem!
    fileprivate let muteMusicOnImage = UIImage(named: "btnMuteMusicOnLightBlue")
    fileprivate let muteMusicOffImage = UIImage(named: "btnMuteMusicOffLightBlue")
    
    @IBOutlet weak var muteMusicButton: UIButton!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var gamesView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    

    override func viewWillAppear(_ animated: Bool) {
        self.indexChanged(self.segmentedControl)
        
        //Set image of mute button
        if MusicSingleton.sharedMusic().isMusicMute {
            muteMusicButton.setImage(muteMusicOnImage, for: UIControlState())
        } else {
            muteMusicButton.setImage(muteMusicOffImage, for: UIControlState())
        }
    }
    
    // MARK: - Button Actions
    @IBAction func muteMusicButton(_ sender: AnyObject) {
        if MusicSingleton.sharedMusic().isMusicMute {
            // music will play
            muteMusicButton.setImage(muteMusicOffImage, for: UIControlState())
            MusicSingleton.sharedMusic().isMusicMute = false
            MusicSingleton.sharedMusic().playBackgroundAudio(true)
        } else {
            // music will stop
            muteMusicButton.setImage(muteMusicOnImage, for: UIControlState())
            MusicSingleton.sharedMusic().isMusicMute = true
            MusicSingleton.sharedMusic().playBackgroundAudio(false)
        }
    }
    
    @IBAction func goBack(_ sender: AnyObject) {
        let _ = self.navigationController?.popViewController(animated: true)
        
        // Don't forget to re-enable the interactive gesture
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = true
        
        // if the back button is pressed when a clue audio is recording or playing, the music status is stoped
        // so we need to play when exit to another screen
        if !MusicSingleton.sharedMusic().isMusicMute {
            MusicSingleton.sharedMusic().playBackgroundAudio(true)
        }
    }

    // MARK: - Segmented Control action
    @IBAction func indexChanged(_ sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            UIView.animate(withDuration: 0.5, animations: {
                self.galleryView.alpha = 1
                self.gamesView.alpha = 0
            })
        case 1:
            UIView.animate(withDuration: 0.5, animations: {
                self.galleryView.alpha = 0
                self.gamesView.alpha = 1
            })
        default:
            break; 
        }
    }
    
}
