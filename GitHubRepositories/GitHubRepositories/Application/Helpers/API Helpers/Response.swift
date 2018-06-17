//
//  Response.swift
//  GitHubRepositories
//
//  Created by Ravi on 17/06/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import Foundation

typealias JSONObject = [String: Any]

struct Response {
    
    fileprivate static let kItems = "items"
    var error: Error?
    var objects: [JSONObject] = [JSONObject]()
}

extension Response {
    
    init(_ data: Data?) {
        guard let data = data else {
            return
        }
        
        do {
            guard let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? JSONObject,
                let items = jsonData[Response.kItems] as? [JSONObject] else { return }
            
            objects.removeAll()
            objects.append(contentsOf: items)
        } catch let error {
            self.error = error
            fatalError("Parsing Error: \(error.localizedDescription)")
        }
    }
}
