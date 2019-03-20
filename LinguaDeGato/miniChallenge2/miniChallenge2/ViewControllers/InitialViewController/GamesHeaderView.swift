//
//  AllGamesHeaderView.swift
//  LinguaDeGato
//
//  Created by Kobayashi on 1/12/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//
import UIKit

class GamesHeaderView: UICollectionReusableView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    
    func setPlayBtnID(sectionNumber: Int){
        playBtn.tag = sectionNumber
    }
    
    func setDeleteBtnID(sectionNumber: Int){
        deleteBtn.tag = sectionNumber
    }
}
