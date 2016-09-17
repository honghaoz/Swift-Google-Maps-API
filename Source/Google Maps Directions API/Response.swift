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
public extension GoogleMapsDirections {
    public struct Response: Mappable {
        public var status: StatusCode?
        public var errorMessage: String?
        
        public var geocodedWaypoints: [GeocodedWaypoint] = []
        public var routes: [Route] = []
        
        public init() {}
        public init?(map: Map) { }
        
        public mutating func mapping(map: Map) {
            status <- (map["status"], EnumTransform())
            errorMessage <- map["error_message"]
            
            geocodedWaypoints <- map["geocoded_waypoints"]
            routes <- map["routes"]
        }
        
        /**
         *  GeocodedWaypoint
         */
        public struct GeocodedWaypoint: Mappable {
            public var geocoderStatus: GeocoderStatus?
            public var partialMatch: Bool = false
            public var placeID: String?
            public var types: [AddressType] = []
            
            public init?(map: Map) { }
            
            public mutating func mapping(map: Map) {
                geocoderStatus <- (map["geocoder_status"], EnumTransform())
                partialMatch <- map["geocoded_waypoints"]
                placeID <- map["place_id"]
                types <- (map["types"], EnumTransform())
            }
        }
        
        /**
         *  Route
         */
        public struct Route: Mappable {
            public var summary: String?
            public var legs: [Leg] = []
            public var waypointOrder: [Int] = []
            public var overviewPolylinePoints: String?
            public var bounds: Bounds?
            public var copyrights: String?
            public var warnings: [String] = []
            public var fare: Fare?
            
            public init?(map: Map) { }
            
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
            
            /**
             *  Leg
             */
            public struct Leg: Mappable {
                public var steps: [Step] = []
                public var distance: Step.Distance?
                public var duration: Step.Duration?
                public var durationInTraffic: DurationInTraffic?
                public var arrivalTime: Time?
                public var departureTime: Time?
                public var startLocation: LocationCoordinate2D?
                public var endLocation: LocationCoordinate2D?
                public var startAddress: String?
                public var endAddress: String?
                
                public init?(map: Map) { }
                
                public mutating func mapping(map: Map) {
                    steps <- map["steps"]
                    distance <- map["distance"]
                    duration <- map["duration"]
                    durationInTraffic <- map["duration_in_traffic"]
                    arrivalTime <- map["arrival_time"]
                    departureTime <- map["departure_time"]
                    startLocation <- (map["start_location"], LocationCoordinate2DTransform())
                    endLocation <- (map["end_location"], LocationCoordinate2DTransform())
                    startAddress <- map["start_address"]
                    endAddress <- map["end_address"]
                }
                
                /**
                 *  Step
                 */
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
                    
                    public init?(map: Map) { }
                    
                    public mutating func mapping(map: Map) {
                        htmlInstructions <- map["html_instructions"]
                        distance <- map["distance"]
                        duration <- map["duration"]
                        startLocation <- (map["start_location"], LocationCoordinate2DTransform())
                        endLocation <- (map["end_location"], LocationCoordinate2DTransform())
                        polylinePoints <- map["polyline.points"]
                        steps <- map["steps"]
                        travelMode <- map["travel_mode"]
                        maneuver <- map["maneuver"]
                        transitDetails <- map["transit_details"]
                    }
                    
                    /**
                     *  Distance
                     */
                    public struct Distance: Mappable {
                        public var value: Int? // the distance in meters
                        public var text: String? // human-readable representation of the distance
                        
                        public init?(map: Map) { }
                        
                        public mutating func mapping(map: Map) {
                            value <- map["value"]
                            text <- map["text"]
                        }
                    }
                    
                    /**
                     *  Duration
                     */
                    public struct Duration: Mappable {
                        public var value: Int? // the duration in seconds.
                        public var text: String? // human-readable representation of the duration.
                        
                        public init?(map: Map) { }
                        
                        public mutating func mapping(map: Map) {
                            value <- map["value"]
                            text <- map["text"]
                        }
                    }
                    
                    /**
                     *  TransitDetails
                     */
                    public struct TransitDetails: Mappable {
                        public var arrivalStop: Stop?
                        public var departureStop: Stop?
                        public var arrivalTime: Time?
                        public var departureTime: Time?
                        public var headsign: String?
                        public var headway: Int?
                        public var numStops: Int?
                        public var line: TransitLine?
                        
                        public init?(map: Map) { }
                        
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
                        
                        /**
                         *  Stop
                         */
                        public struct Stop: Mappable {
                            public var location: LocationCoordinate2D?
                            public var name: String?
                            
                            public init?(map: Map) { }
                            
                            public mutating func mapping(map: Map) {
                                location <- (map["location"], LocationCoordinate2DTransform())
                                name <- map["name"]
                            }
                        }
                        
