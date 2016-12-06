//
//  GooglePlacesNearby.swift
//  GooglePlaces
//
//  Created by Afnan Ahmad on 18/11/2016.
//  Copyright © 2016 Afnan Ahmad. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

public extension GooglePlaces {

    public enum Price: Int {
        case mostAfforable
        case affordable
        case moderate
        case expensive
        case mostExpensive
    }
    
    public enum Rank: String {
        case prominence = "prominence"
        case distance = "distance"
    }
    
    fileprivate static var pendingRequest: Alamofire.Request?
    
    public static let placeNearbyURLString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    
    public class func placeNearby(toLocation locationCoordinate: LocationCoordinate2D,
                                        radius: Int? = nil,
                                        keyword: String? = nil,
                                        language: String? = nil,
                                        minPrice: Price? = nil,
                                        maxPrice: Price? = nil,
                                        name: String? = nil,
                                        opennow: Bool? = nil,
                                        rankby: Rank? = nil,
                                        type: NearbyPlaceType? = nil,
                                        types: [NearbyPlaceType]? = nil,
                                        cancelPendingRequestsAutomatically: Bool = true,
                                        completion: ((PlaceNearbyResponse?, NSError?) -> Void)?)
    {
        var requestParameters: [String : Any] = baseRequestParameters
        
        requestParameters["location"] = "\(locationCoordinate.latitude),\(locationCoordinate.longitude)"
        
        if let radius = radius {
            requestParameters["radius"] = radius
        }
        
        if let language = language {
            requestParameters["language"] = language
        }
        
        if let minPrice = minPrice {
            requestParameters["minPrice"] = minPrice
        }
        
        if let maxPrice = maxPrice {
            requestParameters["maxPrice"] = maxPrice
        }
        
        if let name = name {
            requestParameters["name"] = name
        }
        
        if let opennow = opennow {
            requestParameters["opennow"] = opennow
        }
        
        if let rankby = rankby {
            requestParameters["rankby"] = rankby
        }
        
        if let type = type {
            requestParameters["type"] = type.rawValue
        }
        
        if let types = types {
            requestParameters["types"] = types.map { $0.rawValue }.joined(separator: "|")
        }
        
        if pendingRequest != nil && cancelPendingRequestsAutomatically {
            pendingRequest?.cancel()
            pendingRequest = nil
        }
        
        let request = Alamofire.request(placeNearbyURLString, method: .get, parameters: requestParameters).responseJSON { response in
            if response.result.error?._code == NSURLErrorCancelled {
                // nothing to do, another active request is coming
                return
            }
            
            if response.result.isFailure {
                NSLog("Error: GET failed")
                completion?(nil, NSError(domain: "GooglePlacesNearbyError", code: -1, userInfo: nil))
                return
            }
            
            // Nil
            if let _ = response.result.value as? NSNull {
                completion?(PlaceNearbyResponse(), nil)
                return
            }
            
            // JSON
            guard let json = response.result.value as? [String : AnyObject] else {
                NSLog("Error: Parsing json failed")
                completion?(nil, NSError(domain: "GooglePlacesNearbyError", code: -2, userInfo: nil))
                return
            }
            
            guard let response = Mapper<PlaceNearbyResponse>().map(JSON: json) else {
                NSLog("Error: Mapping directions response failed")
                completion?(nil, NSError(domain: "GooglePlacesNearbyError", code: -3, userInfo: nil))
                return
            }
            
            var error: NSError?
            
            switch response.status {
            case .none:
                let userInfo = [
                    NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "Status Code not found", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: "Status Code not found", comment: "")
                ]
                error = NSError(domain: "GooglePlacesNearbyError", code: -1, userInfo: userInfo)
            case .some(let status):
                switch status {
                case .ok:
                    break
                default:
                    let userInfo = [
                        NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: status.rawValue, comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: response.errorMessage ?? "", comment: "")
                    ]
                    error = NSError(domain: "GooglePlacesNearbyError", code: -1, userInfo: userInfo)
                }
            }
            
            pendingRequest = nil
            
            completion?(response, error)
        }
        
        pendingRequest = request
        
        debugPrint("\(request)")
    }
    
    public class func placeNearby(nextPageToken token: String,
                                  cancelPendingRequestsAutomatically: Bool = true,
                                  completion: ((PlaceNearbyResponse?, NSError?) -> Void)?)
    {
        var requestParameters: [String : Any] = baseRequestParameters
        
        requestParameters["pagetoken"] = token
        
        let request = Alamofire.request(placeNearbyURLString, method: .get, parameters: requestParameters).responseJSON { response in
            if response.result.error?._code == NSURLErrorCancelled {
                // nothing to do, another active request is coming
                return
            }
            
            if response.result.isFailure {
                NSLog("Error: GET failed")
                completion?(nil, NSError(domain: "GooglePlacesError", code: -1, userInfo: nil))
                return
            }
            
            // Nil
            if let _ = response.result.value as? NSNull {
                completion?(PlaceNearbyResponse(), nil)
                return
            }
            
            // JSON
            guard let json = response.result.value as? [String : AnyObject] else {
                NSLog("Error: Parsing json failed")
                completion?(nil, NSError(domain: "GooglePlacesNearbyError", code: -2, userInfo: nil))
                return
            }
            
            guard let response = Mapper<PlaceNearbyResponse>().map(JSON: json) else {
                NSLog("Error: Mapping directions response failed")
                completion?(nil, NSError(domain: "GooglePlacesNearbyError", code: -3, userInfo: nil))
                return
            }
            
            var error: NSError?
            
            switch response.status {
            case .none:
                let userInfo = [
                    NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: "Status Code not found", comment: ""),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: "Status Code not found", comment: "")
                ]
                error = NSError(domain: "GooglePlacesNearbyError", code: -1, userInfo: userInfo)
            case .some(let status):
                switch status {
                case .ok:
                    break
                default:
                    let userInfo = [
                        NSLocalizedDescriptionKey : NSLocalizedString("StatusCodeError", value: status.rawValue, comment: ""),
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("StatusCodeError", value: response.errorMessage ?? "", comment: "")
                    ]
                    error = NSError(domain: "GooglePlacesNearbyError", code: -1, userInfo: userInfo)
                }
            }
            
            pendingRequest = nil
            
            completion?(response, error)
        }
        
        pendingRequest = request
        
        debugPrint("\(request)")
    }
    
}


