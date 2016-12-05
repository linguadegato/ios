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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - VIEWS
    @IBOutlet weak var boardView: BoardView!
    @IBOutlet weak var muteMusicButton: UIButton!
    @IBOutlet weak var muteAudioButton: UIButton!

    // MARK: - NAVIGATION BUTTONS
    // navigation bar button
    var backButton : UIBarButtonItem!
    
    fileprivate let muteMusicOnImage = UIImage(named: "btnMuteMusicOnLightBlue")
    fileprivate let muteMusicOffImage = UIImage(named: "btnMuteMusicOffLightBlue")
    
    fileprivate let muteAudioOnImage = UIImage(named: "btnMuteAudioOnLightBlue")
    fileprivate let muteAudioOffImage = UIImage(named: "btnMuteAudioOffLightBlue")
    
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
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        let finishGame = URL(fileURLWithPath: Bundle.main.path(forResource: "finishGame", ofType: "wav")!)
        
        do {
            try finishGamePlayAudio = AVAudioPlayer(contentsOf: finishGame)
        }
        catch _ {
            // Error handling
        }
        
        self.activityIndicator.stopAnimating()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.activityIndicator.startAnimating()
        
        //set image of mute music button
        if MusicSingleton.sharedMusic().isMusicMute {
            muteMusicButton.setImage(muteMusicOnImage, for: UIControlState())
        } else {
            muteMusicButton.setImage(muteMusicOffImage, for: UIControlState())
        }
        
        // set image of mute audio button
        
        if MusicSingleton.sharedMusic().isAudioMute {
            muteAudioButton.setImage(muteAudioOnImage, for: UIControlState())
        } else {
            muteAudioButton.setImage(muteAudioOffImage, for: UIControlState())
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
    
    
    @IBAction func goHome(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Deseja realmente sair?", message: "O jogo será interrompido.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler:nil))
        
        alert.addAction(UIAlertAction(
            title: "Sair",
            style: UIAlertActionStyle.default,
            handler:{ (UIAlertAction)in
                
                let _ = self.navigationController?.popToRootViewController(animated: true)
                // Don't forget to re-enable the interactive gesture
                self.navigationController?.interactivePopGestureRecognizer!.isEnabled = true
                
                // if the back button is pressed when a clue audio is open, the music status is stoped
                // so we need to play when exit to another screen
                if !MusicSingleton.sharedMusic().isMusicMute {
                    MusicSingleton.sharedMusic().playBackgroundAudio(true)
                }
            }
            ))
        
        self.present(alert, animated: true, completion: {})
        
        print("home")
    }
    
    // "mute music" button
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
    
    // "mute audio" button
    @IBAction func muteAudioButton(_ sender: AnyObject) {
        
        if MusicSingleton.sharedMusic().isAudioMute {
            // audio will play
            muteAudioButton.setImage(muteAudioOffImage, for: UIControlState())
            MusicSingleton.sharedMusic().isAudioMute = false
        } else {
            // audio will stop
            muteAudioButton.setImage(muteAudioOnImage, for: UIControlState())
            MusicSingleton.sharedMusic().isAudioMute = true
        }
    }
    
    
    //MARK: - BOARDGAME DELEGATE METHODS
    
    func gameEnded() {
        
        if !MusicSingleton.sharedMusic().isAudioMute {
            finishGamePlayAudio.volume = 0.2
            finishGamePlayAudio.play()
        }
        
        /*
        let alertController = UIAlertController(title: "PARABÉNS", message:
            "Você concluiu o jogo! \u{1F431}", preferredStyle: UIAlertControllerStyle.Alert)

        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: backByWinningFromAlertAction))
        */
        
        performSegue(withIdentifier: "GameEnded", sender: nil)
    }
    
    
    // MARK: - TODO: NAVIGATION (porque voce tem que conseguir sair, neh?)

    func backByWinning () {
        finishGamePlayAudio.stop()
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GameEnded" {
            (segue.destination as! GameEndPopupVC).previousViewController = self
        }
    }
}


