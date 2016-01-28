//
//  Response.swift
//  GoogleMapDirections
//
//  Created by Honghao Zhang on 2016-01-23.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import Foundation
import ObjectMapper
import MapKit

// MARK: - Response
extension GoogleMapDirections {
    struct Response: Mappable {
        var status: StatusCode?
        var geocodedWaypoints: [GeocodedWaypoint] = []
        var routes: [Route] = []
        var errorMessage: String?
        
        init() {}
        init?(_ map: Map) { }
        
        mutating func mapping(map: Map) {
            status <- (map["status"], EnumTransform())
            geocodedWaypoints <- map["geocoded_waypoints"]
            routes <- map["routes"]
            errorMessage <- map["error_message"]
        }
    }
}


// MARK: - GeocodedWaypoint
extension GoogleMapDirections {
    struct GeocodedWaypoint: Mappable {
        var geocoderStatus: GeocoderStatus?
        var partialMatch: Bool = false
        var placeID: String?
        var types: [AddressType] = []
        
        init?(_ map: Map) { }
        
        mutating func mapping(map: Map) {
            geocoderStatus <- (map["geocoder_status"], EnumTransform())
            partialMatch <- map["geocoded_waypoints"]
            placeID <- map["place_id"]
            types <- (map["types"], EnumTransform())
        }
    }
}


// MARK: - Route
extension GoogleMapDirections {
    struct Route: Mappable {
        var summary: String?
        var legs: [Leg] = []
        var waypointOrder: [Int] = []
        var overviewPolylinePoints: String?
        var bounds: Bounds?
        var copyrights: String?
        var warnings: [String] = []
        var fare: Fare?
        
        init?(_ map: Map) { }
        
