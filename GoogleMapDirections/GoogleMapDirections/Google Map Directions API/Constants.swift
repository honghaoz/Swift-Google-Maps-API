//
//  Constants.swift
//  GoogleMapDirections
//
//  Created by Honghao Zhang on 2016-01-23.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import Foundation
import ObjectMapper

extension GoogleMapDirections {
    /**
     The status field within the Directions response object contains the status of the request, 
     and may contain debugging information to help you track down why the Directions service failed.
     Reference: https://developers.google.com/maps/documentation/directions/intro#StatusCodes
     
     - OK:                   The response contains a valid result.
     - NotFound:             At least one of the locations specified in the request's origin, destination, or waypoints could not be geocoded.
     - ZeroResults:          No route could be found between the origin and destination.
     - MaxWaypointsExceeded: Too many waypoints were provided in the request.
     - InvalidRequest:       The provided request was invalid.
     - OverQueryLimit:       The service has received too many requests from your application within the allowed time period.
     - RequestDenied:        The service denied use of the directions service by your application.
     - UnknownError:         Directions request could not be processed due to a server error.
     */
    enum StatusCode: String {
        case OK = "OK"
        case NotFound = "NOT_FOUND"
        case ZeroResults = "ZERO_RESULTS"
        case MaxWaypointsExceeded = "MAX_WAYPOINTS_EXCEEDED"
        case InvalidRequest = "INVALID_REQUEST"
        case OverQueryLimit = "OVER_QUERY_LIMIT"
        case RequestDenied = "REQUEST_DENIED"
        case UnknownError = "UNKNOWN_ERROR"
    }
    
    /**
     The status code resulting from the geocoding operation.
     
     - OK:          No errors occurred; the address was successfully parsed and at least one geocode was returned.
     - ZeroResults: The geocode was successful but returned no results. This may occur if the geocoder was passed a non-existent address.
     */
    enum GeocoderStatus: String {
        case OK = "OK"
        case ZeroResults = "ZERO_RESULTS"
    }
    
    /**
     Address type of the geocoding result used for calculating directions.
     
     - StreetAddress:            Precise street address
     - Route:                    Named route (such as "US 101").
     - Intersection:             Major intersection, usually of two major roads.
     - Political:                Political entity. Usually, this type indicates a polygon of some civil administration.
     - Country:                  The national political entity, and is typically the highest order type returned by the Geocoder.
     - AdministrativeAreaLevel1: First-order civil entity below the country level. Within the United States, these administrative levels are states. Not all nations exhibit these administrative levels.
     - AdministrativeAreaLevel2: Second-order civil entity below the country level. Within the United States, these administrative levels are counties. Not all nations exhibit these administrative levels.
     - AdministrativeAreaLevel3: Third-order civil entity below the country level. This type indicates a minor civil division. Not all nations exhibit these administrative levels.
     - AdministrativeAreaLevel4: Fourth-order civil entity below the country level. This type indicates a minor civil division. Not all nations exhibit these administrative levels.
     - AdministrativeAreaLevel5: Fifth-order civil entity below the country level. This type indicates a minor civil division. Not all nations exhibit these administrative levels.
     - ColloquialArea:           Commonly-used alternative name for the entity.
     - Locality:                 Incorporated city or town political entity.
     - Ward:                     Specific type of Japanese locality, to facilitate distinction between multiple locality components within a Japanese address.
     - Sublocality:              First-order civil entity below a locality.
     - SublocalityLevel1:        First-order civil entity below a locality.
     - SublocalityLevel2:        Second-order civil entity below a locality.
     - SublocalityLevel3:        Third-order civil entity below a locality.
     - SublocalityLevel4:        Fourth-order civil entity below a locality.
     - SublocalityLevel5:        Fifth-order civil entity below a locality.
     - Neighborhood:             Named neighborhood
     - Premise:                  Named location, usually a building or collection of buildings with a common name
     - Subpremise:               First-order entity below a named location, usually a singular building within a collection of buildings with a common name
     - Postal_code:              Postal code as used to address postal mail within the country.
     - NaturalFeature:           Prominent natural feature.
     - Airport:                  Airport.
     - Park:                     Named park.
     - PointOfInterest:          Named point of interest. Typically, these "POI"s are prominent local entities that don't easily fit in another category, such as "Empire State Building" or "Statue of Liberty."
     */
    enum AddressType: String {
        case StreetAddress = "street_address"
        case Route = "route"
        case Intersection = "intersection"
        case Political = "political"
        case Country = "country"
        case AdministrativeAreaLevel1 = "administrative_area_level_1"
        case AdministrativeAreaLevel2 = "administrative_area_level_2"
        case AdministrativeAreaLevel3 = "administrative_area_level_3"
        case AdministrativeAreaLevel4 = "administrative_area_level_4"
        case AdministrativeAreaLevel5 = "administrative_area_level_5"
        case ColloquialArea = "colloquial_area"
        case Locality = "locality"
        case Ward = "ward"
        case Sublocality = "sublocality"
        case SublocalityLevel1 = "sublocality_level_1"
        case SublocalityLevel2 = "sublocality_level_2"
        case SublocalityLevel3 = "sublocality_level_3"
        case SublocalityLevel4 = "sublocality_level_4"
        case SublocalityLevel5 = "sublocality_level_5"
        case Neighborhood = "neighborhood"
        case Premise = "premise"
        case Subpremise = "subpremise"
        case Postal_code = "postal_code"
        case NaturalFeature = "natural_feature"
        case Airport = "airport"
        case Park = "park"
        case PointOfInterest = "point_of_interest"
    }
    
