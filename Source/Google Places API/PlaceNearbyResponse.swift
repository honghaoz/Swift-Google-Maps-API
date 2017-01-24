//
//  PlaceNearbyResponse.swift
//  GooglePlaces
//
//  Created by Afnan Ahmad on 18/11/2016.
//  Copyright © 2016 Afnan Ahmad. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: - PlaceNearbyResponse
public extension GooglePlaces {
    public struct PlaceNearbyResponse: Mappable {
        public var status: StatusCode?
        public var errorMessage: String?
        public var nextPageToken: String?
        
        public var results: [GooglePlaces.Response.Result] = []
        public var htmlAttributions: [String] = []
        
        public init() {}
        public init?(map: Map) { }
        
        public mutating func mapping(map: Map) {
            status <- (map["status"], EnumTransform())
            errorMessage <- map["error_message"]
            nextPageToken <- map["next_page_token"]
            
            results <- map["results"]
            htmlAttributions <- map["html_attributions"]
        }
    }
}
