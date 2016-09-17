//
//  Types.swift
//  GooglePlaces
//
//  Created by Honghao Zhang on 2016-02-12.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import Foundation

public extension GooglePlaces {
    public enum PlaceType: String {        
        case geocode = "geocode"
        case address = "address"
        case establishment = "establishment"
        case regions = "(regions)"
        case cities = "(cities)"
    }
}
