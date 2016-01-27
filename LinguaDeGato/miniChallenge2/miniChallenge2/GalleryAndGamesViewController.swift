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
    
    private var allGames = [Game]()
    private var gallery = [WordAndClue]()
    private var backButton : UIBarButtonItem!
    private let muteMusicOnImage = UIImage(named: "btnMuteMusicOnLightBlue")
    private let muteMusicOffImage = UIImage(named: "btnMuteMusicOffLightBlue")
    
    @IBOutlet weak var muteMusicButton: UIButton!

    override func viewWillAppear(animated: Bool) {
        //set image of mute button
        if MusicSingleton.sharedMusic().isMusicMute {
            muteMusicButton.setImage(muteMusicOnImage, forState: .Normal)
        } else {
            muteMusicButton.setImage(muteMusicOffImage, forState: .Normal)
        }
    }
    
    // "mute music" button
    
    
    @IBAction func muteMusicButton(sender: AnyObject) {
        if MusicSingleton.sharedMusic().isMusicMute {
            // music will play
            muteMusicButton.setImage(muteMusicOffImage, forState: .Normal)
            MusicSingleton.sharedMusic().isMusicMute = false
            MusicSingleton.sharedMusic().playBackgroundAudio(true)
        } else {
            // music will stop
            muteMusicButton.setImage(muteMusicOnImage, forState: .Normal)
            MusicSingleton.sharedMusic().isMusicMute = true
            MusicSingleton.sharedMusic().playBackgroundAudio(false)
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func goBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        
        // Don't forget to re-enable the interactive gesture
        self.navigationController?.interactivePopGestureRecognizer!.enabled = true
        
        // if the back button is pressed when a clue audio is recording or playing, the music status is stoped
        // so we need to play when exit to another screen
        if !MusicSingleton.sharedMusic().isMusicMute {
            MusicSingleton.sharedMusic().playBackgroundAudio(true)
        }
    }
    
    // MARK: - NAVIGATION
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //allGames = createExampleGames()
        //gallery = createExampleGallery()
        
        if (segue.identifier == "AllGamesSegue") {
            
            //(segue.destinationViewController as! GamesCollectionViewController).allGames = allGames
            
        }else if (segue.identifier == "GallerySegue"){
            
            //(segue.destinationViewController as! GalleryCollectionViewController).gallery = gallery
        }
    }
    
}