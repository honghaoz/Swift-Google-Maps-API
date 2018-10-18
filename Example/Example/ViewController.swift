//
//  ViewController.swift
//  Example
//
//  Created by Honghao Zhang on 2016-02-12.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleMapsDirections
import GooglePlacesAPI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Google Maps Directions
        GoogleMapsDirections.provide(apiKey: "AIzaSyDftpY3fi6x_TL4rntL8pgZb-A8mf6D0Ss")
        
        let origin = GoogleMapsDirections.Place.stringDescription(address: "Davis Center, Waterloo, Canada")
        let destination = GoogleMapsDirections.Place.stringDescription(address: "Conestoga Mall, Waterloo, Canada")
        
        // You can also use coordinates or placeID for a place
        // let origin = Place.Coordinate(coordinate: LocationCoordinate2D(latitude: 43.4697354, longitude: -80.5397377))
        // let origin = Place.PlaceID(id: "ChIJb9sw59k0K4gRZZlYrnOomfc")
        
        GoogleMapsDirections.direction(fromOrigin: origin, toDestination: destination) { (response, error) -> Void in
            // Check Status Code
            guard response?.status == GoogleMapsDirections.StatusCode.ok else {
                // Status Code is Not OK
                debugPrint(response?.errorMessage ?? "")
                return
            }
            
            // Use .result or .geocodedWaypoints to access response details
            // response will have same structure as what Google Maps Directions API returns
            debugPrint("it has \(response?.routes.count ?? 0) routes")
        }
        
        // Google Places
        GooglePlaces.provide(apiKey: "AIzaSyDftpY3fi6x_TL4rntL8pgZb-A8mf6D0Ss")
        
        GooglePlaces.placeAutocomplete(forInput: "Pub") { (response, error) -> Void in
            // Check Status Code
            guard response?.status == GooglePlaces.StatusCode.ok else {
                // Status Code is Not OK
                debugPrint(response?.errorMessage ?? "")
                return
            }
            
            // Use .predictions to access response details
            debugPrint("first matched result: \(response?.predictions.first?.description ?? "nil")")
        }
        
        GooglePlaces.placeDetails(forPlaceID: "ChIJb9sw59k0K4gRZZlYrnOomfc") { (response, error) -> Void in
            // Check Status Code
            guard response?.status == GooglePlaces.StatusCode.ok else {
                // Status Code is Not OK
                debugPrint(response?.errorMessage ?? "")
                return
            }
            
            // Use .result to access response details
            debugPrint("the formated address is: \(response?.result?.formattedAddress ?? "nil")")
        }
    }
}

