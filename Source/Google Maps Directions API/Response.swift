//
//  Response.swift
//  GoogleMapsDirections
//
//  Created by Honghao Zhang on 2016-01-23.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import Foundation
import ObjectMapper

#if os(iOS) || os(watchOS) || os(tvOS)
    import UIKit
    public typealias Color = UIColor
#elseif os(OSX)
    import Cocoa
    public typealias Color = NSColor
#endif

// Documentations: https://developers.google.com/maps/documentation/directions/intro#DirectionsResponseElements

// MARK: - Response
extension GoogleMapsDirections {
    public struct Response: Mappable {
        public var status: StatusCode?
        public var geocodedWaypoints: [GeocodedWaypoint] = []
        public var routes: [Route] = []
        public var errorMessage: String?
        
        public init() {}
        public init?(_ map: Map) { }
        
        public mutating func mapping(map: Map) {
            status <- (map["status"], EnumTransform())
            geocodedWaypoints <- map["geocoded_waypoints"]
            routes <- map["routes"]
            errorMessage <- map["error_message"]
        }
    }
}


// MARK: - GeocodedWaypoint
extension GoogleMapsDirections {
    public struct GeocodedWaypoint: Mappable {
        public var geocoderStatus: GeocoderStatus?
        public var partialMatch: Bool = false
        public var placeID: String?
        public var types: [AddressType] = []
        
        public init?(_ map: Map) { }
        
        public mutating func mapping(map: Map) {
            geocoderStatus <- (map["geocoder_status"], EnumTransform())
            partialMatch <- map["geocoded_waypoints"]
            placeID <- map["place_id"]
            types <- (map["types"], EnumTransform())
        }
    }
}


// MARK: - Route
extension GoogleMapsDirections {
    public struct Route: Mappable {
        public var summary: String?
        public var legs: [Leg] = []
        public var waypointOrder: [Int] = []
        public var overviewPolylinePoints: String?
        public var bounds: Bounds?
        public var copyrights: String?
        public var warnings: [String] = []
        public var fare: Fare?
        
        public init?(_ map: Map) { }
        
        public mutating func mapping(map: Map) {
            summary <- map["summary"]
            legs <- map["legs"]
            waypointOrder <- map["waypointOrder"]
            overviewPolylinePoints <- map["overview_polyline.points"]
            bounds <- map["bounds"]
            copyrights <- map["copyrights"]
            warnings <- map["warnings"]
            fare <- map["fare"]
        }
    }
    
    public struct Leg: Mappable {
        public var steps: [Step] = []
        public var distance: Distance?
        public var duration: Duration?
        public var durationInTraffic: DurationInTraffic?
        public var arrivalTime: Time?
        public var departureTime: Time?
        public var startLocation: LocationCoordinate2D?
        public var endLocation: LocationCoordinate2D?
        public var startAddress: String?
        public var endAddress: String?
        
        public init?(_ map: Map) { }
        
        public mutating func mapping(map: Map) {
            steps <- map["steps"]
            distance <- map["distance"]
            duration <- map["duration"]
            durationInTraffic <- map["duration_in_traffic"]
            arrivalTime <- map["arrival_time"]
            departureTime <- map["departure_time"]
            startLocation <- (map["start_location"], CLLocationCoordinate2DTransform())
            endLocation <- (map["end_location"], CLLocationCoordinate2DTransform())
            startAddress <- map["start_address"]
            endAddress <- map["end_address"]
        }
    }
    
    public struct Step: Mappable {
        /// formatted instructions for this step, presented as an HTML text string.
        public var htmlInstructions: String?
        public var distance: Distance?
        public var duration: Duration?
        public var startLocation: LocationCoordinate2D?
        public var endLocation: LocationCoordinate2D?
        public var polylinePoints: String?
        public var steps: [Step] = []
        public var travelMode: TravelMode?
        public var maneuver: String?
        public var transitDetails: TransitDetails?
        
        public init?(_ map: Map) { }
        
        public mutating func mapping(map: Map) {
            htmlInstructions <- map["html_instructions"]
            distance <- map["distance"]
            duration <- map["duration"]
            startLocation <- (map["start_location"], CLLocationCoordinate2DTransform())
            endLocation <- (map["end_location"], CLLocationCoordinate2DTransform())
            polylinePoints <- map["polyline.points"]
            steps <- map["steps"]
            travelMode <- map["travel_mode"]
            maneuver <- map["maneuver"]
            transitDetails <- map["transit_details"]
        }
    }
    
    public struct Distance: Mappable {
        public var value: Int? // the distance in meters
        public var text: String? // human-readable representation of the distance
        
        public init?(_ map: Map) { }
        
        public mutating func mapping(map: Map) {
            value <- map["value"]
            text <- map["text"]
        }
    }
    
    public struct Duration: Mappable {
        public var value: Int? // the duration in seconds.
        public var text: String? // human-readable representation of the duration.
        
        public init?(_ map: Map) { }
        
        public mutating func mapping(map: Map) {
            value <- map["value"]
            text <- map["text"]
        }
    }
    
    public struct DurationInTraffic: Mappable {
        public var value: Int? // the duration in seconds.
        public var text: String? // human-readable representation of the duration.
        
        public init?(_ map: Map) { }
        
        public mutating func mapping(map: Map) {
            value <- map["value"]
            text <- map["text"]
        }
    }
    
    public struct Time: Mappable {
        public var value: NSDate? // the time specified as a JavaScript Date object.
        public var text: String? // the time specified as a string.
        public var timeZone: NSTimeZone? // the time zone of this station. The value is the name of the time zone as defined in the IANA Time Zone Database, e.g. "America/New_York".
        
        public init?(_ map: Map) { }
        
