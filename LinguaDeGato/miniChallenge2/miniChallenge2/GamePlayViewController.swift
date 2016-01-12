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
    
    // MARK: - GAME PROPERTIES (words array, positions matrix, etc)
    var crosswordMatrix: [[CrosswordElement?]]?
    var words = [WordAndClue]()
    var finishGamePlayAudio = AVAudioPlayer()
    
    // MARK: - LIFECYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boardView.dataSource = self
        boardView.delegate = self
        
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
    
    //MARK: - BOARDGAME DELEGATE METHODS
    
    func gameEnded() {
        
        finishGamePlayAudio.volume = 0.2
        finishGamePlayAudio.play()
        
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


