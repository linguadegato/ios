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
        
        
        //shows an alert in the first time app is open
        if (NSUserDefaults.standardUserDefaults().valueForKey("firstTime") as? Bool == true) {
            
            let firstAlert = UIAlertController(title: "ATENÇÃO", message: "Todo conteúdo criado dentro da aplicação é de total responsabilidade de seus usuários.", preferredStyle: UIAlertControllerStyle.Alert)
            firstAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            self.presentViewController(firstAlert, animated: true, completion: nil)
            
            NSUserDefaults.standardUserDefaults().setValue(false, forKey: "firstTime")
            NSUserDefaults.standardUserDefaults().synchronize()
        } else {
            //do nothing
        }
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
        
        let indicator = LGStandarts.standartLGActivityIndicator(self.view)
        
        self.view.addSubview(indicator)
        indicator.startAnimating()

        WordAndClueServices.retriveAllWordAndClues( { words in
            
            let operation = NSBlockOperation( block: {
                var avaiableWords = words
                var randomWords: [WordAndClue] = []
                
                //select 6 random words
                avaiableWords = words
                randomWords = []
                
                if avaiableWords.isEmpty {
                    self.noWordsAlert()
                }
                else {
                    let wordsForRandom = min(6, avaiableWords.count)
                    
                    for _ in 1...wordsForRandom {
                        let anIndex = random() % avaiableWords.count
                        randomWords.append(avaiableWords[anIndex])
                        avaiableWords.removeAtIndex(anIndex)
                    }
                    
                    //generate a crossword
                    // I dont know why cols and rows are interchanged... will not fix it right now
                    self.aGenerator = LGCrosswordGenerator(rows: BoardView.maxSquaresInCol, cols: BoardView.maxSquaresinRow, maxloops: 2000, avaiableWords: randomWords)
                    self.aGenerator.computeCrossword(3, spins: 4)
                    
                    indicator.removeFromSuperview()
                    self.performSegueWithIdentifier("randomGame", sender: nil)
                }
            })
            
            NSOperationQueue.mainQueue().addOperation(operation)
        })
    }

    @IBAction func savedGame(sender: AnyObject) {
        
        let indicator = LGStandarts.standartLGActivityIndicator(self.view)
        
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
        WordAndClueServices.retriveAllWordAndClues({ words in
            
            let operation = NSBlockOperation(block: {
                indicator.removeFromSuperview()
                if words.isEmpty {
                    indicator.removeFromSuperview()
                }
                else {
                    self.performSegueWithIdentifier("toGallery", sender: nil)
                }
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
    
    //MARK: - ALERTS
    private func noWordsAlert() {
        
        let alert = UIAlertController(title: "Ainda não há palavras salvas", message: "Crie jogos para salvar palavras", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: - NAVIGATION
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "randomGame" {
            
            (segue.destinationViewController as! GamePlayViewController).crosswordMatrix = aGenerator.grid
            (segue.destinationViewController as! GamePlayViewController).words = aGenerator.currentWordlist
        }
    }
}
