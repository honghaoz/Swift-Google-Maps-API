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
    /**
     The status field within the Directions response object contains the status of the request,
     and may contain debugging information to help you track down why the Directions service failed.
     Reference: https://developers.google.com/maps/documentation/directions/intro#StatusCodes
     
     - OK:                   The response contains a valid result.
     - NotFound:             At least one of the locations specified in the request's origin, destination, or waypoints could not be geocoded.
     - ZeroResults:          No route could be found between the origin and destination.
     - MaxWaypointsExceeded: Too many waypoints were provided in the request.
     - InvalidRequest:       The provided request was invalid.
     - OverQueryLimit:       The service has received too many requests from your application within the allowed time period.
     - RequestDenied:        The service denied use of the directions service by your application.
     - UnknownError:         Directions request could not be processed due to a server error.
     */
    public enum StatusCode: String {
        case OK = "OK"
        case NotFound = "NOT_FOUND"
        case ZeroResults = "ZERO_RESULTS"
        case MaxWaypointsExceeded = "MAX_WAYPOINTS_EXCEEDED"
        case InvalidRequest = "INVALID_REQUEST"
        case OverQueryLimit = "OVER_QUERY_LIMIT"
        case RequestDenied = "REQUEST_DENIED"
        case UnknownError = "UNKNOWN_ERROR"
    }
}


// MARK: - Place
extension GoogleMapsService {
    public typealias LocationDegrees = Double
    public struct LocationCoordinate2D {
        public var latitude: LocationDegrees
        public var longitude: LocationDegrees
        
        public init(latitude: LocationDegrees, longitude: LocationDegrees) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }
    
    /**
     This struct represents a place/address/location, used in Google Map Directions API
     Reference: https://developers.google.com/maps/documentation/directions/intro#RequestParameters
     - StringDescription: Address as a string
     - Coordinate:        Coordinate
     - PlaceID:           Place id from Google Map API
     */
    public enum Place {
        case StringDescription(address: String)
        case Coordinate(coordinate: LocationCoordinate2D)
        case PlaceID(id: String)
        
        public func toString() -> String {
            switch self {
            case .StringDescription(let address):
                return address
            case .Coordinate(let coordinate):
                return "\(coordinate.latitude),\(coordinate.longitude)"
            case .PlaceID(let id):
                return "place_id:\(id)"
            }
        }
    }
}
