//
//  PlistHandler.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/06.
//

import Foundation

struct PlistHandler {
    private var locations = [Location]()
    
    mutating func getLocationsFormPlist(completion: @escaping(Result<[Location], Error>) -> Void) {
        if let data = try? Data(contentsOf: Constants.pListPath!) {
            let decoder = PropertyListDecoder()
            do {
                locations.append(try decoder.decode(Location.self, from: data))
                completion(.success(locations))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func writeToPlist(locations: [Location]) {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(locations)
            try data.write(to: Constants.pListPath!)
        } catch {
            print("\(error)")
        }
    }
}
