//
//  LGCDGame.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 18/01/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation
import CoreData


class LGCDGame: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    
    init(newGameName: String, newWordsAndClues: [LGCDWordAndClue]) {
        
        // get context
        let context: NSManagedObjectContext = DatabaseManager.sharedInstance.managedObjectContext!
        
        // create entity description
        let entityDescription: NSEntityDescription? = NSEntityDescription.entityForName("LGCDGame", inManagedObjectContext: context)
        
        //call super using
        super.init(entity: entityDescription!, insertIntoManagedObjectContext: context)
        
        //set properties and relationships
        self.gameName = newGameName
        self.wordsAndClues = NSSet(array: newWordsAndClues)
    }
}
