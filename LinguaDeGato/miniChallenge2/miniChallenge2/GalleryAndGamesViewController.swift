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
    private let muteOnImage = UIImage(named: "btnMuteOnLightBlue")
    private let muteOffImage = UIImage(named: "btnMuteOffLightBlue")
    
    @IBOutlet weak var muteButton: UIButton!
    
    override func viewDidLoad() {
        // Replace the default back button
//        self.navigationItem.setHidesBackButton(true, animated: false)
//        self.backButton = UIBarButtonItem(title: "< ", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
//        self.backButton.tintColor = UIColor.bluePalete()
//        self.navigationItem.leftBarButtonItem = backButton
        
        //set image of mute button
        if MusicSingleton.sharedMusic().isMute {
            muteButton.setImage(muteOnImage, forState: .Normal)
        } else {
            muteButton.setImage(muteOffImage, forState: .Normal)
        }
    }
    
    @IBAction func muteButton(sender: AnyObject) {
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