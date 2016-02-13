//
//  GooglePlacesTests.swift
//  GooglePlacesTests
//
//  Created by Honghao Zhang on 2016-02-12.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import XCTest
import MapKit
@testable import GooglePlaces

class GooglePlacesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        GooglePlaces.provideAPIKey("AIzaSyDftpY3fi6x_TL4rntL8pgZb-A8mf6D0Ss")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAPIIsInvalid() {
        let expectation = self.expectationWithDescription("results")
        GooglePlaces.provideAPIKey("fake_key")
        
        GooglePlaces.placeAutocomplete(forInput: "Pub") { (response, error) -> Void in
            XCTAssertNotNil(error)
            XCTAssertNotNil(response)
            XCTAssertNotNil(response?.errorMessage)
            XCTAssertEqual(response?.status, GooglePlaces.StatusCode.RequestDenied)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testAPIIsValid() {
        let expectation = self.expectationWithDescription("results")
        
        GooglePlaces.placeAutocomplete(forInput: "Pub") { (response, error) -> Void in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertEqual(response?.status, GooglePlaces.StatusCode.OK)
//            XCTAssertEqual(response?.geocodedWaypoints.count, 2)
//            XCTAssertEqual(response?.routes.count, 1)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
}
