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
    private var plistHandler = PlistHandler()
    var currentWeather: Current?
    var dailyWeather = [Daily]()
    var hourlyWeather = [Hourly]()
    var locations = [Location]()
    
    var dailyCount: Int {
        dailyWeather.count
    }
    
    var currentDaySunrise: Int {
        guard let time = currentWeather?.sunrise else { return 0 }
        return time
    }
    
    var currentDaySunset: Int {
        guard let time = currentWeather?.sunset else { return 0 }
        return time
    }
    
    private lazy var apiCaller = OpenWeatherMapAPICaller()
    
    func fetchLastKnownLocation(completion: @escaping (Result<Location, Error>) -> Void) {
        plistHandler.getLocationsFormPlist { result in
            switch result {
            case .success(let locations):
                completion(.success(locations.first!))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func setDefaultLocation(location: CLLocation) {
        locations.append(Location(lat: location.coordinate.latitude, lon: location.coordinate.longitude, cityName: "Cupertino(Apple)"))
        plistHandler.getLocationsFormPlist { result in
            switch result {
            case .success(let locations):
                self.locations = locations
            case .failure(let error):
                print(error)
            }
        }
        plistHandler.writeToPlist(locations: [Location(lat: location.coordinate.latitude, lon: location.coordinate.longitude, cityName: "Cupertino(Apple)")])
    }
    
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        apiCaller.fetchWeather(lat: lat, lon: lon) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                self.currentWeather = data.current
                self.dailyWeather = data.daily
                self.hourlyWeather = data.hourly
                completion(.success(data))
            }
        }
    }
    
    func currentCity(from location: CLLocation, completion: @escaping (Result<String,Error>) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if error == nil {
                guard let city = placemarks?.first?.locality else { return }
                completion(.success(city))
            } else {
                completion(.failure(error!))
            }
        }
    }
    
    func dayTimeFlag(time: Int, sunriseTime: Int, sunsetTime: Int) -> Bool {
        if time < sunsetTime && time >= sunriseTime {
            return true
        }
        return false
    }
    
    func conditionImage(conditionID: Int, model: Current) -> String{
        let imageNamePrefix = "weezle_"
        
        switch conditionID {
        case 200...232:
            return "\(imageNamePrefix)cloud_thunder_rain"
        case 300...321:
            return "\(imageNamePrefix)medium_rain"
        case 500...531:
            return "\(imageNamePrefix)rain"
        case 600...622:
            return "\(imageNamePrefix)snow"
        case 701...781:
            return "\(imageNamePrefix)fog"
        case 800:
            if !dayTimeFlag(time: model.time, sunriseTime: model.sunrise, sunsetTime: model.sunset) {
                return "\(imageNamePrefix)fullmoon"
            }
            return "\(imageNamePrefix)sun"
        case 801:
            if !dayTimeFlag(time: model.time, sunriseTime: model.sunrise, sunsetTime: model.sunset) {
                return "\(imageNamePrefix)moon_cloud"
            }
            return "\(imageNamePrefix)cloud_sun"
        case 802:
            return "\(imageNamePrefix)cloud"
        case 803:
            return "\(imageNamePrefix)max_cloud"
        case 804:
            return "\(imageNamePrefix)overcast"
        default:
            return "\(imageNamePrefix)sun"
        }
    }
}
