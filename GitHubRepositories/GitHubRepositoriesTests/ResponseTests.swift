//
//  ResponseTests.swift
//  GitHubRepositoriesTests
//
//  Created by Ravi on 17/06/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import XCTest
@testable import GitHubRepositories

class ResponseTests: BaseTests {
    

    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    override func testPerformanceExample() {
        self.measure {
        }
    }
    
    func testResponse() {
        guard let url = self.fileUrl, let data = try? Data(contentsOf: url) else {
            XCTFail("data should exist for contents of url")
            return
        }
        
        let response = Response.init(data)
        
        XCTAssertNil(response.error, "Error should not exist")
        
        XCTAssertEqual(response.objects.count, 30, "Repo count should be 30")
    }
}
