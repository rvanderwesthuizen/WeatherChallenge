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
    
    var currentDaySunrise: Int {
        guard let time = currentWeather?.sunrise else { return 0 }
        return time
    }
    
    var currentDaySunset: Int {
        guard let time = currentWeather?.sunset else { return 0 }
        return time
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
    
    func dayTimeFlag(time: Int, sunriseTime: Int, sunsetTime: Int) -> Bool {
        if time < sunsetTime && time >= sunriseTime {
            return true
        }
        return false
    }
    
    func conditionImage(conditionID: Int, model: Current) -> UIImage{
        let imageNamePrefix = "weezle_"
        
        switch conditionID {
        case 200...232:
            return UIImage(named: "\(imageNamePrefix)cloud_thunder_rain")!
        case 300...321:
            return UIImage(named: "\(imageNamePrefix)medium_rain")!
        case 500...531:
            return UIImage(named: "\(imageNamePrefix)rain")!
        case 600...622:
            return UIImage(named: "\(imageNamePrefix)snow")!
        case 701...781:
            return UIImage(named: "\(imageNamePrefix)fog")!
        case 800:
            if !dayTimeFlag(time: model.time, sunriseTime: model.sunrise, sunsetTime: model.sunset) {
                return UIImage(named: "\(imageNamePrefix)fullmoon")!
            }
            return UIImage(named: "\(imageNamePrefix)sun")!
        case 801:
            if !dayTimeFlag(time: model.time, sunriseTime: model.sunrise, sunsetTime: model.sunset) {
                return UIImage(named: "\(imageNamePrefix)moon_cloud")!
            }
            return UIImage(named: "\(imageNamePrefix)cloud_sun")!
        case 802:
            return UIImage(named: "\(imageNamePrefix)cloud")!
        case 803:
            return UIImage(named: "\(imageNamePrefix)max_cloud")!
        case 804:
            return UIImage(named: "\(imageNamePrefix)overcast")!
        default:
            return UIImage(named: "\(imageNamePrefix)sun")!
        }
    }
    
    func conditionImage(conditionID: Int, model _: Daily) -> UIImage{
        let imageNamePrefix = "weezle_"
        
        switch conditionID {
        case 200...232:
            return UIImage(named: "\(imageNamePrefix)cloud_thunder_rain")!
        case 300...321:
            return UIImage(named: "\(imageNamePrefix)medium_rain")!
        case 500...531:
            return UIImage(named: "\(imageNamePrefix)rain")!
        case 600...622:
            return UIImage(named: "\(imageNamePrefix)snow")!
        case 701...781:
            return UIImage(named: "\(imageNamePrefix)fog")!
        case 800:
            return UIImage(named: "\(imageNamePrefix)sun")!
        case 801:
            return UIImage(named: "\(imageNamePrefix)cloud_sun")!
        case 802:
            return UIImage(named: "\(imageNamePrefix)cloud")!
        case 803:
            return UIImage(named: "\(imageNamePrefix)max_cloud")!
        case 804:
            return UIImage(named: "\(imageNamePrefix)overcast")!
        default:
            return UIImage(named: "\(imageNamePrefix)sun")!
        }
    }
    
    func conditionImage(conditionID: Int, model: Hourly) -> UIImage{
        #warning("Images not displaying based on time, always displays as day")
        let imageNamePrefix = "weezle_"
        
        switch conditionID {
        case 200...232:
            return UIImage(named: "\(imageNamePrefix)cloud_thunder_rain")!
        case 300...321:
            return UIImage(named: "\(imageNamePrefix)medium_rain")!
        case 500...531:
            return UIImage(named: "\(imageNamePrefix)rain")!
        case 600...622:
            return UIImage(named: "\(imageNamePrefix)snow")!
        case 701...781:
            return UIImage(named: "\(imageNamePrefix)fog")!
        case 800:
            if dayTimeFlag(time: model.time, sunriseTime: currentDaySunrise, sunsetTime: currentDaySunset) {
                return UIImage(named: "\(imageNamePrefix)fullmoon")!
            }
            return UIImage(named: "\(imageNamePrefix)sun")!
        case 801:
            if dayTimeFlag(time: model.time, sunriseTime: currentDaySunrise, sunsetTime: currentDaySunset) {
                return UIImage(named: "\(imageNamePrefix)moon_cloud")!
            }
            return UIImage(named: "\(imageNamePrefix)cloud_sun")!
        case 802:
            return UIImage(named: "\(imageNamePrefix)cloud")!
        case 803:
            return UIImage(named: "\(imageNamePrefix)max_cloud")!
        case 804:
            return UIImage(named: "\(imageNamePrefix)overcast")!
        default:
            return UIImage(named: "\(imageNamePrefix)sun")!
        }
    }
}