        public mutating func mapping(map: Map) {
            value <- (map["value"], DateTransformInteger())
            text <- map["text"]
            timeZone <- (map["time_zone"], timeZoneTransform())
        }
        
        private func timeZoneTransform() -> TransformOf<NSTimeZone, String> {
            return TransformOf<NSTimeZone, String>(fromJSON: { (value: String?) -> NSTimeZone? in
                if let value = value {
                    return NSTimeZone(name: value)
                }
                return nil
            }, toJSON: { (value: NSTimeZone?) -> String? in
                if let value = value {
                    return value.name
                }
                return nil
            })
        }
    }
    
    public struct Bounds: Mappable {
        public var northeast: LocationCoordinate2D?
        public var southwest: LocationCoordinate2D?
        
        public init?(_ map: Map) { }
        
        public mutating func mapping(map: Map) {
            northeast <- (map["northeast"], CLLocationCoordinate2DTransform())
            southwest <- (map["southwest"], CLLocationCoordinate2DTransform())
        }
    }
    
    public struct Fare: Mappable {
        public var currency: String?
        public var value: Float?
        public var text: String?
        
        public init?(_ map: Map) { }
        
        public mutating func mapping(map: Map) {
            currency <- map["currency"]
            value <- map["value"]
            text <- map["text"]
        }
    }
    
    public struct TransitDetails: Mappable {
        public var arrivalStop: Stop?
        public var departureStop: Stop?
        public var arrivalTime: Time?
        public var departureTime: Time?
        public var headsign: String?
        public var headway: Int?
        public var numStops: Int?
        public var line: TransitLine?
        
        public init?(_ map: Map) { }
        
        public mutating func mapping(map: Map) {
            arrivalStop <- map["arrival_stop"]
            departureStop <- map["departure_stop"]
            arrivalTime <- map["arrival_time"]
            departureTime <- map["departure_time"]
            headsign <- map["headsign"]
            headway <- map["headway"]
            numStops <- map["num_stops"]
            line <- map["line"]
        }
    }
    
    public struct Stop: Mappable {
        public var location: LocationCoordinate2D?
        public var name: String?
        
        public init?(_ map: Map) { }
        
        public mutating func mapping(map: Map) {
            location <- (map["location"], CLLocationCoordinate2DTransform())
            name <- map["name"]
        }
    }
    
    public struct TransitLine: Mappable {
        public var name: String?
        public var shortName: String?
        public var color: Color?
        public var agencies: [TransitAgency] = []
        public var url: NSURL?
        public var icon: NSURL?
        public var textColor: Color?
        public var vehicle: [TransitLineVehicle] = []
        
        public init?(_ map: Map) { }
        
        public mutating func mapping(map: Map) {
            name <- map["name"]
            shortName <- map["short_name"]
            color <- (map["color"], colorTransform())
            agencies <- map["agencies"]
            url <- (map["url"], URLTransform())
            icon <- (map["icon"], URLTransform())
            textColor <- (map["text_color"], colorTransform())
            vehicle <- map["vehicle"]
        }
        
        private func colorTransform() -> TransformOf<Color, String> {
            return TransformOf<Color, String>(fromJSON: { (value: String?) -> Color? in
                if let value = value {
                    return Color(hexString: value)
                }
                return nil
            }, toJSON: { (value: Color?) -> String? in
                if let value = value {
                    return value.hexString
                }
                return nil
            })
        }
    }
    
    public struct TransitAgency: Mappable {
        public var name: String?
        public var phone: String?
        public var url: NSURL?
        
        public init?(_ map: Map) { }
        
        public mutating func mapping(map: Map) {
            name <- map["name"]
            phone <- map["phone"]
            url <- (map["url"], URLTransform())
        }
    }
    
    public struct TransitLineVehicle: Mappable {
        public var name: String?
        public var type: VehicleType?
        public var icon: NSURL?
        
        public init?(_ map: Map) { }
        
        public mutating func mapping(map: Map) {
            name <- map["name"]
            type <- (map["type"], EnumTransform())
            icon <- (map["icon"], URLTransform())
        }
    }
}

// MARK: - Hex Colors
private extension Color {
    /**
     Color(hexString: "#CC0000")
     
     - parameter hexString: hexString, e.g. "#CC0000"
     
     - returns: Color
     */
    private convenience init?(hexString: String) {
        guard hexString.hasPrefix("#") else {
            return nil
        }
        guard hexString.characters.count == "#000000".characters.count else {
            return nil
        }
        let digits = hexString.substringFromIndex(hexString.startIndex.advancedBy(1))
        guard Int(digits, radix: 16) != nil else {
            return nil
        }
        let red = digits.substringToIndex(digits.startIndex.advancedBy(2))
        let green = digits.substringWithRange(Range<String.Index>(start: digits.startIndex.advancedBy(2),
            end: digits.startIndex.advancedBy(4)))
        let blue = digits.substringWithRange(Range<String.Index>(start: digits.startIndex.advancedBy(4),
            end:digits.startIndex.advancedBy(6)))
        let redf = CGFloat(Double(Int(red, radix: 16)!) / 255.0)
        let greenf = CGFloat(Double(Int(green, radix: 16)!) / 255.0)
        let bluef = CGFloat(Double(Int(blue, radix: 16)!) / 255.0)
        self.init(red: redf, green: greenf, blue: bluef, alpha: CGFloat(1.0))
    }
    
    /// Get Hex6 String, e.g. "#CC0000"
    private var hexString: String {
        let colorRef = CGColorGetComponents(self.CGColor)
        
        let r: CGFloat = colorRef[0]
        let g: CGFloat = colorRef[1]
        let b: CGFloat = colorRef[2]
        
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}
