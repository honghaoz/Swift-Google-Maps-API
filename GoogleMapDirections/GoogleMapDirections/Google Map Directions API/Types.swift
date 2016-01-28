//
//  Types.swift
//  GoogleMapDirections
//
//  Created by Honghao Zhang on 2016-01-23.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import Foundation
import MapKit

// MARK: - Place
extension GoogleMapDirections {
    /**
     This struct represents a place/address/location, used in Google Map Directions API
     Reference: https://developers.google.com/maps/documentation/directions/intro#RequestParameters
     - StringDescription: Address as a string
     - Coordinate:        Coordinate
     - PlaceID:           Place id from Google Map API
     */
    enum Place {
        case StringDescription(address: String)
        case Coordinate(coordinate: CLLocationCoordinate2D)
        case PlaceID(id: String)
        
        func toString() -> String {
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
