//
//  Owner+CoreDataClass.swift
//  GitHubRepositories
//
//  Created by Ravi on 17/06/18.
//  Copyright © 2018 Ravi. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Owner)
public class Owner: NSManagedObject {
    
    static let entityName = "Owner"
    
    fileprivate let kId   = "id"
    fileprivate let kName = "login"
    
    func configureWith(_ dictionary: JSONObject?) {
        guard let data = dictionary else { return }
        if let id = data[kId] as? Int64 {
            self.id = id
        }
        if let name = data[kName] as? String {
            self.name = name
        }
    }
}
