//
//  temporaryJsonFile.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/27.
//

import Foundation
import CoreLocation

class JSONService {
    private var locations = [Location]()
    
    func readJSON() {
        do {
            let jsonData = try Data(contentsOf: Constants.jsonURL!)
            let parsedLocations = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
            let locations = parsedLocations as! [Dictionary<String, [Double]>]
            
            for location in locations {
                guard let cityName = location.keys.first else { return }
                guard let coordinates = location[cityName] else { return }
                let lat = coordinates[0]
                let lon = coordinates[1]
                self.locations.append(Location(lat: lat, lon: lon, cityName: cityName))
            }
            
            print(self.locations)
        } catch {
            print("\(error)")
        }
    }
    
    func writeJson() {
        var containingArray: [Dictionary<String, [Double]>] = []
        let loc = CLLocation(latitude: +37.33233141, longitude: -122.03121860)
        locations.append(Location(lat: loc.coordinate.latitude, lon: loc.coordinate.longitude, cityName: "Cupertino"))
        for location in locations {
            var locationDict: [String : [Double]] = [:]
            locationDict[location.cityName] = [location.lat, location.lon]
            containingArray.append(locationDict)
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: containingArray, options: .prettyPrinted)
            if let url = Constants.jsonURL {
                try jsonData.write(to: url)
                readJSON()
            }
        } catch {
            print("\(error)")
        }
    }
}
