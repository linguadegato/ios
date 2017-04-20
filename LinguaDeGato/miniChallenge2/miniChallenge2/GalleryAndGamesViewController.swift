//
//  GalleryAndGamesViewController.swift
//  LinguaDeGato
//
//  Created by Kobayashi on 1/21/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation
import UIKit

class GalleryAndGamesViewController: UIViewController {
    
    fileprivate var backButton : UIBarButtonItem!
    fileprivate let muteMusicOnImage = UIImage(named: "btnMuteMusicOnLightBlue")
    fileprivate let muteMusicOffImage = UIImage(named: "btnMuteMusicOffLightBlue")
    
    @IBOutlet weak var muteMusicButton: UIButton!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var gamesView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var gamesVC: GamesViewController!
    

    override func viewWillAppear(_ animated: Bool) {
        self.indexChanged(self.segmentedControl)
    }
    
    // MARK: - Button Actions
    
    @IBAction func goBack(_ sender: AnyObject) {
        let _ = self.navigationController?.popViewController(animated: true)
        
        // Don't forget to re-enable the interactive gesture
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = true
                
    }

    // MARK: - Segmented Control action
    @IBAction func indexChanged(_ sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            UIView.animate(withDuration: 0.5, animations: {
                self.galleryView.alpha = 1
                self.gamesView.alpha = 0
            })
        case 1:
            UIView.animate(withDuration: 0.5, animations: {
                self.galleryView.alpha = 0
                self.gamesView.alpha = 1
            })
        default:
            break;
        }
    }
    
    //MARK: - NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "GallerySegue") {
            (segue.destination as! GalleryViewController).galleryAndGamesVC = self
        }
        
        if (segue.identifier == "GamesSegue"){
            self.gamesVC = segue.destination as! GamesViewController
        }
    }

    
}
