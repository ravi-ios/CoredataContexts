//
//  Repository+CoreDataClass.swift
//  GitHubRepositories
//
//  Created by Ravi on 17/06/18.
//  Copyright © 2018 Ravi. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Repository)
public class Repository: NSManagedObject {
    
    static let entityName = "Repository"
    
    static let kId      = "id"
    fileprivate let kName    = "name"
    fileprivate let kSize    = "size"
    fileprivate let khasWiki = "has_wiki"
    fileprivate let kOwner   = "owner"
    
    func configureWith(_ dictionary: JSONObject?) {
        
        guard let data = dictionary else {return}
        if let id = data[Repository.kId] as? Int64 {
            self.id = id
        }
        
        if let name = data[kName] as? String {
            self.name = name
        }
        
        if let size = data[kSize] as? Int64 {
            self.size = size
        }
        
        if let hasWiki = data[khasWiki] as? Bool {
            self.hasWiki = hasWiki
        }
        
        if let dict = data[kOwner] as? JSONObject {
            if let owner = CoreDataManager.shared.createManagedObject(forentity: Owner.entityName) as? Owner {
                owner.configureWith(dict)
                self.owner = owner
            }
        }
        
        if self.size > 0 {
            // bandwidth:𝐵 𝑡 =10000 bits/s∙ (1−𝑒^(-t/3))
            self.estimatedDownloadTime = (size * 8 * 1024)/10000
        }
        
        self.date = Date() as NSDate
    }
}
