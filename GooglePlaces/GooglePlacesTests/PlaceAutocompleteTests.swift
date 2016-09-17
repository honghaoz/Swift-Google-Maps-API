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
        GooglePlaces.provide(apiKey: "AIzaSyDftpY3fi6x_TL4rntL8pgZb-A8mf6D0Ss")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAPIIsInvalid() {
        let expectation = self.expectation(description: "results")
        GooglePlaces.provide(apiKey: "fake_key")
        
        GooglePlaces.placeAutocomplete(forInput: "Pub") { (response, error) -> Void in
            XCTAssertNotNil(error)
            XCTAssertNotNil(response)
            XCTAssertNotNil(response?.errorMessage)
            XCTAssertEqual(response?.status, GooglePlaces.StatusCode.RequestDenied)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testAPIIsValid() {
        let expectation = self.expectation(description: "results")
        
        GooglePlaces.placeAutocomplete(forInput: "Pub") { (response, error) -> Void in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertEqual(response?.status, GooglePlaces.StatusCode.OK)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testResultsReturned() {
        let expectation = self.expectation(description: "It has at least one result returned for `pub`")
        
        GooglePlaces.placeAutocomplete(forInput: "pub") { (response, error) -> Void in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertEqual(response!.status, GooglePlaces.StatusCode.OK)
            XCTAssertTrue(response!.predictions.count > 0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testResultsMatchedSubstrings() {
        let expectation = self.expectation(description: "It has at least one result returned for `pub`")
        
        let query = "Pub"
        
        GooglePlaces.placeAutocomplete(forInput: query, locationCoordinate: LocationCoordinate2D(latitude: 43.4697354, longitude: -80.5397377), radius: 10000) { (response, error) -> Void in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertEqual(response!.status, GooglePlaces.StatusCode.OK)
            XCTAssertTrue(response!.predictions.count > 0)
            
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
				
				let start = description.index(description.startIndex, offsetBy: offset)
				let end = description.index(description.startIndex, offsetBy: offset + length)
				let substring = description.substring(with: start ..< end)
				
                XCTAssertEqual(substring.lowercased(), query.lowercased())
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
