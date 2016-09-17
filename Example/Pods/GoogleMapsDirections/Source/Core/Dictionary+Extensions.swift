//
//  Dictionary+Extensions.swift
//  GoogleMapsDirections
//
//  Created by Honghao Zhang on 2016-02-13.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import Foundation

// MARK: - Plus Operator for Dictionary

/**
 Combine two dictionaries
 
 - parameter left:  left operand dictionary
 - parameter right: right operand dictionary
 
 - returns: Combined dictionary, existed keys in left dictionary will be overrided by right dictionary
 */
func + <K, V> (left: [K : V], right: [K : V]?) -> [K : V] {
    guard let right = right else { return left }
    return left.reduce(right) {
        var new = $0 as [K : V]
        new.updateValue($1.1, forKey: $1.0)
        return new
    }
}

/**
 Combine two dictionaries
 
 - parameter left:  left operand dictionary
 - parameter right: right operand dictionary
 */
func += <K, V> (left: inout [K : V], right: [K : V]){
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}
