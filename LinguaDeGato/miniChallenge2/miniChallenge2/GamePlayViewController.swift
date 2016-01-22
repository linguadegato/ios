//
//  GamePlayViewController.swift
//  miniChallenge2
//
//  Created by Andre Scherma Soleo on 20/08/15.
//  Copyright (c) 2015 Kobayashi. All rights reserved.
//

import UIKit
import AVFoundation

class GamePlayViewController: StatusBarViewController, BoardViewDelegate, BoardViewDataSource {

    // MARK: - CUSTOMIZATION PROPERTIES (colors, proportions, etc)
    //will be used to change the background color in a new game
    static var backgroundColor = 0
    
    // MARK: - VIEWS
    @IBOutlet weak var boardView: BoardView!
    
    // MARK: - NAVIGATION BUTTONS
    // navigation bar button
    var backButton : UIBarButtonItem!
    
    // MARK: - GAME PROPERTIES (words array, positions matrix, etc)
    var crosswordMatrix: [[CrosswordElement?]]?
    var words = [WordAndClue]()
    var finishGamePlayAudio = AVAudioPlayer()

    // MARK: - LIFECYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boardView.dataSource = self
        boardView.delegate = self
        
        // Disable the swipe to make sure you get your chance to save
        self.navigationController?.interactivePopGestureRecognizer?.enabled = false
        
        // Replace the default back button
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.backButton = UIBarButtonItem(title: "< Sair", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        self.navigationItem.leftBarButtonItem = backButton
        
        let finishGame = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("finishGame", ofType: "wav")!)
        
        do {
            try finishGamePlayAudio = AVAudioPlayer(contentsOfURL: finishGame)
        }
        catch _ {
            // Error handling
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - BOARDGAME DATASOURCE METHODS
    
    func getCrossWordMatrix() -> [[CrosswordElement?]]? {
        
        return crosswordMatrix
    }
    
    func getCrossWordWords() -> [WordAndClue] {
        return words
    }
    
    // MARK - BUTTON ACTIONS
    
    // "back" button
    func goBack() {
        let alert = UIAlertController(title: "Deseja realmente sair?", message: "O jogo será interrompido.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Sair", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            self.navigationController?.popViewControllerAnimated(true)
            
            // Don't forget to re-enable the interactive gesture
            self.navigationController?.interactivePopGestureRecognizer!.enabled = true
            
            // if the back button is pressed when a clue audio is open, the music status is stoped
            // so we need to play when exit to another screen
            if !MusicSingleton.sharedMusic().mute {
            MusicSingleton.sharedMusic().playBackgroundAudio(true)
            }
        }))
        self.presentViewController(alert, animated: true, completion: {
        })
    }
    
    // "mute" button
    @IBAction func muteButton(sender: AnyObject) {
        if MusicSingleton.sharedMusic().mute {
            // music will play
            MusicSingleton.sharedMusic().mute = false
            MusicSingleton.sharedMusic().playBackgroundAudio(true)
        } else {
            // music will stop
            MusicSingleton.sharedMusic().mute = true
            MusicSingleton.sharedMusic().playBackgroundAudio(false)
        }
    }
    
    //MARK: - BOARDGAME DELEGATE METHODS
    
    func gameEnded() {
        
        finishGamePlayAudio.volume = 0.2
        if !MusicSingleton.sharedMusic().mute {
        finishGamePlayAudio.play()
        }
        
        let alertController = UIAlertController(title: "PARABÉNS", message:
            "Você concluiu o jogo! \u{1F431}", preferredStyle: UIAlertControllerStyle.Alert)

        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: backByWinningFromAlertAction))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - TODO: NAVIGATION (porque voce tem que conseguir sair, neh?)

    func backByWinningFromAlertAction (action: UIAlertAction) {
        finishGamePlayAudio.stop()
        self.navigationController!.popViewControllerAnimated(true)
    }
}


