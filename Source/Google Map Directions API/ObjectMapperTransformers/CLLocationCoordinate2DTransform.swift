//
//  CLLocationCoordinate2DTransform.swift
//  GoogleMapDirections
//
//  Created by Honghao Zhang on 2016-01-23.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import Foundation
import ObjectMapper
import MapKit

class CLLocationCoordinate2DTransform: TransformType {
    typealias Object = CLLocationCoordinate2D
    typealias JSON = [String : AnyObject]
    
    func transformFromJSON(value: AnyObject?) -> Object? {
        if let value = value as? JSON {
            guard let latitude = value["lat"] as? Double, let longitude = value["lng"] as? Double else {
                NSLog("Error: lat/lng is not Double")
                return nil
            }
            
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return nil
    }
    
    func transformToJSON(value: Object?) -> JSON? {
        if let value = value {
            return [
                "lat" : "\(value.latitude)",
                "lng" : "\(value.longitude)"
            ]
        }
        return nil
    }
}
