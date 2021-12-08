//
//  GooglePlacesManager.swift
//  LocationWeatherDemo1
//
//  Created by Герман on 25.11.21.
//

import Foundation
import GooglePlaces
import CoreLocation

struct Place{
    var name: String
    var identifire: String
}

class GooglePlacesManager{
    
    private init(){}
    
    static let shared = GooglePlacesManager()
    
    enum PlacesError: Error{
        case failedToFind
        case failedToGetCoordinate
    }
    
    private let client = GMSPlacesClient.shared()
    
    public func findPlaces(query: String, completion: @escaping(Result<[Place], Error>)-> Void){
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode
        client.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil){
            results, error in
            guard let results = results, error == nil else{
                completion(.failure(PlacesError.failedToFind))
                return
            }
            let places: [Place] = results.compactMap({
                Place(name: $0.attributedFullText.string, identifire: $0.placeID)
            })
            completion(.success(places))
        }
    }
    
    public func resolveLocation(for place: Place, completion: @escaping(Result<CLLocationCoordinate2D, Error>) -> Void){
        client.fetchPlace(fromPlaceID: place.identifire, placeFields: .coordinate, sessionToken: nil){
            googlePlace, error in
            guard let googlePlace = googlePlace, error == nil else{
                completion(.failure(PlacesError.failedToGetCoordinate))
                return
            }
            let coordinate = CLLocationCoordinate2D(latitude: googlePlace.coordinate.latitude, longitude: googlePlace.coordinate.longitude)
            completion(.success(coordinate))
        }
    }
}
