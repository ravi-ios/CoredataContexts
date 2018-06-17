//
//  Request.swift
//  GitHubRepositories
//
//  Created by Ravi on 17/06/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import Foundation

struct Request {
    
    /*
     * Sample API
     * https://api.github.com/search/repositories?q=tetris&page=2&per_page=10
     */
    
    fileprivate static let baseUrl = "https://api.github.com/"
    fileprivate static let servicePath = "search/repositories"
    
    fileprivate static let kQuery = "q"
    fileprivate static let kPageIndex = "page"
    fileprivate static let kResultsPerPage   = "per_page"
    
    fileprivate let resultsPerPage = 10
    fileprivate var pageIndex: UInt
    fileprivate var query: String
    
    var url: URL {
        get {
            let urlString = Request.baseUrl + Request.servicePath + "?"
                + Request.kPageIndex + "=" + "\(pageIndex)"
                + "&" + Request.kResultsPerPage + "=" + "\(resultsPerPage)"
                + "&" + Request.kQuery + "=" + query
            return URL(string: urlString)!
        }
    }
}

extension Request {
    init(_ pageIndex: UInt?, query: String?) {
        self.query = (query?.count ?? 0 == 0) ? "tetris" : query!
        self.pageIndex = pageIndex ?? 0
    }
}
