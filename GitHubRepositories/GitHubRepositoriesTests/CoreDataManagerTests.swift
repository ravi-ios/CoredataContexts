//
//  CoreDataManagerTests.swift
//  GitHubRepositoriesTests
//
//  Created by Ravi on 17/06/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import XCTest
@testable import GitHubRepositories
class CoreDataManagerTests: BaseTests {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    override func testPerformanceExample() {
        self.measure {
        }
    }
    
    func testDatabaseSaving() {
        let object = self.jsonObjects?.last!
        
        let entity = CoreDataManager.shared.createManagedObject(forentity: Repository.entityName) as? Repository
        
        XCTAssertNotNil(entity, "Failed to create new entity")

        entity!.configureWith(object)
        CoreDataManager.shared.saveContext()
        
        let predicate = NSPredicate.init(format: "id == %ld", entity!.id as CVarArg)
        
        let savedEntity = CoreDataManager.shared.fetchEntity(Repository.entityName, predicate: predicate)?.first
        
        XCTAssertNotNil(savedEntity, "Failed to save created entity")
        
        XCTAssertEqual(savedEntity?.name, entity?.name, "Data not saved correctly")
    }
    
}
