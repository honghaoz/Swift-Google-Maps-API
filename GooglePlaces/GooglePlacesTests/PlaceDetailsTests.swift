//
//  PlaceDetailsTests.swift
//  GooglePlaces
//
//  Created by Honghao Zhang on 2016-02-20.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import XCTest
@testable import GooglePlaces

class PlaceDetailsTests: XCTestCase {
    typealias LocationCoordinate2D = GoogleMapsService.LocationCoordinate2D
    
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
        
        GooglePlaces.placeDetails(forPlaceID: "") { (response, error) -> Void in
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
        
        GooglePlaces.placeDetails(forPlaceID: "ChIJb9sw59k0K4gRZZlYrnOomfc") { (response, error) -> Void in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertEqual(response?.result?.placeID , "ChIJb9sw59k0K4gRZZlYrnOomfc")
            XCTAssertEqual(response?.status, GooglePlaces.StatusCode.OK)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
}
