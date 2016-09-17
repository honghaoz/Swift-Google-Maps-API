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
        
        public var result: Result?
        public var htmlAttributions: [String] = []
        
        public init() {}
        public init?(map: Map) { }
        
        public mutating func mapping(map: Map) {
            status <- (map["status"], EnumTransform())
            errorMessage <- map["error_message"]
            
            result <- map["result"]
            htmlAttributions <- map["html_attributions"]
        }
        
        public struct Result: Mappable {
            /// an array of separate address components used to compose a given address. For example, the address "111 8th Avenue, New York, NY" contains separate address components for "111" (the street number, "8th Avenue" (the route), "New York" (the city) and "NY" (the US state).
            public var addressComponents: [AddressComponent] = []
            
            /// a string containing the human-readable address of this place. Often this address is equivalent to the "postal address," which sometimes differs from country to country. This address is generally composed of one or more address_component fields.
            public var formattedAddress: String?
            
            /// the place's phone number in its local format. For example, the formatted_phone_number for Google's Sydney, Australia office is (02) 9374 4000.
            public var formattedPhoneNumber: String?
            
            /// geometry.location the geocoded latitude,longitude value for this place.
            public var geometryLocation: LocationCoordinate2D?
            
            /// the URL of a suggested icon which may be displayed to the user when indicating this result on a map
            public var icon: URL?
            
            /// the place's phone number in international format. International format includes the country code, and is prefixed with the plus (+) sign. For example, the international_phone_number for Google's Sydney, Australia office is +61 2 9374 4000.
            public var internationalPhoneNumber: String?
            
            /// the human-readable name for the returned result. For establishment results, this is usually the canonicalized business name.
            public var name: String?
            
            /// Opening Hours
            public var openingHours: OpeningHours?
            
            /// a boolean flag indicating whether the place has permanently shut down (value true). If the place is not permanently closed, the flag is absent from the response.
            public var permanentlyClosed: Bool = false
            
            /// an array of photo objects, each containing a reference to an image. A Place Details request may return up to ten photos. More information about place photos and how you can use the images in your application can be found in the Place Photos documentation.
            public var photos: [Photo] = []
            
            /// A textual identifier that uniquely identifies a place. To retrieve information about the place, pass this identifier in the placeId field of a Places API request. For more information about place IDs, see the place ID overview.
            public var placeID: String?
            
            ///  Indicates the scope of the place_id.
            public var scope: Scope?
            
            /// An array of zero, one or more alternative place IDs for the place, with a scope related to each alternative ID. Note: This array may be empty or not present.
            public var alternativePlaceIDs: [PlaceIDScope] = []
            
            /// The price level of the place, on a scale of 0 to 4. The exact amount indicated by a specific value will vary from region to region.
            public var priceLevel: PriceLevel?
            
            /// the place's rating, from 1.0 to 5.0, based on aggregated user reviews.
            public var rating: Float?
            
            /// a JSON array of up to five reviews. If a language parameter was specified in the Place Details request, the Places Service will bias the results to prefer reviews written in that language.
            public var reviews: [Review] = []
            
            /// an array of feature types describing the given result. See the list of supported types for more information.
            public var types: [String] = []
            
            /// the URL of the official Google page for this place. This will be the Google-owned page that contains the best available information about the place. Applications must link to or embed this page on any screen that shows detailed results about the place to the user.
            public var url: URL?
            
            /// the number of minutes this place’s current timezone is offset from UTC. For example, for places in Sydney, Australia during daylight saving time this would be 660 (+11 hours from UTC), and for places in California outside of daylight saving time this would be -480 (-8 hours from UTC).
            public var utcOffset: Int?
            
            /// a simplified address for the place, including the street name, street number, and locality, but not the province/state, postal code, or country. For example, Google's Sydney, Australia office has a vicinity value of 48 Pirrama Road, Pyrmont.
            public var vicinity: String?
            
            /// the authoritative website for this place, such as a business' homepage.
            public var website: String?
            
            public init() {}
            public init?(map: Map) { }
            
            public mutating func mapping(map: Map) {
                addressComponents <- map["address_components"]
                formattedAddress <- map["formatted_address"]
                formattedPhoneNumber <- map["formatted_phone_number"]
                geometryLocation <- (map["geometry.location"], LocationCoordinate2DTransform())
                icon <- (map["icon"], URLTransform())
                internationalPhoneNumber <- map["international_phone_number"]
                name <- map["name"]
                openingHours <- map["opening_hours"]
                permanentlyClosed <- map["permanently_closed"]
                photos <- map["photos"]
                placeID <- map["place_id"]
                scope <- (map["scope"], EnumTransform())
                alternativePlaceIDs <- map["alt_ids"]
                priceLevel <- map["price_level"]
                rating <- map["rating"]
                reviews <- map["reviews"]
                types <- map["types"]
                url <- map["url"]
                utcOffset <- map["utc_offset"]
                vicinity <- map["vicinity"]
                website <- map["website"]
            }
            
            /**
             *  AddressComponent
             address components used to compose a given address. For example, the address "111 8th Avenue, New York, NY" contains separate address components for "111" (the street number, "8th Avenue" (the route), "New York" (the city) and "NY" (the US state)
             */
            public struct AddressComponent: Mappable {
                /// an array indicating the type of the address component.
                public var types: [String] = []
                
                /// the full text description or name of the address component.
                public var longName: String?
                
                /// an abbreviated textual name for the address component, if available. For example, an address component for the state of Alaska may have a long_name of "Alaska" and a short_name of "AK" using the 2-letter postal abbreviation.
                public var shortName: String?
                
                public init() {}
                public init?(map: Map) { }
                
                public mutating func mapping(map: Map) {
                    types <- map["types"]
                    longName <- map["long_name"]
                    shortName <- map["short_name"]
                }
            }
            
            public struct OpeningHours: Mappable {
                /// a boolean value indicating if the place is open at the current time.
                public var openNow: Bool = false
                
                /// an array of opening periods covering seven days, starting from Sunday, in chronological order.
                public var periods: [Period] = []
                
                /// an array of seven strings representing the formatted opening hours for each day of the week. If a language parameter was specified in the Place Details request, the Places Service will format and localize the opening hours appropriately for that language. The ordering of the elements in this array depends on the language parameter. Some languages start the week on Monday while others start on Sunday.
                public var weekdayText: [String] = []
                
                public init() {}
                public init?(map: Map) { }
                
                public mutating func mapping(map: Map) {
                    openNow <- map["open_now"]
                    periods <- map["periods"]
                    weekdayText <- map["weekday_text"]
                }
                
                public struct Period: Mappable {
                    /// a pair of day and time objects describing when the place opens
                    public var open: DayTime?
                    
                    /// may contain a pair of day and time objects describing when the place closes. Note: If a place is always open, the close section will be missing from the response. Clients can rely on always-open being represented as an open period containing day with value 0 and time with value 0000, and no close.
                    public var close: DayTime?
                    
                    public init() {}
                    public init?(map: Map) { }
                    
                    public mutating func mapping(map: Map) {
                        open <- map["open"]
                        close <- map["close"]
                    }
                    
                    public struct DayTime: Mappable {
                        /// a number from 0–6, corresponding to the days of the week, starting on Sunday. For example, 2 means Tuesday.
                        public var day: Int?
                        
                        /// contain a time of day in 24-hour hhmm format. Values are in the range 0000–2359. The time will be reported in the place’s time zone.
                        public var time: Int?
                        
                        public init() {}
                        public init?(map: Map) { }
                        
                        public mutating func mapping(map: Map) {
                            day <- map["day"]
                            time <- map["time"]
                        }
                    }
                }
            }
            
            public struct Photo: Mappable {
                /// a string used to identify the photo when you perform a Photo request.
                public var photoReference: String?
                
                /// the maximum height of the image.
                public var height: Float?
                
                /// the maximum width of the image.
                public var width: Float?
                
                /// contains any required attributions. This field will always be present, but may be empty.
                public var htmlAttributions: [String] = []
                
                public init() {}
                public init?(map: Map) { }
                
                public mutating func mapping(map: Map) {
                    photoReference <- map["photo_reference"]
                    height <- map["height"]
                    width <- map["width"]
                    htmlAttributions <- map["html_attributions"]
                }
            }
            
            /// The scope of the place_id
            ///
            /// - app:    The place ID is recognised by your application only. This is because your application added the place, and the place has not yet passed the moderation process.
            /// - google: The place ID is available to other applications and on Google Maps.
            public enum Scope: String {
                case app = "APP"
                case google = "GOOGLE"
            }
            
            public struct PlaceIDScope: Mappable {
                /// The most likely reason for a place to have an alternative place ID is if your application adds a place and receives an application-scoped place ID, then later receives a Google-scoped place ID after passing the moderation process.
                public var placeID: String?
                
                /// The scope of an alternative place ID will always be APP, indicating that the alternative place ID is recognised by your application only.
                public var scope: Scope?
                
                public init() {}
                public init?(map: Map) { }
                
                public mutating func mapping(map: Map) {
                    placeID <- map["place_id"]
                    scope <- (map["scope"], EnumTransform())
                }
            }
            
            /**
             The price level of the place, on a scale of 0 to 4. The exact amount indicated by a specific value will vary from region to region.
             
             - free:          Free
             - inexpensive:   Inexpensive
             - moderate:      Moderate
             - expensive:     Expensive
             - veryExpensive: Very Expensive
             */
            public enum PriceLevel: Int {
                case free = 0
                case inexpensive
                case moderate
                case expensive
                case veryExpensive
            }
            
            public struct Review: Mappable {
                /// a collection of AspectRating objects, each of which provides a rating of a single attribute of the establishment. The first object in the collection is considered the primary aspect.
                public var aspects: [AspectRating] = []
                
                /// the name of the user who submitted the review. Anonymous reviews are attributed to "A Google user".
                public var authorName: String?
                
                ///  the URL to the users Google+ profile, if available.
                public var authorURL: URL?
                
                /// an IETF language code indicating the language used in the user's review. This field contains the main language tag only, and not the secondary tag indicating country or region. For example, all the English reviews are tagged as 'en', and not 'en-AU' or 'en-UK' and so on.
                public var language: String?
                
                /// the user's overall rating for this place. This is a whole number, ranging from 1 to 5.
                public var rating: Float?
                
                /// the user's review. When reviewing a location with Google Places, text reviews are considered optional. Therefore, this field may by empty. Note that this field may include simple HTML markup. For example, the entity reference &amp; may represent an ampersand character.
                public var text: String?
                
                /// the time that the review was submitted, measured in the number of seconds since since midnight, January 1, 1970 UTC.
                public var time: Date?
                
                /// a rich and concise review curated by Google's editorial staff. This field will be absent unless you pass the extensions=review_summary parameter in your details request. Note that this field may not be available in the requested language.
                public var reviewSummary: String?
                
                /// the place has been selected as a Zagat quality location. The Zagat label identifies places known for their consistently high quality or that have a special or unique character.
                public var zagatSelected: Bool = false
                
                public init() {}
                public init?(map: Map) { }
                
                public mutating func mapping(map: Map) {
                    aspects <- map["aspects"]
                    authorName <- map["author_name"]
                    authorURL <- (map["author_url"], URLTransform())
                    language <- map["language"]
                    rating <- map["rating"]
                    text <- map["text"]
                    time <- (map["time"], DateTransform())
                    
                    reviewSummary <- map["review_summary"]
                    zagatSelected <- map["zagat_selected"]
                }
                
                public struct AspectRating: Mappable {
                    /// the name of the aspect that is being rated.
                    public var type: Type?
                    
                    /// the user's rating for this particular aspect, from 0 to 3.
                    public var rating: Float?
                    
                    public init() {}
                    public init?(map: Map) { }
                    
                    public mutating func mapping(map: Map) {
                        type <- map["type"]
                        rating <- map["rating"]
                    }
                    
                    /**
                     the name of the aspect that is being rated.
                     */
                    public enum `Type`: String {
                        case appeal = "appeal"
                        case atmosphere = "atmosphere"
                        case decor = "decor"
                        case facilities = "facilities"
                        case food = "food"
                        case overall = "overall"
                        case quality = "quality"
                        case service = "service"
                    }
                }
            }
        }
    }
}
