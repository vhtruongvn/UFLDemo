//
//  APIServiceTests.swift
//  UFLDemoTests
//
//  Created by Truong Vo on 1/7/18.
//  Copyright © 2018 Truong Vo. All rights reserved.
//

import XCTest
@testable import UFLDemo

class APIServiceTests: XCTestCase {
    
    var sut: APIService?
    
    override func setUp() {
        super.setUp()
        sut = APIService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_fetch_fixtures() {
        // Given A apiservice
        let sut = self.sut!
        
        // When fetch fixtures
        let expect = XCTestExpectation(description: "callback")
        
        sut.fetchAllFixtures(complete: { (success, fixtures, error) in
            expect.fulfill()
            XCTAssertEqual( fixtures.count, 1)
            for fixture in fixtures {
                XCTAssertNotNil(fixture.id)
            }
            
        })
        
        wait(for: [expect], timeout: 3.1)
    }
    
}
