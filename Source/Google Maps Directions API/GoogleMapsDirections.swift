//
//  GoogleMapsDirections.swift
//  GoogleMapsDirections
//
//  Created by Honghao Zhang on 2016-01-23.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

// Documentations: https://developers.google.com/maps/documentation/directions/

public class GoogleMapsDirections: GoogleMapsService {

    public static let baseURLString = "https://maps.googleapis.com/maps/api/directions/json"
    
    /**
     Request to Google Directions API
     Documentations: https://developers.google.com/maps/documentation/directions/intro#RequestParameters
     
     - parameter origin:                   The address, textual latitude/longitude value, or place ID from which you wish to calculate directions.
     - parameter destination:              The address, textual latitude/longitude value, or place ID to which you wish to calculate directions.
     - parameter travelMode:               Mode of transport to use when calculating directions.
     - parameter wayPoints:                Specifies an array of waypoints. Waypoints alter a route by routing it through the specified location(s).
     - parameter alternatives:             If set to true, specifies that the Directions service may provide more than one route alternative in the response. Note that providing route alternatives may increase the response time from the server.
     - parameter avoid:                    Indicates that the calculated route(s) should avoid the indicated features.
     - parameter language:                 Specifies the language in which to return results. See https://developers.google.com/maps/faq#languagesupport.
     - parameter units:                    Specifies the unit system to use when displaying results.
     - parameter region:                   Specifies the region code, specified as a ccTLD ("top-level domain") two-character value.
     - parameter arrivalTime:              Specifies the desired time of arrival for transit directions
     - parameter departureTime:            Specifies the desired time of departure.
     - parameter trafficModel:             Specifies the assumptions to use when calculating time in traffic. (defaults to best_guess)
     - parameter transitMode:              Specifies one or more preferred modes of transit.
     - parameter transitRoutingPreference: Specifies preferences for transit routes.
     - parameter completion:               API responses completion block
     */
    open class func direction(fromOrigin origin: Place,
        toDestination destination: Place,
        travelMode: TravelMode = .driving,
        wayPoints: [Place]? = nil,
        alternatives: Bool? = nil,
        avoid: [RouteRestriction]? = nil,
        language: String? = nil,
        units: Unit? = nil,
        region: String? = nil,
        arrivalTime: Date? = nil,
        departureTime: Date? = nil,
        trafficModel: TrafficMode? = nil,
        transitMode: TransitMode? = nil,
        transitRoutingPreference: TransitRoutingPreference? = nil,
        completion: ((_ response: Response?, _ error: NSError?) -> Void)? = nil)
    {
        var requestParameters: [String : Any] = baseRequestParameters + [
            "origin" : origin.toString(),
            "destination" : destination.toString(),
            "mode" : travelMode.rawValue.lowercased()
        ]
        
        if let wayPoints = wayPoints {
            requestParameters["waypoints"] = wayPoints.map { $0.toString() }.joined(separator: "|")
        }
        
        if let alternatives = alternatives {
            requestParameters["alternatives"] = String(alternatives)
        }
        
        if let avoid = avoid {
            requestParameters["avoid"] = avoid.map { $0.rawValue }.joined(separator: "|")
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
        
        if let arrivalTime = arrivalTime, (travelMode == .transit || travelMode == .driving) {
            requestParameters["arrival_time"] = Int(arrivalTime.timeIntervalSince1970)
        }
        
        if let departureTime = departureTime, (travelMode == .transit || travelMode == .driving) {
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
        
        let request = Alamofire.request(baseURLString, method: .get, parameters: requestParameters).responseJSON { response in
            if response.result.isFailure {
                NSLog("Error: GET failed")
                completion?(nil, NSError(domain: "GoogleMapsDirectionsError", code: -1, userInfo: nil))
                return
            }
            
            // Nil
            if let _ = response.result.value as? NSNull {
                completion?(Response(), nil)
                return
            }
            
            // JSON
            guard let json = response.result.value as? [String : AnyObject] else {
                NSLog("Error: Parsing json failed")
                completion?(nil, NSError(domain: "GoogleMapsDirectionsError", code: -2, userInfo: nil))
                return
            }
            
            guard let directionsResponse = Mapper<Response>().map(JSON: json) else {
                NSLog("Error: Mapping directions response failed")
                completion?(nil, NSError(domain: "GoogleMapsDirectionsError", code: -3, userInfo: nil))
                return
            }
            
            var error: NSError?
            
            switch directionsResponse.status {
            case .none:
                let userInfo: [AnyHashable: Any] = [
                    NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "Status Code not found", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: "Status Code not found", comment: "")
                ]
                error = NSError(domain: "GoogleMapsDirectionsError", code: -4, userInfo: userInfo)
            case .some(let status):
                switch status {
                case .ok:
                    break
                case .notFound:
                    let userInfo: [AnyHashable: Any] = [
                        NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "At least one of the locations specified in the request's origin, destination, or waypoints could not be geocoded.", comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: directionsResponse.errorMessage ?? "", comment: "")
                    ]
                    error = NSError(domain: "GoogleMapsDirectionsError", code: -5, userInfo: userInfo)
                case .zeroResults:
                    let userInfo: [AnyHashable: Any] = [
                        NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "No route could be found between the origin and destination.", comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: directionsResponse.errorMessage ?? "", comment: "")
                    ]
                    error = NSError(domain: "GoogleMapsDirectionsError", code: -6, userInfo: userInfo)
                case .maxWaypointsExceeded:
                    let userInfo: [AnyHashable: Any] = [
                        NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "Too many waypoints were provided in the request. The maximum allowed number of waypoints is 23, plus the origin and destination. (If the request does not include an API key, the maximum allowed number of waypoints is 8.", comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: directionsResponse.errorMessage ?? "", comment: "")
                    ]
                    error = NSError(domain: "GoogleMapsDirectionsError", code: -7, userInfo: userInfo)
                case .invalidRequest:
                    let userInfo: [AnyHashable: Any] = [
                        NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "Provided request was invalid. Common causes of this status include an invalid parameter or parameter value.", comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: directionsResponse.errorMessage ?? "", comment: "")
                    ]
                    error = NSError(domain: "GoogleMapsDirectionsError", code: -8, userInfo: userInfo)
                case .overQueryLimit:
                    let userInfo: [AnyHashable: Any] = [
                        NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "Service has received too many requests from your application within the allowed time period.", comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: directionsResponse.errorMessage ?? "", comment: "")
                    ]
                    error = NSError(domain: "GoogleMapsDirectionsError", code: -9, userInfo: userInfo)
                case .requestDenied:
                    let userInfo: [AnyHashable: Any] = [
                        NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "Service denied use of the directions service by your application.", comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: directionsResponse.errorMessage ?? "", comment: "")
                    ]
                    error = NSError(domain: "GoogleMapsDirectionsError", code: -10, userInfo: userInfo)
                case .unknownError:
                    let userInfo: [AnyHashable: Any] = [
                        NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "A directions request could not be processed due to a server error. The request may succeed if you try again.", comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: directionsResponse.errorMessage ?? "", comment: "")
                    ]
                    error = NSError(domain: "GoogleMapsDirectionsError", code: -11, userInfo: userInfo)
                }
            }
            
            completion?(directionsResponse, error)
        }
        
        debugPrint("\(request)")
    }
}

