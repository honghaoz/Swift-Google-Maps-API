//
//  DateTransformInteger.swift
//  GoogleMapDirections
//
//  Created by Honghao Zhang on 2016-01-24.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import Foundation
import ObjectMapper

public class DateTransformInteger: TransformType {
	public typealias Object = NSDate
	public typealias JSON = Int
	
	public init() {}
	
	public func transformFromJSON(value: AnyObject?) -> NSDate? {
		if let timeInt = value as? Int {
			return NSDate(timeIntervalSince1970: NSTimeInterval(timeInt))
		}
		
		if let timeStr = value as? String {
			return NSDate(timeIntervalSince1970: NSTimeInterval(atof(timeStr)))
		}
		
		return nil
	}
	
	public func transformToJSON(value: NSDate?) -> Int? {
		if let date = value {
			return Int(date.timeIntervalSince1970)
		}
		return nil
	}
}