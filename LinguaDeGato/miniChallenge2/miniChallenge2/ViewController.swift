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
        
        let words = ["gato", "gato", "papagaio", "agiota"]
        let ids = ["412343124", "89889", "675568568", "8348943"]
        let paths = ["uuuuu", "yyyyyy", "iiiii", "jjjjjj"]
        var wacs: [WordAndClue] = []
        
        
        
        for i in 0...3 {
            let aWord = words[i]
            let aClue = Clue(aImageID: ids[i], anAudioPath: paths[i])
            
            let aWordAndClue = WordAndClue(aWord: aWord, aClue: aClue)
            wacs.append(aWordAndClue)
            
            //WordAndClueServices.saveWordAndClue(aWordAndClue)
        }
        
        /*
        for i in 1...2 {
            //WordAndClueServices.saveWordAndClue(wacs[i])
        }
        */
        
        print("retrieving by word and clue")
        for i in 0...3 {
            if let aWac = WordAndClueServices.retrieveWordAndClue(wacs[i]){
                print(aWac.word)
            }
        }
        
        var anotherWac = WordAndClueServices.retriveWordAndCluesWithWord("papagaio")
        print("\n wacs with papagaio")
        for w in anotherWac {
            print(w.word, w.clue.imageID, w.clue.audioPath)
        }

        anotherWac = WordAndClueServices.retriveWordAndCluesWithWord("macaco")
        print("\n wacs with macaco")
        for w in anotherWac {
            print(w.word, w.clue.imageID, w.clue.audioPath)
        }
        let allWacs = WordAndClueServices.retriveAllWordAndClues()
        
        print("allWacs")
        for word in allWacs {
            print(word.word, word.clue.audioPath, word.clue.imageID)
        }
        
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
