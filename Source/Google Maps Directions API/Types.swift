//
//  Types.swift
//  GoogleMapsDirections
//
//  Created by Honghao Zhang on 2016-01-23.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import Foundation

public extension GoogleMapsDirections {
    /**
     The status code resulting from the geocoding operation.
     
     - OK:          No errors occurred; the address was successfully parsed and at least one geocode was returned.
     - ZeroResults: The geocode was successful but returned no results. This may occur if the geocoder was passed a non-existent address.
     */
    public enum GeocoderStatus: String {
        case ok = "OK"
        case zeroResults = "ZERO_RESULTS"
    }
    
    /**
     Address type of the geocoding result used for calculating directions.
     
     - streetAddress:            Precise street address
     - route:                    Named route (such as "US 101").
     - intersection:             Major intersection, usually of two major roads.
     - political:                Political entity. Usually, this type indicates a polygon of some civil administration.
     - country:                  The national political entity, and is typically the highest order type returned by the Geocoder.
     - administrativeAreaLevel1: First-order civil entity below the country level. Within the United States, these administrative levels are states. Not all nations exhibit these administrative levels.
     - administrativeAreaLevel2: Second-order civil entity below the country level. Within the United States, these administrative levels are counties. Not all nations exhibit these administrative levels.
     - administrativeAreaLevel3: Third-order civil entity below the country level. This type indicates a minor civil division. Not all nations exhibit these administrative levels.
     - administrativeAreaLevel4: Fourth-order civil entity below the country level. This type indicates a minor civil division. Not all nations exhibit these administrative levels.
     - administrativeAreaLevel5: Fifth-order civil entity below the country level. This type indicates a minor civil division. Not all nations exhibit these administrative levels.
     - colloquialArea:           Commonly-used alternative name for the entity.
     - locality:                 Incorporated city or town political entity.
     - ward:                     Specific type of Japanese locality, to facilitate distinction between multiple locality components within a Japanese address.
     - sublocality:              First-order civil entity below a locality.
     - sublocalityLevel1:        First-order civil entity below a locality.
     - sublocalityLevel2:        Second-order civil entity below a locality.
     - sublocalityLevel3:        Third-order civil entity below a locality.
     - sublocalityLevel4:        Fourth-order civil entity below a locality.
     - sublocalityLevel5:        Fifth-order civil entity below a locality.
     - neighborhood:             Named neighborhood
     - premise:                  Named location, usually a building or collection of buildings with a common name
     - subpremise:               First-order entity below a named location, usually a singular building within a collection of buildings with a common name
     - postalCode:              Postal code as used to address postal mail within the country.
     - naturalFeature:           Prominent natural feature.
     - airport:                  Airport.
     - park:                     Named park.
     - pointOfInterest:          Named point of interest. Typically, these "POI"s are prominent local entities that don't easily fit in another category, such as "Empire State Building" or "Statue of Liberty."
     */
    public enum AddressType: String {
        case streetAddress = "street_address"
        case route = "route"
        case intersection = "intersection"
        case political = "political"
        case country = "country"
        case administrativeAreaLevel1 = "administrative_area_level_1"
        case administrativeAreaLevel2 = "administrative_area_level_2"
        case administrativeAreaLevel3 = "administrative_area_level_3"
        case administrativeAreaLevel4 = "administrative_area_level_4"
        case administrativeAreaLevel5 = "administrative_area_level_5"
        case colloquialArea = "colloquial_area"
        case locality = "locality"
        case ward = "ward"
        case sublocality = "sublocality"
        case sublocalityLevel1 = "sublocality_level_1"
        case sublocalityLevel2 = "sublocality_level_2"
        case sublocalityLevel3 = "sublocality_level_3"
        case sublocalityLevel4 = "sublocality_level_4"
        case sublocalityLevel5 = "sublocality_level_5"
        case neighborhood = "neighborhood"
        case premise = "premise"
        case subpremise = "subpremise"
        case postalCode = "postal_code"
        case naturalFeature = "natural_feature"
        case airport = "airport"
        case park = "park"
        case pointOfInterest = "point_of_interest"
    }
    
    /**
     Transportation mode
     
     - driving:   Driving directions using the road network. (default)
     - walking:   Walking directions via pedestrian paths & sidewalks (where available).
     - bicycling: Bicycling directions via bicycle paths & preferred streets (where available).
     - transit:   Public transit routes (where available).
     */
    public enum TravelMode: String {
        case driving = "DRIVING"
        case walking = "WALKING"
        case bicycling = "BICYCLING"
        case transit = "TRANSIT"
    }
    
    /**
     Calculated route(s) should avoid the indicated features.
     
     - tolls:    Avoid Toll roads/bridges
     - highways: Avoid Highways
     - ferries:  Avoid Ferries
     - indoor:   Avoid indoor steps for walking and transit directions. Only requests that include an API key or a Google Maps APIs Premium Plan client ID will receive indoor steps by default.
     */
    public enum RouteRestriction: String {
        case tolls = "tolls"
        case highways = "highways"
        case ferries = "ferries"
        case indoor = "indoor"
    }
    
