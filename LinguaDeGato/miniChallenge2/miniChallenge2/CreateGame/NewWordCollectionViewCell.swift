//
//  NewWordCollectionViewCell.swift
//  miniChallenge2
//
//  Created by Kobayashi on 6/15/15.
//  Copyright (c) 2015 Kobayashi. All rights reserved.
//

import UIKit

class NewWordCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var labelCell: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var audioIcon: UIImageView!
    
    var wordAndClue: WordAndClue?
    
    var delegate: CreateCrosswordViewController!
    var index: Int!
    
    @IBAction func delete() {
        delegate!.cellAlert(index!)
    }

}
