//
//  PlaceAutocompleteTests.swift
//  GooglePlacesTests
//
//  Created by Honghao Zhang on 2016-02-12.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import XCTest
@testable import GooglePlaces

class PlaceAutocompleteTests: XCTestCase {
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
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testResultsReturned() {
        let expectation = self.expectationWithDescription("It has at least one result returned for `pub`")
        
        GooglePlaces.placeAutocomplete(forInput: "pub") { (response, error) -> Void in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertEqual(response?.status, GooglePlaces.StatusCode.OK)
            XCTAssertTrue(response?.predictions.count > 0)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testResultsMatchedSubstrings() {
        let expectation = self.expectationWithDescription("It has at least one result returned for `pub`")
        
        let query = "Pub"
        
        GooglePlaces.placeAutocomplete(forInput: query, locationCoordinate: LocationCoordinate2D(latitude: 43.4697354, longitude: -80.5397377), radius: 10000) { (response, error) -> Void in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertEqual(response?.status, GooglePlaces.StatusCode.OK)
            XCTAssertTrue(response?.predictions.count > 0)
            
            guard let predictions = response?.predictions else {
                XCTAssert(false, "prediction is nil")
                return
            }
            
            for prediction in predictions {
                XCTAssertEqual(prediction.matchedSubstring[0].length, query.characters.count)
                
                guard let description = prediction.description,
                    let length = prediction.matchedSubstring[0].length,
                    let offset = prediction.matchedSubstring[0].offset else {
                        XCTAssert(false, "length/offset is nil")
                        return
                }
                
                let substring = description.substringWithRange(Range<String.Index>(start: description.startIndex.advancedBy(offset), end: description.startIndex.advancedBy(offset + length)))
                XCTAssertEqual(substring.lowercaseString, query.lowercaseString)
            }
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
}
