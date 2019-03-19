//
//  XCTestCase.swift
//  LinguaDeGatoTests
//
//  Created by Kobayashi on 19/03/19.
//  Copyright © 2019 Kobayashi. All rights reserved.
//

import CoreData
import XCTest

extension XCTestCase {
    func setupCoreDataStack(with name: String, `in` bundle: Bundle) -> NSManagedObjectContext {
        
        let modelURL = bundle.url(forResource: name, withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
}
