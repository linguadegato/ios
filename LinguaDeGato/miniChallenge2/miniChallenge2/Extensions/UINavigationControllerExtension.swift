//
//  UINavigationControllerExtension.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 13/11/15.
//  Copyright © 2015 Kobayashi. All rights reserved.
//

import Foundation
import UIKit

// locks the orientation of navigation controller to landscape
// should auto rotate is enabled
extension UINavigationController {
    
    override open var shouldAutorotate : Bool {
        return true
    }
    
    override open var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    override open func viewDidLoad() {
        interactivePopGestureRecognizer!.isEnabled = false
    }
}
