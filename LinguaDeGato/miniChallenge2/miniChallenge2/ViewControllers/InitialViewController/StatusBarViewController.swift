//
//  StatusBarViewController.swift
//  LinguaDeGato
//
//  Created by Jheniffer Jordao Leonardi on 12/2/15.
//  Copyright © 2015 Kobayashi. All rights reserved.
//

import UIKit

class StatusBarViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //changes the background color of the status bar
        let statusBarBackground = UIView(frame: CGRect(x: 0, y: -40, width: (self.navigationController?.navigationBar.frame.width)!, height: 40))
        statusBarBackground.backgroundColor = UIColor(red:0.18, green:0.69, blue:0.86, alpha:1.0)
        self.navigationController?.navigationBar.addSubview(statusBarBackground)
        
        self.navigationController?.navigationBar.tintColor = UIColor.bluePalete()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = .none
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
