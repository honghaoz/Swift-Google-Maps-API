//
//  GoogleMapsDirectionsTests.swift
//  GoogleMapsDirectionsTests
//
//  Created by Honghao Zhang on 2016-01-27.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import XCTest
@testable import GoogleMapsDirections

class GoogleMapsDirectionsTests: XCTestCase {
    typealias Place = GoogleMapsDirections.Place
    typealias LocationCoordinate2D = GoogleMapsService.LocationCoordinate2D
    
    let DCInStringDescription = Place.StringDescription(address: "Davis Center, Waterloo, Canada")
    let DCInPostalCode = Place.StringDescription(address: "N2L 3G1, Canada")
    let DCInCoordinate = Place.Coordinate(coordinate: LocationCoordinate2D(latitude: 43.4697354, longitude: -80.5397377))
    let CMallInStringDescription = Place.StringDescription(address: "Conestoga Mall, Waterloo, Canada")
    let CMallInPostalCode = Place.StringDescription(address: "N2L 5W6, Waterloo, Canada")
    
    override func setUp() {
        super.setUp()
        GoogleMapsDirections.provideAPIKey("AIzaSyDftpY3fi6x_TL4rntL8pgZb-A8mf6D0Ss")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAPIIsInvalid() {
        let expectation = self.expectationWithDescription("Direcion from origin to destination")
        GoogleMapsDirections.provideAPIKey("fake_key")
        
        GoogleMapsDirections.direction(fromOrigin: DCInStringDescription, toDestination: CMallInStringDescription) { (response, error) -> Void in
            XCTAssertNotNil(error)
            XCTAssertNotNil(response)
            XCTAssertNotNil(response?.errorMessage)
            XCTAssertEqual(response?.status, GoogleMapsDirections.StatusCode.RequestDenied)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testAPIIsValid() {
        let expectation = self.expectationWithDescription("Direcion from origin to destination")
        
        GoogleMapsDirections.direction(fromOrigin: DCInPostalCode, toDestination: CMallInPostalCode) { (response, error) -> Void in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertEqual(response?.status, GoogleMapsDirections.StatusCode.OK)
            XCTAssertEqual(response?.geocodedWaypoints.count, 2)
            XCTAssertEqual(response?.routes.count, 1)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testAlternatives() {
        let expectation = self.expectationWithDescription("When alternatives if true, more than one routes returned")
        
        GoogleMapsDirections.direction(fromOrigin: DCInPostalCode, toDestination: CMallInPostalCode, alternatives: true) { (response, error) -> Void in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertEqual(response?.status, GoogleMapsDirections.StatusCode.OK)
            XCTAssertTrue(response?.routes.count > 1)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
}
