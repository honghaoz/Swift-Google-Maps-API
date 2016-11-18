//
//  PlaceDetailsResponse.swift
//  GooglePlaces
//
//  Created by Honghao Zhang on 2016-02-20.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: - PlaceAutocompleteResponse
public extension GooglePlaces {
    public struct PlaceDetailsResponse: Mappable {
        public var status: StatusCode?
        public var errorMessage: String?
        
        public var result: GooglePlaces.Response.Result?
        public var htmlAttributions: [String] = []
        
        public init() {}
        public init?(map: Map) { }
        
        public mutating func mapping(map: Map) {
            status <- (map["status"], EnumTransform())
            errorMessage <- map["error_message"]
            
            result <- map["result"]
            htmlAttributions <- map["html_attributions"]
        }
    }
}
