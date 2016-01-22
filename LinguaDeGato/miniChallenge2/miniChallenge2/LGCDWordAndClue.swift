//
//  LGCDWordAndClue.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 22/01/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation
import CoreData


class LGCDWordAndClue: NSManagedObject {

    init(aWord: String, anAudioPath: String?, anImageID: String?) {
        
        // get context
        let context: NSManagedObjectContext = DatabaseManager.sharedInstance.managedObjectContext!
        
        // create entity description
        let entityDescription: NSEntityDescription? = NSEntityDescription.entityForName("LGCDWordAndClue", inManagedObjectContext: context)
        
        //call super using
        super.init(entity: entityDescription!, insertIntoManagedObjectContext: context)
        
        //set properties and relationships
        self.word = aWord
        self.audioPath = anAudioPath
        self.imageID = anImageID
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        
        // get context
        let context: NSManagedObjectContext = DatabaseManager.sharedInstance.managedObjectContext!
        
        // create entity description
        let entityDescription: NSEntityDescription? = NSEntityDescription.entityForName("LGCDWordAndClue", inManagedObjectContext: context)
        
        //call super using
        super.init(entity: entityDescription!, insertIntoManagedObjectContext: context)
    }
}
