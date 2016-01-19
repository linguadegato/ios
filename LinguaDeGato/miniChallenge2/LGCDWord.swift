//
//  LGCDWord.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 18/01/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import Foundation
import CoreData


class LGCDWord: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    init(newWord: String) {
        
        // get context
        let context: NSManagedObjectContext = DatabaseManager.sharedInstance.managedObjectContext!
        
        // create entity description
        let entityDescription: NSEntityDescription? = NSEntityDescription.entityForName("LGCDWord", inManagedObjectContext: context)
        
        //call super using
        super.init(entity: entityDescription!, insertIntoManagedObjectContext: context)
        
        //set properties and relationships
        self.word = newWord
    }
    
    func appendAudio(anAudioPath: String) {
        self.audioPath = anAudioPath
    }
}
