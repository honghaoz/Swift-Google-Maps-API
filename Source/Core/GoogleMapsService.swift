//
//  GoogleMapsService.swift
//  GooglePlaces
//
//  Created by Honghao Zhang on 2016-02-12.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import Foundation

public class GoogleMapsService {
    enum Error: ErrorType {
        case APIKeyNotExisted
    }
    
    private static var _APIKey: String?
    
    /**
     Provide a Google Maps API key
     
     - parameter APIKey: Google Maps API key
     */
    public class func provideAPIKey(APIKey: String) {
        _APIKey = APIKey
    }
    
    /**
     Return a valid API key, or throw an exception
     
     - throws: API key error
     
     - returns: API Key string
     */
    class func APIKey() throws -> String {
        guard let APIKey = _APIKey else {
            NSLog("Error: Please provide an API key")
            throw Error.APIKeyNotExisted
        }
        return APIKey
    }
    
    /// Get a base request parameter dictionary, this will include API key
    class var baseRequestParameters: [String : AnyObject] {
        return try! ["key" : APIKey()]
    }
}
