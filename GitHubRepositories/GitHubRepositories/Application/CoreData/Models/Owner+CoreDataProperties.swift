//
//  Owner+CoreDataProperties.swift
//  GitHubRepositories
//
//  Created by Ravi on 17/06/18.
//  Copyright © 2018 Ravi. All rights reserved.
//
//

import Foundation
import CoreData


extension Owner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Owner> {
        return NSFetchRequest<Owner>(entityName: "Owner")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var repositories: NSSet?

}

// MARK: Generated accessors for repositories
extension Owner {

    @objc(addRepositoriesObject:)
    @NSManaged public func addToRepositories(_ value: Repository)

    @objc(removeRepositoriesObject:)
    @NSManaged public func removeFromRepositories(_ value: Repository)

    @objc(addRepositories:)
    @NSManaged public func addToRepositories(_ values: NSSet)

    @objc(removeRepositories:)
    @NSManaged public func removeFromRepositories(_ values: NSSet)

}
