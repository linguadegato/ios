//
//  ViewController.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 21/01/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let words = ["brodi", "mano", "brow", "parça"]
        let ids = ["12345", "0987", "4657", "333333"]
        let paths = ["qqqqqq", "kkkkkk", "ccccc", "hhhhh"]
        var wacs: [WordAndClue] = []
        
        
        
        for i in 0...3 {
            let aWord = words[i]
            let aClue = Clue(aImageID: ids[i], anAudioPath: paths[i])
            
            let aWordAndClue = WordAndClue(aWord: aWord, aClue: aClue)
            wacs.append(aWordAndClue)
            
            WordAndClueServices.saveWordAndClue(aWordAndClue)
        }
        
        
        for i in 1...2 {
            WordAndClueServices.saveWordAndClue(wacs[i])
        }
        
        print("retrieving by word and clue")
        for i in 0...3 {
            WordAndClueServices.retrieveWordAndClue(wacs[i], completion: { result in
                NSOperationQueue.mainQueue().addOperation(NSBlockOperation(block: {
                    
                    if result != nil {
                        print(result!.word)
                    }
                    else{
                        print("none")
                    }
                }))
            })
        }
        
        var anotherWac: [WordAndClue] = []
        WordAndClueServices.retriveWordAndCluesWithWord("papagaio", completion: {result in
            
            NSOperationQueue.mainQueue().addOperation(NSBlockOperation(block: {

                print("\n wacs with papagaio")
                for w in result {
                    print(w.word, w.clue.imageID, w.clue.audioPath)
                }
            }))
        })

        WordAndClueServices.retriveWordAndCluesWithWord("macaco", completion: { result in
           
            NSOperationQueue.mainQueue().addOperation(NSBlockOperation(block: {
                print("\n wacs with macaco")
                for w in result {
                    print(w.word, w.clue.imageID, w.clue.audioPath)
                }
            }))
        })
        
        
        WordAndClueServices.retriveAllWordAndClues({ results in
            
            NSOperationQueue.mainQueue().addOperation(NSBlockOperation(block: {
            let allWacs = results
            print("allWacs")
                for word in allWacs {
                    print(word.word, word.clue.audioPath, word.clue.imageID)
                }
            }))
        })
        
        print("cabou")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
