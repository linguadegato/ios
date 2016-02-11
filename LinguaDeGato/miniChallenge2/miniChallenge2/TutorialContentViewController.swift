//
//  TutorialContentViewController.swift
//  LinguaDeGato
//
//  Created by Jheniffer Jordao Leonardi on 2/5/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import UIKit

class TutorialContentViewController: UIViewController {

    @IBOutlet weak var tutorialImageView: UIImageView!
    @IBOutlet weak var tutorialTitleLabel: UILabel!
    
    var pageIndex: Int!
    var titleText: String!
    var imageFile: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tutorialImageView.image = UIImage(named: imageFile)
        self.tutorialTitleLabel.text = self.titleText
        
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
