//
//  Constants.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/06.
//

import Foundation

enum Constants {
    static let pListPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Locations.plist")
    static let weatherURL = "https://api.openweathermap.org/data/2.5/onecall?appid=2bd3a9a6ffcb9a792ca0753f462e1081&units=metric&exclude=minutely,alerts"
    static let jsonURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Locations.json")
}
