//
//  UINavigationControllerExtension.swift
//  miniChallenge2
//
//  Created by Andre Scherma Soleo on 13/11/15.
//  Copyright © 2015 Kobayashi. All rights reserved.
//

import Foundation
import UIKit

// locks the orientation of navigation controller to landscape
// should auto rotate is enabled
extension UINavigationController {
    
    override public func shouldAutorotate() -> Bool {
        return true
    }
    
    override public func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
}