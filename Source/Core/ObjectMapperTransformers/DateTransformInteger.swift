//
//  DateTransformInteger.swift
//  GoogleMapsDirections
//
//  Created by Honghao Zhang on 2016-01-24.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import Foundation
import ObjectMapper

class DateTransformInteger: TransformType {
	typealias Object = NSDate
	typealias JSON = Int
	
	init() {}
	
	func transformFromJSON(value: AnyObject?) -> NSDate? {
		if let timeInt = value as? Int {
			return NSDate(timeIntervalSince1970: NSTimeInterval(timeInt))
		}
		
		if let timeStr = value as? String {
			return NSDate(timeIntervalSince1970: NSTimeInterval(atof(timeStr)))
		}
		
		return nil
	}
	
	func transformToJSON(value: NSDate?) -> Int? {
		if let date = value {
			return Int(date.timeIntervalSince1970)
		}
		return nil
	}
}
