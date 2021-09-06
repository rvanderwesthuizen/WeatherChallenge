//
//  Locations.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/06.
//

import Foundation
import CoreLocation

struct Location: Codable {
    let lat: CLLocationDegrees
    let lon: CLLocationDegrees
    let cityName: String
}
