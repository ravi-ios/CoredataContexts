//
//  CoreDataManager.swift
//  GitHubRepositories
//
//  Created by Ravi on 17/06/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    let dataModuleName = "RepositoryInfo"
    
    static let shared = CoreDataManager()
    
    private override init() {
        super.init()
    }
    
    /*
     * .Application's documents directory
     */
    fileprivate lazy var documentsDirectoryUrl: URL = {
        let directoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return directoryUrl!
    }()
    
    fileprivate lazy var managedObjectModel: NSManagedObjectModel = {
        let url = Bundle.main.url(forResource: dataModuleName, withExtension: "momd")
        let objectModel = NSManagedObjectModel.init(contentsOf: url!)
        return objectModel!
    }()
    
    /*
     * .NSPersistentStoreCoordinator with NSManagedObjectModel -
     * .SQLite as persistent store
     */
    fileprivate lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator.init(managedObjectModel: CoreDataManager.shared.managedObjectModel)
        
        // Choosing SQLite as my persistent store
        let storeUrl = CoreDataManager.shared.documentsDirectoryUrl.appendingPathComponent(
            "\(dataModuleName).sqlite")
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: nil)
        } catch let error {
            fatalError("persistentStoreCoordinator error: \(error)")
        }
        
        return coordinator
    }()
    
    /*
     * .NSManagedObjectContext of type privateQueueConcurrencyType
     * .This context is used for back-end data operations
     * .In This way we can avoid writing database operation in main thread
     */
    fileprivate lazy var privateQueueManagedObjectContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = CoreDataManager.shared.persistentStoreCoordinator
        return context
    }()
    
    /*
     * .NSManagedObjectContext of type mainQueueConcurrencyType inherited from privateQueueManagedObjectContext
     * .This context is used for UI updates
     * .In This way we can achieve smooth user experince
     */
    lazy var managedObjectContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        context.parent = CoreDataManager.shared.privateQueueManagedObjectContext
        // Get the parent context changes automatically to update UI
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    /*
     * .Save context in privateQueueManagedObjectContext
     * We are not manupulating data on main context so no need to save managedObjectContext
     */
    func saveContext() {
        guard self.privateQueueManagedObjectContext.hasChanges else {
            return
        }
        
        CoreDataManager.shared.privateQueueManagedObjectContext.perform {
            do {
                try CoreDataManager.shared.privateQueueManagedObjectContext.save()
            } catch let error {
                fatalError("saveContext error: \(error.localizedDescription)")
            }
        }
    }
    
    func createManagedObject(forentity entityName:String) -> NSManagedObject? {
        let privateQueueContext = CoreDataManager.shared.privateQueueManagedObjectContext
        let entity =  NSEntityDescription.insertNewObject(forEntityName: entityName, into: privateQueueContext)
        return entity
    }
    
    /*
     * .Fetch entity with entity name and predicate based on our requirement
     */
    func fetchEntity(_ entityName:String, predicate:NSPredicate?) -> [Repository]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        request.includesSubentities = false
        
        do {
            return try CoreDataManager.shared.managedObjectContext.fetch(request) as? [Repository]
        } catch let error {
            fatalError("Error while fetching dat: \(error.localizedDescription)")
        }
        return nil
    }
    
    /*
     * .Delete entity with entity name
     */
    func deleteEntity(_ entityName: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchRequest = NSBatchDeleteRequest(fetchRequest: request )
        batchRequest.resultType = .resultTypeStatusOnly
        do {
            try CoreDataManager.shared.privateQueueManagedObjectContext.execute(batchRequest)
            
            CoreDataManager.shared.privateQueueManagedObjectContext.reset()
        } catch let error {
            fatalError("Error while deleting entity: \(error.localizedDescription)")
        }
    }
    
    /*
     * .Delete every entity
     */
    func deleteAll() {
        CoreDataManager.shared.deleteEntity(Repository.entityName)
        CoreDataManager.shared.deleteEntity(Owner.entityName)
    }
}
