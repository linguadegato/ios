//
//  StorageTests.swift
//  Lingua_de_GatoTests
//
//  Created by Kobayashi on 19/03/19.
//  Copyright © 2019 Kobayashi. All rights reserved.
//

import XCTest
import CoreData
@testable import Lingua_de_Gato_Debug

class StorageTests: XCTestCase {
    private var managedObjectContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        managedObjectContext = setupCoreDataStack(with: "LinguaDeGato", in: Bundle.main)
    }

    override func tearDown() {
        super.tearDown()
        managedObjectContext = nil
    }

}
