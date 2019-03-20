//
//  UIColorExtension.swift
//  miniChallenge2
//
//  Created by Kobayashi on 12/7/15.
//  Copyright © 2015 Kobayashi. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static func colorWithPercentageValue(_ redValue: CGFloat, greenValue: CGFloat, blueValue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: redValue/255.0, green: greenValue/255.0, blue: blueValue/255.0, alpha: alpha)
    }
    
    static func orangePalete() -> UIColor {
        return colorWithPercentageValue(247.0, greenValue: 169.0, blueValue: 60.0, alpha: 1.0)
    }
    
    static func orangePaleteTransparent() -> UIColor {
        return colorWithPercentageValue(247.0, greenValue: 169.0, blueValue: 60.0, alpha: 0.5)
    }
    
    static func pinkPalete() -> UIColor {
        return colorWithPercentageValue(234.0, greenValue: 81.0, blueValue: 148.0, alpha: 1.0)
    }
    
    static func greenPalete() -> UIColor {
        return colorWithPercentageValue(170.0, greenValue: 200.0, blueValue: 33.0, alpha: 1.0)
    }
    
    static func bluePalete() -> UIColor {
        return colorWithPercentageValue(61.0, greenValue: 175.0, blueValue: 218.0, alpha: 1.0)
    }
    
    static func bluePaleteTransparent() -> UIColor {
        return colorWithPercentageValue(61.0, greenValue: 175.0, blueValue: 218.0, alpha: 0.5)
    }
    
    static func blueDarkPalete() -> UIColor {
        return colorWithPercentageValue(55.0, greenValue: 126.0, blueValue: 196.0, alpha: 1)
    }
    
    static func greenWaterPalete() -> UIColor {
        return colorWithPercentageValue(99.0, greenValue: 177.0, blueValue: 151.0, alpha: 1.0)
    }
    
    static func greyLightPalete() -> UIColor {
        return colorWithPercentageValue(244.0, greenValue: 244.0, blueValue: 244.0, alpha: 1)
    }
    
}
