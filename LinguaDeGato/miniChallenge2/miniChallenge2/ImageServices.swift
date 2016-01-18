//
//  ImageServices.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 16/01/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation

class ImageServices {

    static func registerImage(imageID: String){
        let newImageData = LGCDPhoto()
        ImageDAO.insert(newImageData)
    }
    
    static func retriveImage(imageID: String) -> LGCDPhoto? {
        return ImageDAO.retriveImage(imageID)
    }
}