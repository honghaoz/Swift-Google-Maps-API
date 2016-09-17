//
//  SharedTypes.swift
//  GoogleMapsDirections
//
//  Created by Honghao Zhang on 2016-02-12.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import Foundation
import ObjectMapper

public extension GoogleMapsService {
    /// The status field within the Directions response object contains the status of the request,
    /// and may contain debugging information to help you track down why the Directions service failed.
    /// Reference: https://developers.google.com/maps/documentation/directions/intro#StatusCodes
    ///
    /// - ok:                   The response contains a valid result.
    /// - notFound:             At least one of the locations specified in the request's origin, destination, or waypoints could not be geocoded.
    /// - zeroResults:          No route could be found between the origin and destination.
    /// - maxWaypointsExceeded: Too many waypoints were provided in the request.
    /// - invalidRequest:       The provided request was invalid.
    /// - overQueryLimit:       The service has received too many requests from your application within the allowed time period.
    /// - requestDenied:        The service denied use of the directions service by your application.
    /// - unknownError:         Directions request could not be processed due to a server error.
    public enum StatusCode: String {
        case ok = "OK"
        case notFound = "NOT_FOUND"
        case zeroResults = "ZERO_RESULTS"
        case maxWaypointsExceeded = "MAX_WAYPOINTS_EXCEEDED"
        case invalidRequest = "INVALID_REQUEST"
        case overQueryLimit = "OVER_QUERY_LIMIT"
        case requestDenied = "REQUEST_DENIED"
        case unknownError = "UNKNOWN_ERROR"
    }
}


// MARK: - Place
public extension GoogleMapsService {
    public typealias LocationDegrees = Double
    public struct LocationCoordinate2D {
        public var latitude: LocationDegrees
        public var longitude: LocationDegrees
        
        public init(latitude: LocationDegrees, longitude: LocationDegrees) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }
    
    /// This struct represents a place/address/location, used in Google Map Directions API
    /// Reference: https://developers.google.com/maps/documentation/directions/intro#RequestParameters
    ///
    /// - stringDescription: Address as a string
    /// - coordinate:        Coordinate
    /// - placeID:           Place id from Google Map API
    public enum Place {
        case stringDescription(address: String)
        case coordinate(coordinate: LocationCoordinate2D)
        case placeID(id: String)
        
        public func toString() -> String {
            switch self {
            case .stringDescription(let address):
                return address
            case .coordinate(let coordinate):
                return "\(coordinate.latitude),\(coordinate.longitude)"
            case .placeID(let id):
                return "place_id:\(id)"
            }
        }
    }
}
