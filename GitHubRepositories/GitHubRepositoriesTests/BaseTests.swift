//
//  BaseTests.swift
//  GitHubRepositoriesTests
//
//  Created by Ravi on 17/06/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import XCTest

@testable import GitHubRepositories

class BaseTests: XCTestCase {
    
    var fileUrl: URL?
    var jsonObjects: [JSONObject]?
    
    override func setUp() {
        super.setUp()
        fileUrl = Bundle(for: type(of: self)).url(forResource: "Sample", withExtension: "json")
        
        // Respective test cases will ececute on their own test classes
        // That is why I am just force unwrapping
        let data = try? Data(contentsOf: fileUrl!)
        let response = Response(data)
        jsonObjects = response.objects
    }
    
    func testFieExistance() {
        guard let url = self.fileUrl, let _ = try? Data(contentsOf: url) else {
            XCTFail("data should exist for contents of url")
            return
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPerformanceExample() {
        self.measure {
        }
    }
    
}