    /**
     Specifies the assumptions to use when calculating time in traffic. 
     Discussion: This setting affects the value returned in the duration_in_traffic field in the response, which contains the predicted time in traffic based on historical averages. The traffic_model parameter may only be specified for driving directions where the request includes a departure_time, and only if the request includes an API key or a Google Maps APIs Premium Plan client ID.
     
     - bestGuess:   (default) indicates that the returned duration_in_traffic should be the best estimate of travel time given what is known about both historical traffic conditions and live traffic. Live traffic becomes more important the closer the departure_time is to now.
     - pessimistic: indicates that the returned duration_in_traffic should be longer than the actual travel time on most days, though occasional days with particularly bad traffic conditions may exceed this value.
     - optimistic:  indicates that the returned duration_in_traffic should be shorter than the actual travel time on most days, though occasional days with particularly good traffic conditions may be faster than this value.
     */
    public enum TrafficMode: String {
        case bestGuess = "best_guess"
        case pessimistic = "pessimistic"
        case optimistic = "optimistic"
    }
    
    /**
     Specifies one or more preferred modes of transit.
     Discussion: This parameter may only be specified for transit directions, and only if the request includes an API key or a Google Maps APIs Premium Plan client ID.
     
     - bus:    Calculated route should prefer travel by bus.
     - subway: Calculated route should prefer travel by subway.
     - train:  Calculated route should prefer travel by train.
     - tram:   Calculated route should prefer travel by tram and light rail.
     - rail:   Calculated route should prefer travel by train, tram, light rail, and subway. This is equivalent to transit_mode=train|tram|subway.
     */
    public enum TransitMode: String {
        case bus = "bus"
        case subway = "subway"
        case train = "train"
        case tram = "tram"
        case rail = "rail"
    }
    
    /**
     Specifies preferences for transit routes. 
     Discussion: Using this parameter, you can bias the options returned, rather than accepting the default best route chosen by the API. This parameter may only be specified for transit directions, and only if the request includes an API key or a Google Maps APIs Premium Plan client ID.
     
     - lessWalking:    Calculated route should prefer limited amounts of walking.
     - fewerTransfers: Calculated route should prefer a limited number of transfers.
     */
    public enum TransitRoutingPreference: String {
        case lessWalking = "less_walking"
        case fewerTransfers = "fewer_transfers"
    }
    
    /**
     Unit system
     Discussion: Directions results contain text within distance fields that may be displayed to the user to indicate the distance of a particular "step" of the route. By default, this text uses the unit system of the origin's country or region.
     Note: this unit system setting only affects the text displayed within distance fields. The distance fields also contain values which are always expressed in meters.
     
     - metric:   Metric system. Textual distances are returned using kilometers and meters.
     - imperial: Imperial (English) system. Textual distances are returned using miles and feet.
     */
    public enum Unit: String {
        case metric = "metric"
        case imperial = "imperial"
    }
    
    /**
     Type of vehicle that runs on this line
     
     - rail:                                                          Rail
     - metroRail:                                                     Light rail transit.
     - subway:                                                        Underground light rail.
     - tram:                                                          Above ground light rail.
     - monorail:                                                      Monorail.
     - heavyRail:                                                     Heavy rail.
     - commuterRail:                                                  Commuter rail.
     - highSpeedTrain:                                                High speed train.
     - bus:                                                           Bus.
     - intercityBus:                                                  Intercity bus.
     - trolleybus:                                                    Trolleybus.
     - shareTaxi:                                                     Share taxi is a kind of bus with the ability to drop off and pick up passengers anywhere on its route.
     - ferry:                                                         Ferry.
     - cableCar:                                                      A vehicle that operates on a cable, usually on the ground. Aerial cable cars may be of the type GONDOLA_LIFT.
     - gondolaLift:                                                   An aerial cable car.
     - funicular:                                                     A vehicle that is pulled up a steep incline by a cable. A Funicular typically consists of two cars, with each car acting as a counterweight for the other.
     - other:                                                         All other vehicles will return this type.
     */
    public enum VehicleType: String {
        case rail = "RAIL"
        case metroRail = "METRO_RAIL"
        case subway = "SUBWAY"
        case tram = "TRAM"
        case monorail = "MONORAIL"
        case heavyRail = "HEAVY_RAIL"
        case commuterRail = "COMMUTER_TRAIN"
        case highSpeedTrain = "HIGH_SPEED_TRAIN"
        case bus = "BUS"
        case intercityBus = "INTERCITY_BUS"
        case trolleybus = "TROLLEYBUS"
        case shareTaxi = "SHARE_TAXI"
        case ferry = "FERRY"
        case cableCar = "CABLE_CAR"
        case gondolaLift = "GONDOLA_LIFT"
        case funicular = "FUNICULAR"
        case other = "OTHER"
    }
}
