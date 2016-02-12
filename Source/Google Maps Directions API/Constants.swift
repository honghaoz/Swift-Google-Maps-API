//
//  Constants.swift
//  GoogleMapsDirections
//
//  Created by Honghao Zhang on 2016-01-23.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import Foundation
import ObjectMapper

public extension GoogleMapsDirections {
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
    public enum StatusCode: String {
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
    public enum GeocoderStatus: String {
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
    public enum AddressType: String {
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
    
    /**
     Transportation mode
     
     - Driving:   Driving directions using the road network. (default)
     - Walking:   Walking directions via pedestrian paths & sidewalks (where available).
     - Bicycling: Bicycling directions via bicycle paths & preferred streets (where available).
     - Transit:   Public transit routes (where available).
     */
    public enum TravelMode: String {
        case Driving = "DRIVING"
        case Walking = "WALKING"
        case Bicycling = "BICYCLING"
        case Transit = "TRANSIT"
    }
    
    /**
     Calculated route(s) should avoid the indicated features.
     
     - Tolls:    Avoid Toll roads/bridges
     - Highways: Avoid Highways
     - Ferries:  Avoid Ferries
     - Indoor:   Avoid indoor steps for walking and transit directions. Only requests that include an API key or a Google Maps APIs Premium Plan client ID will receive indoor steps by default.
     */
    public enum RouteRestriction: String {
        case Tolls = "tolls"
        case Highways = "highways"
        case Ferries = "ferries"
        case Indoor = "indoor"
    }
    
    /**
     Specifies the assumptions to use when calculating time in traffic. 
     Discussion: This setting affects the value returned in the duration_in_traffic field in the response, which contains the predicted time in traffic based on historical averages. The traffic_model parameter may only be specified for driving directions where the request includes a departure_time, and only if the request includes an API key or a Google Maps APIs Premium Plan client ID.
     
     - BestGuess:   (default) indicates that the returned duration_in_traffic should be the best estimate of travel time given what is known about both historical traffic conditions and live traffic. Live traffic becomes more important the closer the departure_time is to now.
     - Pessimistic: indicates that the returned duration_in_traffic should be longer than the actual travel time on most days, though occasional days with particularly bad traffic conditions may exceed this value.
     - Optimistic:  indicates that the returned duration_in_traffic should be shorter than the actual travel time on most days, though occasional days with particularly good traffic conditions may be faster than this value.
     */
    public enum TrafficMode: String {
        case BestGuess = "best_guess"
        case Pessimistic = "pessimistic"
        case Optimistic = "optimistic"
    }
    
    /**
     Specifies one or more preferred modes of transit.
     Discussion: This parameter may only be specified for transit directions, and only if the request includes an API key or a Google Maps APIs Premium Plan client ID.
     
     - Bus:    Calculated route should prefer travel by bus.
     - Subway: Calculated route should prefer travel by subway.
     - Train:  Calculated route should prefer travel by train.
     - Tram:   Calculated route should prefer travel by tram and light rail.
     - Rail:   Calculated route should prefer travel by train, tram, light rail, and subway. This is equivalent to transit_mode=train|tram|subway.
     */
    public enum TransitMode: String {
        case Bus = "bus"
        case Subway = "subway"
        case Train = "train"
        case Tram = "tram"
        case Rail = "rail"
    }
    
    /**
     Specifies preferences for transit routes. 
     Discussion: Using this parameter, you can bias the options returned, rather than accepting the default best route chosen by the API. This parameter may only be specified for transit directions, and only if the request includes an API key or a Google Maps APIs Premium Plan client ID.
     
     - LessWalking:    Calculated route should prefer limited amounts of walking.
     - FewerTransfers: Calculated route should prefer a limited number of transfers.
     */
    public enum TransitRoutingPreference: String {
        case LessWalking = "less_walking"
        case FewerTransfers = "fewer_transfers"
    }
    
    /**
     Unit system
     Discussion: Directions results contain text within distance fields that may be displayed to the user to indicate the distance of a particular "step" of the route. By default, this text uses the unit system of the origin's country or region.
     Note: this unit system setting only affects the text displayed within distance fields. The distance fields also contain values which are always expressed in meters.
     
     - Metric:   Metric system. Textual distances are returned using kilometers and meters.
     - Imperial: Imperial (English) system. Textual distances are returned using miles and feet.
     */
    public enum Unit: String {
        case Metric = "metric"
        case Imperial = "imperial"
    }
    
    /**
     Type of vehicle that runs on this line
     
     - Rail:                                                          Rail
     - MetroRail:                                                     Light rail transit.
     - Subway:                                                        Underground light rail.
     - Tram:                                                          Above ground light rail.
     - Monorail:                                                      Monorail.
     - HeavyRail:                                                     Heavy rail.
     - CommuterRail:                                                  Commuter rail.
     - HighSpeedTrain:                                                High speed train.
     - Bus:                                                           Bus.
     - IntercityBus:                                                  Intercity bus.
     - Trolleybus:                                                    Trolleybus.
     - ShareTaxi:                                                     Share taxi is a kind of bus with the ability to drop off and pick up passengers anywhere on its route.
     - Ferry:                                                         Ferry.
     - CableCar:                                                      A vehicle that operates on a cable, usually on the ground. Aerial cable cars may be of the type GONDOLA_LIFT.
     - GondolaLift:                                                   An aerial cable car.
     - Funicular:                                                     A vehicle that is pulled up a steep incline by a cable. A Funicular typically consists of two cars, with each car acting as a counterweight for the other.
     - Other:                                                         All other vehicles will return this type.
     */
    public enum VehicleType: String {
        case Rail = "RAIL"
        case MetroRail = "METRO_RAIL"
        case Subway = "SUBWAY"
        case Tram = "TRAM"
        case Monorail = "MONORAIL"
        case HeavyRail = "HEAVY_RAIL"
        case CommuterRail = "COMMUTER_TRAIN"
        case HighSpeedTrain = "HIGH_SPEED_TRAIN"
        case Bus = "BUS"
        case IntercityBus = "INTERCITY_BUS"
        case Trolleybus = "TROLLEYBUS"
        case ShareTaxi = "SHARE_TAXI"
        case Ferry = "FERRY"
        case CableCar = "CABLE_CAR"
        case GondolaLift = "GONDOLA_LIFT"
        case Funicular = "FUNICULAR"
        case Other = "OTHER"
    }
}
