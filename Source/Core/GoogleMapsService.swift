//
//  GoogleMapsService.swift
//  GooglePlaces
//
//  Created by Honghao Zhang on 2016-02-12.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import Foundation

open class GoogleMapsService {
    enum GoogleMapsServiceError: Error {
        case apiKeyNotExisted
    }
    
    fileprivate static var _apiKey: String?
    
    /**
     Provide a Google Maps API key
     
     - parameter APIKey: Google Maps API key
     */
    public class func provide(apiKey: String) {
        _apiKey = apiKey
    }
    
    /**
     Return a valid API key, or throw an exception
     
     - throws: API key error
     
     - returns: API Key string
     */
    class func apiKey() throws -> String {
        guard let apiKey = _apiKey else {
            NSLog("Error: Please provide an API key")
            throw GoogleMapsServiceError.apiKeyNotExisted
        }
        return apiKey
    }
    
    /// Get a base request parameter dictionary, this will include API key
    class var baseRequestParameters: [String : String] {
        return try! ["key" : apiKey()]
    }
}
