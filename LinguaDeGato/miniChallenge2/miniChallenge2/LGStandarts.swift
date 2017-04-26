//
//  LGStandarts.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 02/02/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation
import UIKit

class LGStandarts {

    //returns a standart Activity indcator for Língua de Gato
    //Centrilized in screen.
    //Grey background with white large whell
    static func standartLGActivityIndicator (_ view: UIView) -> UIActivityIndicatorView {
        
        let indicator = UIActivityIndicatorView()
        
        indicator.frame.size = CGSize(width: 60, height: 60)
        indicator.center = view.center
        indicator.backgroundColor = UIColor.gray
        indicator.activityIndicatorViewStyle = .whiteLarge
        indicator.layer.cornerRadius = 6
        indicator.layer.zPosition = 20
        indicator.hidesWhenStopped = true
        
        return indicator
    }
}
