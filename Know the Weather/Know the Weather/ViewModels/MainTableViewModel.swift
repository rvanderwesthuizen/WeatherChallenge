//
//  MainTableViewModel.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/02.
//

import Foundation
import CoreLocation
import MapKit

class MainTableViewModel {
    var currentWeather: Current?
    var dailyWeather = [Daily]()
    var hourlyWeather = [Hourly]()
    
    var dailyCount: Int {
        dailyWeather.count
    }
    
    var hourlyCount: Int {
        hourlyWeather.count
    }
    
    private lazy var apiCaller = OpenWeatherMapAPICaller()
    
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping () -> Void) {
        apiCaller.fetchWeather(lat: lat, lon: lon) { result in
            switch result {
            case .failure(let error): print(error)
            case .success(let data):
                self.currentWeather = data.current
                self.dailyWeather = data.daily
                self.hourlyWeather = data.hourly
                completion()
            }
        }
    }
    
    func currentCity(from location: CLLocation, completion: @escaping (String) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if error == nil {
                guard let city = placemarks?.first?.locality else { return }
                completion(city)
            } else {
                print(error!)
            }
        }
    }
    
}