        mutating func mapping(map: Map) {
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
    
    struct Leg: Mappable {
        var steps: [Step] = []
        var distance: Distance?
        var duration: Duration?
        var durationInTraffic: DurationInTraffic?
        var arrivalTime: Time?
        var departureTime: Time?
        var startLocation: CLLocationCoordinate2D?
        var endLocation: CLLocationCoordinate2D?
        var startAddress: String?
        var endAddress: String?
        
        init?(_ map: Map) { }
        
        mutating func mapping(map: Map) {
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
    
    struct Step: Mappable {
        /// formatted instructions for this step, presented as an HTML text string.
        var htmlInstructions: String?
        var distance: Distance?
        var duration: Duration?
        var startLocation: CLLocationCoordinate2D?
        var endLocation: CLLocationCoordinate2D?
        var polylinePoints: String?
        var steps: [Step] = []
        var travelMode: TravelMode?
        var maneuver: String?
        var transitDetails: TransitDetails?
        
        init?(_ map: Map) { }
        
        mutating func mapping(map: Map) {
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
    
    struct Distance: Mappable {
        var value: Int? // the distance in meters
        var text: String? // human-readable representation of the distance
        
        init?(_ map: Map) { }
        
        mutating func mapping(map: Map) {
            value <- map["value"]
            text <- map["text"]
        }
    }
    
    struct Duration: Mappable {
        var value: Int? // the duration in seconds.
        var text: String? // human-readable representation of the duration.
        
        init?(_ map: Map) { }
        
        mutating func mapping(map: Map) {
            value <- map["value"]
            text <- map["text"]
        }
    }
    
    struct DurationInTraffic: Mappable {
        var value: Int? // the duration in seconds.
        var text: String? // human-readable representation of the duration.
        
        init?(_ map: Map) { }
        
        mutating func mapping(map: Map) {
            value <- map["value"]
            text <- map["text"]
        }
    }
    
    struct Time: Mappable {
        var value: NSDate? // the time specified as a JavaScript Date object.
        var text: String? // the time specified as a string.
        var timeZone: NSTimeZone? // the time zone of this station. The value is the name of the time zone as defined in the IANA Time Zone Database, e.g. "America/New_York".
        
        init?(_ map: Map) { }
        
        mutating func mapping(map: Map) {
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
    
    struct Bounds: Mappable {
        var northeast: CLLocationCoordinate2D?
        var southwest: CLLocationCoordinate2D?
        
        init?(_ map: Map) { }
        
        mutating func mapping(map: Map) {
            northeast <- (map["northeast"], CLLocationCoordinate2DTransform())
            southwest <- (map["southwest"], CLLocationCoordinate2DTransform())
        }
    }
    
    struct Fare: Mappable {
        var currency: String?
        var value: Float?
        var text: String?
        
        init?(_ map: Map) { }
        
        mutating func mapping(map: Map) {
            currency <- map["currency"]
            value <- map["value"]
            text <- map["text"]
        }
    }
    
    struct TransitDetails: Mappable {
        var arrivalStop: Stop?
        var departureStop: Stop?
        var arrivalTime: Time?
        var departureTime: Time?
        var headsign: String?
        var headway: Int?
        var numStops: Int?
        var line: TransitLine?
        
        init?(_ map: Map) { }
        
        mutating func mapping(map: Map) {
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
    
    struct Stop: Mappable {
        var location: CLLocationCoordinate2D?
        var name: String?
        
        init?(_ map: Map) { }
        
        mutating func mapping(map: Map) {
            location <- (map["location"], CLLocationCoordinate2DTransform())
            name <- map["name"]
        }
    }
    
    struct TransitLine: Mappable {
        var name: String?
        var shortName: String?
        var color: UIColor?
        var agencies: [TransitAgency] = []
        var url: NSURL?
        var icon: NSURL?
        var textColor: UIColor?
        var vehicle: [TransitLineVehicle] = []
        
        init?(_ map: Map) { }
        
        mutating func mapping(map: Map) {
            name <- map["name"]
            shortName <- map["short_name"]
            color <- (map["color"], colorTransform())
            agencies <- map["agencies"]
            url <- (map["url"], URLTransform())
            icon <- (map["icon"], URLTransform())
            textColor <- (map["text_color"], colorTransform())
            vehicle <- map["vehicle"]
        }
        
        private func colorTransform() -> TransformOf<UIColor, String> {
            return TransformOf<UIColor, String>(fromJSON: { (value: String?) -> UIColor? in
                if let value = value {
                    return UIColor(hexString: value)
                }
                return nil
            }, toJSON: { (value: UIColor?) -> String? in
                if let value = value {
                    return value.hexString
                }
                return nil
            })
        }
    }
    
    struct TransitAgency: Mappable {
        var name: String?
        var phone: String?
        var url: NSURL?
        
        init?(_ map: Map) { }
        
        mutating func mapping(map: Map) {
            name <- map["name"]
            phone <- map["phone"]
            url <- (map["url"], URLTransform())
        }
    }
    
    struct TransitLineVehicle: Mappable {
        var name: String?
        var type: VehicleType?
        var icon: NSURL?
        
        init?(_ map: Map) { }
        
        mutating func mapping(map: Map) {
            name <- map["name"]
            type <- (map["type"], EnumTransform())
            icon <- (map["icon"], URLTransform())
        }
    }
}

private extension UIColor {
    /// UIColor(hexString: "#cc0000")
    convenience init?(hexString: String) {
        guard hexString.characters[hexString.startIndex] == Character("#") else {
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
        let blue = digits.substringWithRange(Range<String.Index>(start:digits.startIndex.advancedBy(4),
            end:digits.startIndex.advancedBy(6)))
        let redf = CGFloat(Double(Int(red, radix: 16)!) / 255.0)
        let greenf = CGFloat(Double(Int(green, radix: 16)!) / 255.0)
        let bluef = CGFloat(Double(Int(blue, radix: 16)!) / 255.0)
        self.init(red: redf, green: greenf, blue: bluef, alpha: CGFloat(1.0))
    }
    
    var hexString: String {
        let colorRef = CGColorGetComponents(self.CGColor)
        
        let r: CGFloat = colorRef[0]
        let g: CGFloat = colorRef[1]
        let b: CGFloat = colorRef[2]
        
        return String(format: "#%02lX%02lX%02lX", roundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
    }
}
