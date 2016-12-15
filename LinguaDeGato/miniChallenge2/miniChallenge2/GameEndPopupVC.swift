//
//  GameEndPopupVC.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 01/02/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import UIKit

class GameEndPopupVC: UIViewController {
    
    var previousViewController: GamePlayViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.view.layer.zPosition = 5

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dissmissPopup() {
        self.dismiss(animated: true, completion: {
            if self.previousViewController != nil {
                self.previousViewController.backByWinning()
            }
        })
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
