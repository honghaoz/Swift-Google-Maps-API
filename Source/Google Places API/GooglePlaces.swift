//
//  GooglePlaces.swift
//  GooglePlaces
//
//  Created by Honghao Zhang on 2016-02-12.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import MapKit

public class GooglePlaces: GoogleMapsService {
    
    public static let baseURLString = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    
    public class func placeAutocomplete(forInput input: String,
        offset: Int? = nil,
        locationCoordinate: CLLocationCoordinate2D? = nil,
        radius: Int? = nil,
        language: String? = nil,
        types: [PlaceType]? = nil,
        components: String? = nil,
        completion: ((response: Response?, error: NSError?) -> Void)?) {
            var requestParameters = baseRequestParameters + [
                "input" : input
            ]
            
            if let offset = offset {
                requestParameters["offset"] = offset
            }
            
            if let locationCoordinate = locationCoordinate {
                requestParameters["location"] = "\(locationCoordinate.latitude),\(locationCoordinate.longitude)"
            }
            
            if let radius = radius {
                requestParameters["radius"] = radius
            }
            
            if let language = language {
                requestParameters["language"] = language
            }
            
            if let types = types {
                requestParameters["types"] = types.map { $0.rawValue }.joinWithSeparator("|")
            }
            
            if let components = components {
                requestParameters["components"] = components
            }
            
            let request = Alamofire.request(.GET, baseURLString, parameters: requestParameters).responseJSON { response in
                if response.result.isFailure {
                    NSLog("Error: GET failed")
                    completion?(response: nil, error: NSError(domain: "GooglePlacesError", code: -1, userInfo: nil))
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
                    completion?(response: nil, error: NSError(domain: "GooglePlacesError", code: -2, userInfo: nil))
                    return
                }
                
                guard let response = Mapper<Response>().map(json) else {
                    NSLog("Error: Mapping directions response failed")
                    completion?(response: nil, error: NSError(domain: "GooglePlacesError", code: -3, userInfo: nil))
                    return
                }
                
                var error: NSError?
                
                switch response.status {
                case .None:
                    let userInfo: [NSObject : AnyObject] = [
                        NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "Status Code not found", comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: "Status Code not found", comment: "")
                    ]
                    error = NSError(domain: "GooglePlacesError", code: -4, userInfo: userInfo)
                case .Some(let status):
                    switch status {
                    case .OK:
                        break
                    case .ZeroResults:
                        let userInfo: [NSObject : AnyObject] = [
                            NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "No route could be found between the origin and destination.", comment: ""),
                            NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: response.errorMessage ?? "", comment: "")
                        ]
                        error = NSError(domain: "GooglePlacesError", code: -6, userInfo: userInfo)
                    case .OverQueryLimit:
                        let userInfo: [NSObject : AnyObject] = [
                            NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "Service has received too many requests from your application within the allowed time period.", comment: ""),
                            NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: response.errorMessage ?? "", comment: "")
                        ]
                        error = NSError(domain: "GooglePlacesError", code: -9, userInfo: userInfo)
                    case .RequestDenied:
                        let userInfo: [NSObject : AnyObject] = [
                            NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "Service denied use of the directions service by your application.", comment: ""),
                            NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: response.errorMessage ?? "", comment: "")
                        ]
                        error = NSError(domain: "GooglePlacesError", code: -10, userInfo: userInfo)
                    case .InvalidRequest:
                        let userInfo: [NSObject : AnyObject] = [
                            NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "Provided request was invalid. Common causes of this status include an invalid parameter or parameter value.", comment: ""),
                            NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: response.errorMessage ?? "", comment: "")
                        ]
                        error = NSError(domain: "GooglePlacesError", code: -8, userInfo: userInfo)
                    default:
                        let userInfo: [NSObject : AnyObject] = [
                            NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "Undefined Error", comment: ""),
                            NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: response.errorMessage ?? "", comment: "")
                        ]
                        error = NSError(domain: "GooglePlacesError", code: 0, userInfo: userInfo)
                    }
                }
                
                completion?(response: response, error: error)
            }
            
            NSLog("\(request)")
    }
}
