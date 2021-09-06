//
//  LocationsTableViewModel.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/06.
//

import Foundation
import CoreLocation

class LocationsTableViewModel {
    private lazy var plistHandler = PlistHandler()
    var locations = [Location]()
    
    var counts: Int {
        locations.count
    }
    
    func checkIfLocationIsInList(location: CLLocation, completion: @escaping (Result<Bool,Error>) -> Void) {
        getLocationsFormPlist { result in
            switch result {
            case .success(_):
                for loc in self.locations {
                    if loc.lat == location.coordinate.latitude && loc.lon == location.coordinate.longitude {
                        completion(.success(true))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getLocationsFormPlist(completion: @escaping(Result< String,Error>) -> Void) {
        plistHandler.getLocationsFormPlist { result in
            switch result{
            case .success(let locations):
                self.locations = locations
                completion(.success(""))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func writeToPlist(locations: [Location]) {
        plistHandler.writeToPlist(locations: locations)
    }
}
