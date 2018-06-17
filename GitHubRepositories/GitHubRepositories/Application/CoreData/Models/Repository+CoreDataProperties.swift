//
//  Repository+CoreDataProperties.swift
//  GitHubRepositories
//
//  Created by Ravi on 17/06/18.
//  Copyright © 2018 Ravi. All rights reserved.
//
//

import Foundation
import CoreData


extension Repository {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Repository> {
        return NSFetchRequest<Repository>(entityName: "Repository")
    }

    @NSManaged public var id: Int64
    @NSManaged public var date: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var hasWiki: Bool
    @NSManaged public var estimatedDownloadTime: Int64
    @NSManaged public var size: Int64
    @NSManaged public var owener: Owner?

}
