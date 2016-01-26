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
    
    private var aGenerator: LGCrosswordGenerator!
    
    //Mark: - VIEWCONTROLLER LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //set image of mute button
        if MusicSingleton.sharedMusic().isMute {
            muteButton.setImage(muteOnImage, forState: .Normal)
        } else {
            muteButton.setImage(muteOffImage, forState: .Normal)
        }
        
        //starts the background music
        MusicSingleton.sharedMusic().playBackgroundAudio(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - BUTTON ACTIONS

    @IBAction func randomGame(sender: AnyObject) {
        print("me apertou! quero random game!")
        WordAndClueServices.retriveAllWordAndClues( { words in
            
            let operation = NSBlockOperation( block: {
                var avaiableWords = words
                var randomWords: [WordAndClue] = []
                
                //select 6 random words
                avaiableWords = words
                randomWords = []
                
                for _ in 1...6 {
                    let anIndex = random() % avaiableWords.count
                    randomWords.append(avaiableWords[anIndex])
                    avaiableWords.removeAtIndex(anIndex)
                }
                
                //generate a crossword
                self.aGenerator = LGCrosswordGenerator(rows: BoardView.maxSquaresinRow, cols: BoardView.maxSquaresInCol, maxloops: 2000, avaiableWords: randomWords)
                
                self.aGenerator.computeCrossword(3, spins: 4)
                
                self.performSegueWithIdentifier("randomGame", sender: nil)
            })
            
            NSOperationQueue.mainQueue().addOperation(operation)
        })
    }

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
    
    //MARK: - NAVIGATION
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "randomGame" {
            
            (segue.destinationViewController as! GamePlayViewController).crosswordMatrix = aGenerator.grid
            (segue.destinationViewController as! GamePlayViewController).words = aGenerator.currentWordlist
        }
    }
}
