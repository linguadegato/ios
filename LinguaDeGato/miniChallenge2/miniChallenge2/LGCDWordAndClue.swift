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
        let entityDescription: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "LGCDWordAndClue", in: context)
        
        //call super using
        super.init(entity: entityDescription!, insertInto: context)
        
        //set properties and relationships
        self.word = aWord
        self.audioPath = anAudioPath
        self.imageID = anImageID
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        
        // get context
        let context: NSManagedObjectContext = DatabaseManager.sharedInstance.managedObjectContext!
        
        // create entity description
        let entityDescription: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "LGCDWordAndClue", in: context)
        
        //call super using
        super.init(entity: entityDescription!, insertInto: context)
    }
}
