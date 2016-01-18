//
//  GalleryCollectionViewCell.swift
//  LinguaDeGato
//
//  Created by Kobayashi on 1/15/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation
import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var labelCell: UILabel!
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var audioImage: UIImageView!
    
    
    var wordAndClue: WordAndClue!
    var delegate: CreateCrosswordViewController!
    var index: Int!
    
    //    @IBAction func delete() {
    //        delegate!.cellAlert(index!)
    //    }
    
}
