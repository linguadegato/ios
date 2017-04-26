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
    @IBOutlet weak var muteMusicButton: UIButton!
    @IBOutlet weak var muteAudioButton: UIButton!
    
    var indicator: UIActivityIndicatorView?
    
    // navigation bar button
    var backButton : UIBarButtonItem!
    
    fileprivate let muteAudioOnImage = UIImage(named: "btnMuteAudioOnLightBlue")
    fileprivate let muteAudioOffImage = UIImage(named: "btnMuteAudioOffLightBlue")
    
    // MARK: - GAME PROPERTIES (words array, positions matrix, etc)
    var crosswordMatrix: [[CrosswordElement?]]?
    var words = [WordAndClue]()
    var finishGamePlayAudio = AVAudioPlayer()

    // MARK: - LIFECYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable the swipe to make sure you get your chance to save
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        let finishGame = URL(fileURLWithPath: Bundle.main.path(forResource: "finishGame", ofType: "wav")!)
        do {
            try finishGamePlayAudio = AVAudioPlayer(contentsOf: finishGame)
        }
        catch _ {
            // Error handling
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // set image of mute audio button
        if MusicSingleton.sharedMusic().isAudioMute {
            muteAudioButton.setImage(muteAudioOnImage, for: UIControlState())
        } else {
            muteAudioButton.setImage(muteAudioOffImage, for: UIControlState())
        }
        
        self.indicator = LGStandarts.standartLGActivityIndicator(self.view)
        self.view.addSubview(indicator!)
        indicator!.startAnimating()
    }
    
    override func viewDidAppear(_ animated:Bool){
        
        boardView.dataSource = self
        boardView.delegate = self
        
        let crossword = LGCrosswordGenerator.generateCrossword(words: self.words)
        
        self.words = crossword.wordsList
        self.crosswordMatrix = crossword.grid
        
        //MARK: FIX-ME: GAMBIAAAARRA! Concerte o boardView
        self.boardView.draw(self.boardView.frame)
        
        self.indicator!.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - BUTTON ACTIONS
    
    @IBAction func goHome(_ sender: AnyObject) {
        let alert = UIAlertController(
            title: NSLocalizedString("GamePlayViewController.GoBackPopup.title", value:"Do you really want to exit?", comment:"Ask the user if he wants to go back and cancel the game."),
            message: NSLocalizedString("GamePlayViewController.GoBackPopup.message", value:"This game will be canceled.", comment:"Message informing the user that if he returns, he will stop and cancel the game."),
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("GamePlayViewController.goBackPopup.button.cancel", value:"Cancel", comment:"Button to cancel the action of returning."),
            style: UIAlertActionStyle.cancel,
            handler:nil
        ))
        
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("GamePlayViewController.goBackPopup.button.continue", value:"Exit", comment:"Button to continue the action of returning to home screen and cancel the game."),
            style: UIAlertActionStyle.default,
            handler:{ (UIAlertAction)in
                
                let _ = self.navigationController?.popToRootViewController(animated: true)
                // Don't forget to re-enable the interactive gesture
                self.navigationController?.interactivePopGestureRecognizer!.isEnabled = true
                
        }
        ))
        
        self.present(alert, animated: true, completion: {})
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
    
    //MARK: - BOARDGAME DATASOURCE METHODS
    
    func getCrossWordMatrix() -> [[CrosswordElement?]]? {
        
        return crosswordMatrix
    }
    
    func getCrossWordWords() -> [WordAndClue] {
        return words
    }
    
    //MARK: - BOARDGAME DELEGATE METHODS
    
    func gameEnded() {
        
        if !MusicSingleton.sharedMusic().isAudioMute {
            finishGamePlayAudio.volume = 0.2
            finishGamePlayAudio.play()
        }
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


