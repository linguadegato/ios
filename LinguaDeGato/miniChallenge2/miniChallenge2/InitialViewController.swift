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
    
    @IBOutlet weak var privacyPolicyView: UITextView!
    @IBOutlet weak var closePrivacyPolicyButton: UIButton!

    fileprivate var aGenerator: LGCrosswordGenerator!
    
    //Mark: - VIEWCONTROLLER LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Set Privacy Policy popup message
        let privacyPolicyString = NSLocalizedString("InitialViewController.PrivacyPolicyViewContent", value:"Privacy Policy:\n\nThis application is designed for children under the age of 13.\n\nAll content created through the application is the entirely responsibility of its users.\n\nData Collect:\n\nWe take photos and use the microphone only with the purpose of fulfilling the main functionality of the application.\n\nSecurity:\n\nWe use standard internal security protocols to protect your personal information.\n\nUser control:\n\nThe application allows the user to access and delete his data.\n\nLocation:\n\nWe do not register or share your location.\n\nThis application does not have: \n\n- Advertising\n- Analytics\nFor more information, contact us: contato@linguadegatoapp.com.br", comment:"Message of the privacy policy popup")
        
        privacyPolicyView.font = UIFont.init(name: "Helvetica Neue", size: 17.0)
        privacyPolicyView.text = privacyPolicyString
        
        //shows an alert in the first time app is open (false to use in test)
        if (UserDefaults.standard.value(forKey: "firstTime") as? Bool == true) {
            
            let firstAlert = UIAlertController(
                title: NSLocalizedString("InitialViewController.firstAlert.title", value: "Attention!", comment: "Title of an alert popup that appears when the user first use the app"),
                message: NSLocalizedString("InitialViewController.firstAlert.message", value: "All content created within this application is the entire responsibility of its users.", comment: "Message informing that the content of the application is the responsibility of the user"),
                preferredStyle: UIAlertController.Style.alert
            )
            
            firstAlert.addAction(UIAlertAction(
                title: NSLocalizedString("InitialViewController.firstAlert.okBtn", value:"OK", comment: "Ok button that close the alert"),
                style: .default,
                handler: { _ in
                    self.performSegue(withIdentifier: "tutorial", sender: nil)
                }
            ))
            
            self.present(firstAlert, animated: true, completion: nil)

            UserDefaults.standard.setValue(false, forKey: "firstTime")
            
            UserDefaults.standard.synchronize()
        } else {
            //do nothing
        }
        
        privacyPolicyView.contentOffset = CGPoint.zero
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - BUTTON ACTIONS

    @IBAction func randomGame(_ sender: AnyObject) {
        
        let indicator = LGStandarts.standartLGActivityIndicator(self.view)
        
        self.view.addSubview(indicator)
        indicator.startAnimating()

        WordAndClueServices.retriveAllWordAndClues( { words in
            
            let operation = BlockOperation( block: {
                var avaiableWords = words
                var randomWords: [WordAndClue] = []
                
                //select 6 random words
                avaiableWords = words
                randomWords = []
                
                indicator.removeFromSuperview()
                if avaiableWords.isEmpty {
                    self.noWordsAlert()
                }
                else {
                    let wordsForRandom = min(6, avaiableWords.count)
                    
                    for _ in 1...wordsForRandom {
                        let randomInt = Int(arc4random())
                        let anIndex = randomInt % avaiableWords.count
                        randomWords.append(avaiableWords[anIndex])
                        avaiableWords.remove(at: anIndex)
                    }
                    
                    //generate a crossword
                    // I dont know why cols and rows are interchanged... will not fix it right now
                    self.aGenerator = LGCrosswordGenerator(rows: BoardView.maxSquaresInCol, cols: BoardView.maxSquaresinRow, maxloops: 2000, avaiableWords: randomWords)
                    self.aGenerator.computeCrossword(3, spins: 6)
                    
                    self.performSegue(withIdentifier: "randomGame", sender: nil)
                }
            })
            
            OperationQueue.main.addOperation(operation)
        })
    }

    @IBAction func savedGame(_ sender: AnyObject) {
        
        let indicator = LGStandarts.standartLGActivityIndicator(self.view)
        
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
        WordAndClueServices.retriveAllWordAndClues({ words in
            
            let operation = BlockOperation(block: {
                indicator.removeFromSuperview()
                if words.isEmpty {
                    self.noWordsAlert()
                }
                else {
                    self.performSegue(withIdentifier: "toGallery", sender: nil)
                }
            })
            OperationQueue.main.addOperation(operation)
        })
    }
    
    @IBAction func openPrivacyPolicy() {
        privacyPolicyView.isHidden = false
        closePrivacyPolicyButton.isHidden = false
    }

    @IBAction func closePrivacyPolicy() {
        privacyPolicyView.isHidden = true
        closePrivacyPolicyButton.isHidden = true
        privacyPolicyView.contentOffset = CGPoint.zero
    }

    //MARK: - ALERTS
    fileprivate func noWordsAlert() {
        
        let alert = UIAlertController(
            title: NSLocalizedString("InitialViewController.alert.title", value: "You don't have any saved words yet", comment: "Alert title informing the user that he cant click on play game button because there isnt any saved word yet."),
            message: NSLocalizedString("InitialViewController.alert.message", value: "Create a new game", comment: "Alert message informing the user to create new game before play."),
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("InitialViewController.firstAlert.okBtn", value:"Ok", comment: "Ok button that close the alert"),
            style: .default,
            handler: nil
        ))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "randomGame" {
            
            (segue.destination as! GamePlayViewController).crosswordMatrix = aGenerator.grid
            (segue.destination as! GamePlayViewController).words = aGenerator.currentWordlist
        }
    }
}
