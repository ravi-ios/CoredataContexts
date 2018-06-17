//
//  RequestTests.swift
//  GitHubRepositoriesTests
//
//  Created by Ravi on 17/06/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import XCTest
@testable import GitHubRepositories

class RequestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPerformanceExample() {
        self.measure {
        }
    }
    
    func testRequestUrl() {
        let pageIndex: UInt = 0
        let query: String = "iOS"
        let request = Request.init(pageIndex, query: query)
        
        XCTAssertNotNil(request.url, "URL should not be nil")
        
        let urlString = request.url.absoluteString
        
        let validUrlString = "https://api.github.com/search/repositories?page=\(pageIndex)&per_page=10&q=\(query)"
        
        XCTAssertEqual(urlString, validUrlString, "Incorrect service with path")
    }
    
    func testResourceUrlWithEmptyQuery() {
        let pageIndex: UInt = 0
        let query: String = ""
        let request = Request(pageIndex, query: query)
        
        XCTAssertNotNil(request.url, "URL should not be nil")
        
        let urlString = request.url.absoluteString
        
        let validUrlString = "https://api.github.com/search/repositories?page=\(pageIndex)&per_page=10&q=tetris"
        
        XCTAssertEqual(urlString, validUrlString, "Incorrect service with path")
    }
    
}
