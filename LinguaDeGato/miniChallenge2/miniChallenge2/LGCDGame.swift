//
//  LGCDGame.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 22/01/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation
import CoreData


class LGCDGame: NSManagedObject {

    init(newGameName: String, newWordsAndClues: [LGCDWordAndClue]) {
        
        // get context
        let context: NSManagedObjectContext = DatabaseManager.sharedInstance.managedObjectContext!
        
        // create entity description
        let entityDescription: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "LGCDGame", in: context)
        
        //call super using
        super.init(entity: entityDescription!, insertInto: context)
        
        //set properties and relationships
        self.name = newGameName
        self.words = NSMutableSet(array: newWordsAndClues)
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        
        // get context
        let context: NSManagedObjectContext = DatabaseManager.sharedInstance.managedObjectContext!
        
        // create entity description
        let entityDescription: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "LGCDGame", in: context)
        
        //call super using
        super.init(entity: entityDescription!, insertInto: context)
    }
}
