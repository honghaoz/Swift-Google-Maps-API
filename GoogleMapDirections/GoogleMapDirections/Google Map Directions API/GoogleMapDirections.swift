//
//  GoogleMapDirections.swift
//  GoogleMapDirections
//
//  Created by Honghao Zhang on 2016-01-23.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import MapKit

class GoogleMapDirections {
    static let baseURLString = "https://maps.googleapis.com/maps/api/directions/json"
    static var _APIKey: String?
    
    class func provideAPIKey(APIKey: String) {
        _APIKey = APIKey
    }
    
    private class func APIKey() -> String {
        guard let APIKey = _APIKey else {
            NSLog("Error: Please provide an API key")
            return ""
        }
        return APIKey
    }
    
    class var baseRequestParameters: [String : AnyObject] {
        return ["key" : APIKey()]
    }
    
    class func directionFromOrigin(origin: Place,
        toDestination destination: Place,
        travelMode: TravelMode = .Driving,
        wayPoints: [Place]? = nil,
        alternatives: Bool? = nil,
        avoid: [RouteRestriction]? = nil,
        language: String? = nil,
        units: Unit? = nil,
        region: String? = nil,
        arrivalTime: NSDate? = nil,
        departureTime: NSDate? = nil,
        trafficModel: TrafficMode? = nil,
        transitMode: TransitMode? = nil,
        transitRoutingPreference: TransitRoutingPreference? = nil,
        completion: ((response: Response?, error: NSError?) -> Void)? = nil)
    {
        var requestParameters = baseRequestParameters + [
            "origin" : origin.toString(),
            "destination" : destination.toString(),
            "mode" : travelMode.rawValue.lowercaseString
        ]
        
        if let wayPoints = wayPoints {
            requestParameters["waypoints"] = wayPoints.map { $0.toString() }.joinWithSeparator("|")
        }
        
        if let alternatives = alternatives {
            requestParameters["alternatives"] = String(alternatives)
        }
        
        if let avoid = avoid {
            requestParameters["avoid"] = avoid.map { $0.rawValue }.joinWithSeparator("|")
        }
        
        if let language = language {
            requestParameters["language"] = language
        }
        
        if let units = units {
            requestParameters["units"] = units.rawValue
        }
        
        if let region = region {
            requestParameters["region"] = region
        }
        
        if arrivalTime != nil && departureTime != nil {
            NSLog("Warning: You can only specify one of arrivalTime or departureTime at most, requests may failed")
        }
        
        if let arrivalTime = arrivalTime where travelMode == .Transit {
            requestParameters["arrival_time"] = Int(arrivalTime.timeIntervalSince1970)
        }
        
        if let departureTime = departureTime where travelMode == .Transit {
            requestParameters["departure_time"] = Int(departureTime.timeIntervalSince1970)
        }
        
        if let trafficModel = trafficModel {
            requestParameters["traffic_model"] = trafficModel.rawValue
        }
        
        if let transitMode = transitMode {
            requestParameters["transit_mode"] = transitMode.rawValue
        }
        
        if let transitRoutingPreference = transitRoutingPreference {
            requestParameters["transit_routing_preference"] = transitRoutingPreference.rawValue
        }
        
        let request = Alamofire.request(.GET, baseURLString, parameters: requestParameters).responseJSON { response in
            if response.result.isFailure {
                NSLog("Error: GET failed")
                completion?(response: nil, error: NSError(domain: "GoogleMapDirectionsError", code: -1, userInfo: nil))
                return
            }
            
            // Nil
            if let _ = response.result.value as? NSNull {
                completion?(response: Response(), error: nil)
                return
            }
            
            // JSON
            guard let json = response.result.value as? [String : AnyObject] else {
                NSLog("Error: Parsing json failed")
                completion?(response: nil, error: NSError(domain: "GoogleMapDirectionsError", code: -2, userInfo: nil))
                return
            }
            
            guard let directionsResponse = Mapper<Response>().map(json) else {
                NSLog("Error: Mapping directions response failed")
                completion?(response: nil, error: NSError(domain: "GoogleMapDirectionsError", code: -3, userInfo: nil))
                return
            }
            
            var error: NSError?
            
            switch directionsResponse.status {
            case .None:
                let userInfo: [NSObject : AnyObject] = [
                    NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "Status Code not found", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: "Status Code not found", comment: "")
                ]
                error = NSError(domain: "GoogleMapDirectionsError", code: -4, userInfo: userInfo)
            case .Some(let status):
                switch status {
                case .OK:
                    break
                case .NotFound:
                    let userInfo: [NSObject : AnyObject] = [
                        NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "At least one of the locations specified in the request's origin, destination, or waypoints could not be geocoded.", comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: directionsResponse.errorMessage ?? "", comment: "")
                    ]
                    error = NSError(domain: "GoogleMapDirectionsError", code: -5, userInfo: userInfo)
                case .ZeroResults:
                    let userInfo: [NSObject : AnyObject] = [
                        NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "No route could be found between the origin and destination.", comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: directionsResponse.errorMessage ?? "", comment: "")
                    ]
                    error = NSError(domain: "GoogleMapDirectionsError", code: -6, userInfo: userInfo)
                case .MaxWaypointsExceeded:
                    let userInfo: [NSObject : AnyObject] = [
                        NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "Too many waypoints were provided in the request. The maximum allowed number of waypoints is 23, plus the origin and destination. (If the request does not include an API key, the maximum allowed number of waypoints is 8.", comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: directionsResponse.errorMessage ?? "", comment: "")
                    ]
                    error = NSError(domain: "GoogleMapDirectionsError", code: -7, userInfo: userInfo)
                case .InvalidRequest:
                    let userInfo: [NSObject : AnyObject] = [
                        NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "Provided request was invalid. Common causes of this status include an invalid parameter or parameter value.", comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: directionsResponse.errorMessage ?? "", comment: "")
                    ]
                    error = NSError(domain: "GoogleMapDirectionsError", code: -8, userInfo: userInfo)
                case .OverQueryLimit:
                    let userInfo: [NSObject : AnyObject] = [
                        NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "Service has received too many requests from your application within the allowed time period.", comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: directionsResponse.errorMessage ?? "", comment: "")
                    ]
                    error = NSError(domain: "GoogleMapDirectionsError", code: -9, userInfo: userInfo)
                case .RequestDenied:
                    let userInfo: [NSObject : AnyObject] = [
                        NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "Service denied use of the directions service by your application.", comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: directionsResponse.errorMessage ?? "", comment: "")
                    ]
                    error = NSError(domain: "GoogleMapDirectionsError", code: -10, userInfo: userInfo)
                case .UnknownError:
                    let userInfo: [NSObject : AnyObject] = [
                        NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "A directions request could not be processed due to a server error. The request may succeed if you try again.", comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: directionsResponse.errorMessage ?? "", comment: "")
                    ]
                    error = NSError(domain: "GoogleMapDirectionsError", code: -11, userInfo: userInfo)
                }
            }
            
            completion?(response: directionsResponse, error: error)
        }
        
        NSLog("\(request)")
    }
}

