//
//  GalleryGlobalValues.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 25/12/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation
import UIKit

class GalleryGlobalValues {
    
    static var gamesNeedToReload = false {
        didSet {
            if gamesNeedToReload {
                self.gamesViewController!.loadFromDataBase()
                self.gamesViewController!.gamesCollectionView.reloadData()
                gamesNeedToReload = false
            }
        }
    }
    
    static var galleryNeedsToReload = false
    
    static var gamesViewController: GamesViewController?
    
}
