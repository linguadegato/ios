//
//  LGCDWordAndClue.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 19/01/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation
import CoreData


class LGCDWordAndClue: NSManagedObject {

    init(aWord: String, anAudioPath: String?, anImageID: String?) {
        
        // get context
        let context: NSManagedObjectContext = DatabaseManager.sharedInstance.managedObjectContext!
        
        // create entity description
        let entityDescription: NSEntityDescription? = NSEntityDescription.entityForName("LGCDGame", inManagedObjectContext: context)
        
        //call super using
        super.init(entity: entityDescription!, insertIntoManagedObjectContext: context)
        
        //set properties and relationships
        self.word = aWord
        self.audioPath = anAudioPath
        self.imageID = anImageID
    }
}
