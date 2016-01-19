//
//  LGCDWordAndClue+CoreDataProperties.swift
//  LinguaDeGato
//
//  Created by Andre Scherma Soleo on 19/01/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension LGCDWordAndClue {

    @NSManaged var audio: NSNumber?
    @NSManaged var imageID: String?
    @NSManaged var games: NSSet?
    @NSManaged var word: LGCDWord?

}
