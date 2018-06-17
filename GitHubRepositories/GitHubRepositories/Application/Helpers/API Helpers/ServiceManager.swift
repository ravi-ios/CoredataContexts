//
//  ServiceManager.swift
//  GitHubRepositories
//
//  Created by Ravi on 17/06/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import Foundation

final class ServiceManager: NSObject {
    
    class func loadRequest(_ requestUrl: URL, completion:@escaping (_ data: Data?, _ error: Error?)->()) {
       
        URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
            completion(data, error)
            }.resume()
    }
    
    class func fetchServiceData(_ pageIndex: UInt?, query: String?, completion:@escaping (_ data: [Any]?, _ error: Error?)->()) {
        
        let resource = Request(pageIndex, query: query)
        let url = resource.url
        ServiceManager.loadRequest(url) { (data, error) in
            guard let data = data else { completion(nil, error)
                return
            }
            let response = Response(data)
            completion(response.objects, nil)
        }
    }
}