    enum TravelMode: String {
        case Driving = "DRIVING"
        case Walking = "WALKING"
        case Bicycling = "BICYCLING"
        case Transit = "TRANSIT"
    }
    
    enum RouteRestriction: String {
        case Tolls = "tolls"
        case Highways = "highways"
        case Ferries = "ferries"
        case Indoor = "indoor"
    }
    
    enum TrafficMode: String {
        case BestGuess = "best_guess"
        case Pessimistic = "pessimistic"
        case Optimistic = "optimistic"
    }
    
    enum TransitMode: String {
        case Bus = "bus"
        case Subway = "subway"
        case Train = "train"
        case Tram = "tram"
        case Rail = "rail"
    }
    
    enum TransitRoutingPreference: String {
        case LessWalking = "less_walking"
        case FewerTransfers = "fewer_transfers"
    }
    
    enum Unit: String {
        case Metric = "metric"
        case Imperial = "imperial"
    }
    
    enum VehicleType: String {
        case Rail = "RAIL" // Rail.
        case MetroRail = "METRO_RAIL" // Light rail transit.
        case Subway = "SUBWAY" // Underground light rail.
        case Tram = "TRAM" // Above ground light rail.
        case Monorail = "MONORAIL" // Monorail.
        case HeavyRail = "HEAVY_RAIL" // Heavy rail.
        case CommuterRail = "COMMUTER_TRAIN" // Commuter rail.
        case HighSpeedTrain = "HIGH_SPEED_TRAIN" // High speed train.
        case Bus = "BUS" // Bus.
        case IntercityBus = "INTERCITY_BUS" // Intercity bus.
        case Trolleybus = "TROLLEYBUS" // Trolleybus.
        case ShareTaxi = "SHARE_TAXI" // Share taxi is a kind of bus with the ability to drop off and pick up passengers anywhere on its route.
        case Ferry = "FERRY" // Ferry.
        case CableCar = "CABLE_CAR" // A vehicle that operates on a cable, usually on the ground. Aerial cable cars may be of the type GONDOLA_LIFT.
        case GondolaLift = "GONDOLA_LIFT" // An aerial cable car.
        case Funicular = "FUNICULAR" // A vehicle that is pulled up a steep incline by a cable. A Funicular typically consists of two cars, with each car acting as a counterweight for the other.
        case Other = "OTHER" // All other vehicles will return this type.
    }
}
