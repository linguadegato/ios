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
    @IBOutlet weak var muteMusicButton: UIButton!

    
    private let muteMusicOnImage = UIImage(named: "btnMuteMusicOnLightBlue")
    private let muteMusicOffImage = UIImage(named: "btnMuteMusicOffLightBlue")
    
    private var aGenerator: LGCrosswordGenerator!
    
    //Mark: - VIEWCONTROLLER LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //starts the background music
        MusicSingleton.sharedMusic().playBackgroundAudio(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        //set image of mute music button
        if MusicSingleton.sharedMusic().isMusicMute {
            muteMusicButton.setImage(muteMusicOnImage, forState: .Normal)
        } else {
            muteMusicButton.setImage(muteMusicOffImage, forState: .Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - BUTTON ACTIONS

    @IBAction func randomGame(sender: AnyObject) {

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
                // I dont know why cols and rows are interchanged... will not fix it right now
                self.aGenerator = LGCrosswordGenerator(rows: BoardView.maxSquaresInCol, cols: BoardView.maxSquaresinRow, maxloops: 2000, avaiableWords: randomWords)
                
                self.aGenerator.computeCrossword(3, spins: 4)
                
                self.performSegueWithIdentifier("randomGame", sender: nil)
            })
            
            NSOperationQueue.mainQueue().addOperation(operation)
        })
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
    
    //MARK: - NAVIGATION
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "randomGame" {
            
            (segue.destinationViewController as! GamePlayViewController).crosswordMatrix = aGenerator.grid
            (segue.destinationViewController as! GamePlayViewController).words = aGenerator.currentWordlist
        }
    }
}