extension GoogleMapDirections {
    class func directionFromOriginAddress(originAddress: String,
        toDestinationAddress destinationAddress: String,
        travelMode: TravelMode = .Driving,
        wayPoints: [Place]? = nil,
        alternatives: Bool? = nil,
        avoid: [RouteRestriction]? = nil,
        language: String? = nil,
        units: Unit? = nil,
        region: String? = nil,
        arrivalTime: NSDate? = nil,
        departureTime: NSDate? = nil,
        trafficModel: TrafficMode? = nil,
        transitMode: TransitMode? = nil,
        transitRoutingPreference: TransitRoutingPreference? = nil,
        completion: ((response: Response?, error: NSError?) -> Void)? = nil)
    {
        directionFromOrigin(Place.StringDescription(address: originAddress),
            toDestination: Place.StringDescription(address: destinationAddress),
            travelMode: travelMode,
            wayPoints: wayPoints,
            alternatives: alternatives,
            avoid: avoid,
            language: language,
            units: units,
            region: region,
            arrivalTime: arrivalTime,
            departureTime: departureTime,
            trafficModel: trafficModel,
            transitMode: transitMode,
            transitRoutingPreference: transitRoutingPreference,
            completion: completion)
    }
    
    class func directionFromOriginCoordinate(originCoordinate: CLLocationCoordinate2D,
        toDestinationCoordinate destinationCoordinate: CLLocationCoordinate2D,
        travelMode: TravelMode = .Driving,
        wayPoints: [Place]? = nil,
        alternatives: Bool? = nil,
        avoid: [RouteRestriction]? = nil,
        language: String? = nil,
        units: Unit? = nil,
        region: String? = nil,
        arrivalTime: NSDate? = nil,
        departureTime: NSDate? = nil,
        trafficModel: TrafficMode? = nil,
        transitMode: TransitMode? = nil,
        transitRoutingPreference: TransitRoutingPreference? = nil,
        completion: ((response: Response?, error: NSError?) -> Void)? = nil)
    {
        directionFromOrigin(Place.Coordinate(coordinate: originCoordinate),
            toDestination: Place.Coordinate(coordinate: destinationCoordinate),
            travelMode: travelMode,
            wayPoints: wayPoints,
            alternatives: alternatives,
            avoid: avoid,
            language: language,
            units: units,
            region: region,
            arrivalTime: arrivalTime,
            departureTime: departureTime,
            trafficModel: trafficModel,
            transitMode: transitMode,
            transitRoutingPreference: transitRoutingPreference,
            completion: completion)
    }
}

private func + <K, V> (left: [K : V], right: [K : V]?) -> [K : V] {
    guard let right = right else { return left }
    return left.reduce(right) {
        var new = $0 as [K : V]
        new.updateValue($1.1, forKey: $1.0)
        return new
    }
}

private func += <K, V> (inout left: [K : V], right: [K : V]){
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}