extension GoogleMapsDirections {
     /**
     Request to Google Directions API, with address description strings
     Documentations: https://developers.google.com/maps/documentation/directions/intro#RequestParameters
     
     - parameter originAddress:            The address description from which you wish to calculate directions.
     - parameter destinationAddress:       The address description to which you wish to calculate directions.
     - parameter travelMode:               Mode of transport to use when calculating directions.
     - parameter wayPoints:                Specifies an array of waypoints. Waypoints alter a route by routing it through the specified location(s).
     - parameter alternatives:             If set to true, specifies that the Directions service may provide more than one route alternative in the response. Note that providing route alternatives may increase the response time from the server.
     - parameter avoid:                    Indicates that the calculated route(s) should avoid the indicated features.
     - parameter language:                 Specifies the language in which to return results. See https://developers.google.com/maps/faq#languagesupport.
     - parameter units:                    Specifies the unit system to use when displaying results.
     - parameter region:                   Specifies the region code, specified as a ccTLD ("top-level domain") two-character value.
     - parameter arrivalTime:              Specifies the desired time of arrival for transit directions
     - parameter departureTime:            Specifies the desired time of departure.
     - parameter trafficModel:             Specifies the assumptions to use when calculating time in traffic. (defaults to best_guess)
     - parameter transitMode:              Specifies one or more preferred modes of transit.
     - parameter transitRoutingPreference: Specifies preferences for transit routes.
     - parameter completion:               API responses completion block
     */
    public class func direction(fromOriginAddress originAddress: String,
        toDestinationAddress destinationAddress: String,
        travelMode: TravelMode = .driving,
        wayPoints: [Place]? = nil,
        alternatives: Bool? = nil,
        avoid: [RouteRestriction]? = nil,
        language: String? = nil,
        units: Unit? = nil,
        region: String? = nil,
        arrivalTime: Date? = nil,
        departureTime: Date? = nil,
        trafficModel: TrafficMode? = nil,
        transitMode: TransitMode? = nil,
        transitRoutingPreference: TransitRoutingPreference? = nil,
        completion: ((_ response: Response?, _ error: NSError?) -> Void)? = nil)
    {
        direction(fromOrigin: Place.stringDescription(address: originAddress),
            toDestination: Place.stringDescription(address: destinationAddress),
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
    
    /**
     Request to Google Directions API, with coordinate
     Documentations: https://developers.google.com/maps/documentation/directions/intro#RequestParameters
     
     - parameter originCoordinate:         The coordinate from which you wish to calculate directions.
     - parameter destinationCoordinate:    The coordinate to which you wish to calculate directions.
     - parameter travelMode:               Mode of transport to use when calculating directions.
     - parameter wayPoints:                Specifies an array of waypoints. Waypoints alter a route by routing it through the specified location(s).
     - parameter alternatives:             If set to true, specifies that the Directions service may provide more than one route alternative in the response. Note that providing route alternatives may increase the response time from the server.
     - parameter avoid:                    Indicates that the calculated route(s) should avoid the indicated features.
     - parameter language:                 Specifies the language in which to return results. See https://developers.google.com/maps/faq#languagesupport.
     - parameter units:                    Specifies the unit system to use when displaying results.
     - parameter region:                   Specifies the region code, specified as a ccTLD ("top-level domain") two-character value.
     - parameter arrivalTime:              Specifies the desired time of arrival for transit directions
     - parameter departureTime:            Specifies the desired time of departure.
     - parameter trafficModel:             Specifies the assumptions to use when calculating time in traffic. (defaults to best_guess)
     - parameter transitMode:              Specifies one or more preferred modes of transit.
     - parameter transitRoutingPreference: Specifies preferences for transit routes.
     - parameter completion:               API responses completion block
     */
    public class func direction(fromOriginCoordinate originCoordinate: LocationCoordinate2D,
        toDestinationCoordinate destinationCoordinate: LocationCoordinate2D,
        travelMode: TravelMode = .driving,
        wayPoints: [Place]? = nil,
        alternatives: Bool? = nil,
        avoid: [RouteRestriction]? = nil,
        language: String? = nil,
        units: Unit? = nil,
        region: String? = nil,
        arrivalTime: Date? = nil,
        departureTime: Date? = nil,
        trafficModel: TrafficMode? = nil,
        transitMode: TransitMode? = nil,
        transitRoutingPreference: TransitRoutingPreference? = nil,
        completion: ((_ response: Response?, _ error: NSError?) -> Void)? = nil)
    {
        direction(fromOrigin: Place.coordinate(coordinate: originCoordinate),
            toDestination: Place.coordinate(coordinate: destinationCoordinate),
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