                        /**
                         *  TransitLine
                         */
                        public struct TransitLine: Mappable {
                            public var name: String?
                            public var shortName: String?
                            public var color: Color?
                            public var agencies: [TransitAgency] = []
                            public var url: URL?
                            public var icon: URL?
                            public var textColor: Color?
                            public var vehicle: [TransitLineVehicle] = []
                            
                            public init?(map: Map) { }
                            
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
                            
                            fileprivate func colorTransform() -> TransformOf<Color, String> {
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
                            
                            /**
                             *  TransitAgency
                             */
                            public struct TransitAgency: Mappable {
                                public var name: String?
                                public var phone: String?
                                public var url: URL?
                                
                                public init?(map: Map) { }
                                
                                public mutating func mapping(map: Map) {
                                    name <- map["name"]
                                    phone <- map["phone"]
                                    url <- (map["url"], URLTransform())
                                }
                            }
                            
                            /**
                             *  TransitLineVehicle
                             */
                            public struct TransitLineVehicle: Mappable {
                                public var name: String?
                                public var type: VehicleType?
                                public var icon: URL?
                                
                                public init?(map: Map) { }
                                
                                public mutating func mapping(map: Map) {
                                    name <- map["name"]
                                    type <- (map["type"], EnumTransform())
                                    icon <- (map["icon"], URLTransform())
                                }
                            }
                        }
                    }
                }
                
                /**
                 *  DurationInTraffic
                 */
                public struct DurationInTraffic: Mappable {
                    public var value: Int? // the duration in seconds.
                    public var text: String? // human-readable representation of the duration.
                    
                    public init?(map: Map) { }
                    
                    public mutating func mapping(map: Map) {
                        value <- map["value"]
                        text <- map["text"]
                    }
                }
                
                /**
                 *  Time
                 */
                public struct Time: Mappable {
                    public var value: Date? // the time specified as a JavaScript Date object.
                    public var text: String? // the time specified as a string.
                    public var timeZone: TimeZone? // the time zone of this station. The value is the name of the time zone as defined in the IANA Time Zone Database, e.g. "America/New_York".
                    
                    public init?(map: Map) { }
                    
                    public mutating func mapping(map: Map) {
                        value <- (map["value"], DateTransformInteger())
                        text <- map["text"]
                        timeZone <- (map["time_zone"], timeZoneTransform())
                    }
                    
                    fileprivate func timeZoneTransform() -> TransformOf<TimeZone, String> {
                        return TransformOf<TimeZone, String>(fromJSON: { (value: String?) -> TimeZone? in
                            if let value = value {
                                return TimeZone(identifier: value)
                            }
                            return nil
                            }, toJSON: { (value: TimeZone?) -> String? in
                                if let value = value {
                                    return value.identifier
                                }
                                return nil
                        })
                    }
                }
            }
            
            /**
             *  Bounds
             */
            public struct Bounds: Mappable {
                public var northeast: LocationCoordinate2D?
                public var southwest: LocationCoordinate2D?
                
                public init?(map: Map) { }
                
                public mutating func mapping(map: Map) {
                    northeast <- (map["northeast"], LocationCoordinate2DTransform())
                    southwest <- (map["southwest"], LocationCoordinate2DTransform())
                }
            }
            
            /**
             *  Fare
             */
            public struct Fare: Mappable {
                public var currency: String?
                public var value: Float?
                public var text: String?
                
                public init?(map: Map) { }
                
                public mutating func mapping(map: Map) {
                    currency <- map["currency"]
                    value <- map["value"]
                    text <- map["text"]
                }
            }
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
    convenience init?(hexString: String) {
        guard hexString.hasPrefix("#") else {
            return nil
        }
        guard hexString.characters.count == "#000000".characters.count else {
            return nil
        }
        let digits = hexString.substring(from: hexString.characters.index(hexString.startIndex, offsetBy: 1))
        guard Int(digits, radix: 16) != nil else {
            return nil
        }
        let red = digits.substring(to: digits.characters.index(digits.startIndex, offsetBy: 2))
        let green = digits.substring(with: digits.characters.index(digits.startIndex, offsetBy: 2) ..< digits.characters.index(digits.startIndex, offsetBy: 4))
        let blue = digits.substring(with: digits.characters.index(digits.startIndex, offsetBy: 4) ..< digits.characters.index(digits.startIndex, offsetBy: 6))
        let redf = CGFloat(Double(Int(red, radix: 16)!) / 255.0)
        let greenf = CGFloat(Double(Int(green, radix: 16)!) / 255.0)
        let bluef = CGFloat(Double(Int(blue, radix: 16)!) / 255.0)
        self.init(red: redf, green: greenf, blue: bluef, alpha: CGFloat(1.0))
    }
    
    /// Get Hex6 String, e.g. "#CC0000"
    var hexString: String {
        let colorRef = self.cgColor.components
        
        let r: CGFloat = colorRef![0]
        let g: CGFloat = colorRef![1]
        let b: CGFloat = colorRef![2]
        
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}
