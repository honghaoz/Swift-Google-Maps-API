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

public class GooglePlaces: GoogleMapsService {
    
    public static let placeAutocompleteURLString = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    
    public class func placeAutocomplete(forInput input: String,
        offset: Int? = nil,
        locationCoordinate: LocationCoordinate2D? = nil,
        radius: Int? = nil,
        language: String? = nil,
        types: [PlaceType]? = nil,
        components: String? = nil,
        completion: ((response: PlaceAutocompleteResponse?, error: NSError?) -> Void)?)
    {
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
        
        let request = Alamofire.request(.GET, placeAutocompleteURLString, parameters: requestParameters).responseJSON { response in
            if response.result.isFailure {
                NSLog("Error: GET failed")
                completion?(response: nil, error: NSError(domain: "GooglePlacesError", code: -1, userInfo: nil))
                return
            }
            
            // Nil
            if let _ = response.result.value as? NSNull {
                completion?(response: PlaceAutocompleteResponse(), error: nil)
                return
            }
            
            // JSON
            guard let json = response.result.value as? [String : AnyObject] else {
                NSLog("Error: Parsing json failed")
                completion?(response: nil, error: NSError(domain: "GooglePlacesError", code: -2, userInfo: nil))
                return
            }
            
            guard let response = Mapper<PlaceAutocompleteResponse>().map(json) else {
                NSLog("Error: Mapping directions response failed")
                completion?(response: nil, error: NSError(domain: "GooglePlacesError", code: -3, userInfo: nil))
                return
            }
            
            var error: NSError?
            
            switch response.status {
            case .None:
                let userInfo = [
                    NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "Status Code not found", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: "Status Code not found", comment: "")
                ]
                error = NSError(domain: "GooglePlacesError", code: -1, userInfo: userInfo)
            case .Some(let status):
                switch status {
                case .OK:
                    break
                default:
                    let userInfo = [
                        NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: status.rawValue, comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: response.errorMessage ?? "", comment: "")
                    ]
                    error = NSError(domain: "GooglePlacesError", code: -1, userInfo: userInfo)
                }
            }
            
            completion?(response: response, error: error)
        }
        
        debugPrint("\(request)")
    }
}



// MARK: - Place Details
extension GooglePlaces {
    
    public static let placeDetailsURLString = "https://maps.googleapis.com/maps/api/place/details/json"
    
    public class func placeDetails(forPlaceID placeID: String, extensions: String? = nil, language: String? = nil, completion: ((response: PlaceDetailsResponse?, error: NSError?) -> Void)?) {
        var requestParameters = baseRequestParameters + [
            "placeid" : placeID
        ]
        
        if let extensions = extensions {
            requestParameters["extensions"] = extensions
        }
        
        if let language = language {
            requestParameters["language"] = language
        }
        
        let request = Alamofire.request(.GET, placeDetailsURLString, parameters: requestParameters).responseJSON { response in
            if response.result.isFailure {
                NSLog("Error: GET failed")
                completion?(response: nil, error: NSError(domain: "GooglePlacesError", code: -1, userInfo: nil))
                return
            }
            
            // Nil
            if let _ = response.result.value as? NSNull {
                completion?(response: PlaceDetailsResponse(), error: nil)
                return
            }
            
            // JSON
            guard let json = response.result.value as? [String : AnyObject] else {
                NSLog("Error: Parsing json failed")
                completion?(response: nil, error: NSError(domain: "GooglePlacesError", code: -2, userInfo: nil))
                return
            }
            
            guard let response = Mapper<PlaceDetailsResponse>().map(json) else {
                NSLog("Error: Mapping directions response failed")
                completion?(response: nil, error: NSError(domain: "GooglePlacesError", code: -3, userInfo: nil))
                return
            }
            
            var error: NSError?
            
            switch response.status {
            case .None:
                let userInfo = [
                    NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "Status Code not found", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: "Status Code not found", comment: "")
                ]
                error = NSError(domain: "GooglePlacesError", code: -1, userInfo: userInfo)
            case .Some(let status):
                switch status {
                case .OK:
                    break
                default:
                    let userInfo = [
                        NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: status.rawValue, comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: response.errorMessage ?? "", comment: "")
                    ]
                    error = NSError(domain: "GooglePlacesError", code: -1, userInfo: userInfo)
                }
            }
            
            completion?(response: response, error: error)
        }
        
        debugPrint("\(request)")
    }
}
