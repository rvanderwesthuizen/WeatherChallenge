//
//  MainTableViewModel.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/02.
//

import Foundation
import CoreLocation
import MapKit
import UserNotifications

protocol MainTableViewModelDelegate {
    func didFetchWeather(_ weather: WeatherData)
    func didFailWithError(errorString: String, error: Error)
}

class MainTableViewModel: NSObject {
    //MARK: - Private Variables
    private lazy var plistHandler = PlistHandler()
    private lazy var service = OpenWeatherMapService()
    private let locationManager = CLLocationManager()
    private var locations = [Location]()
    
    //MARK: - Public Variables
    var delegate: MainTableViewModelDelegate?
    var currentWeather: Current?
    var dailyWeather = [Daily]()
    var hourlyWeather = [Hourly]()
    var currentSelectedLocation: CLLocation?
    var scope: WeatherScope?
    
    //MARK: - Calculated Variables
    var dailyCount: Int {
        dailyWeather.count
    }
    
    override init() {
        super.init()
        setupLocation()
        setupLocalNotification()
    }
    
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
                self.delegate?.didFailWithError(errorString: "An error occurred while trying to set default locations.", error: error)
            }
        }
        plistHandler.writeToPlist(locations: [Location(lat: location.coordinate.latitude, lon: location.coordinate.longitude, cityName: "Cupertino(Apple)")])
    }
    
    @objc func fetchWeather() {
        let lat = currentSelectedLocation!.coordinate.latitude
        let lon = currentSelectedLocation!.coordinate.longitude
        
        service.fetchWeather(lat: lat, lon: lon) { result in
            switch result {
            case .failure(let error):
                self.delegate?.didFailWithError(errorString: "An error occurred while fetching the weather.", error: error)
            case .success(let data):
                self.currentWeather = data.current
                self.dailyWeather = data.daily
                self.hourlyWeather = data.hourly
                self.delegate?.didFetchWeather(data)
            }
        }
    }
    
    func currentCity(completion: @escaping (Result<String,Error>) -> Void) {
        guard let location = currentSelectedLocation else { return }
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if error == nil {
                guard let city = placemarks?.first?.locality else { return }
                completion(.success(city))
            } else {
                completion(.failure(error!))
            }
        }
    }
    
    func conditionImage() -> String{
        let imageNamePrefix = "weezle_"
        
        var conditionID: Int
        switch scope {
        case .current(let current):
            conditionID =  current.weather[0].id
        case .daily(let day):
            conditionID = day.weather[0].id
        case .none:
            return "\(imageNamePrefix)sun"
        }
        
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
            switch scope {
            case .current(let model):
                return model.isDayTime ? "\(imageNamePrefix)sun" : "\(imageNamePrefix)fullmoon"
            case .daily(_), .none:
                return "\(imageNamePrefix)sun"
            }
        case 801:
            switch scope {
            case .current(let model):
                return model.isDayTime ? "\(imageNamePrefix)cloud_sun" : "\(imageNamePrefix)moon_cloud"
            case .daily(_), .none:
                return "\(imageNamePrefix)cloud_sun"
            }
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

//MARK: - CoreLocation
extension MainTableViewModel: CLLocationManagerDelegate{
    
    func setupLocation() {
        locationManager.delegate = self
        if locationManager.authorizationStatus == .denied {
            fetchLastKnownLocation() { result in
                switch result {
                case .success(let location):
                    self.currentSelectedLocation = CLLocation(latitude: location.lat, longitude: location.lon)
                    self.fetchWeather()
                case .failure(let error):
                    self.delegate?.didFailWithError(errorString: "An error occurred while retrieving last known location data.", error: error)
                }
            }
        } else if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            } else {
                fetchLastKnownLocation() { result in
                    switch result {
                    case .success(let location):
                        self.currentSelectedLocation = CLLocation(latitude: location.lat, longitude: location.lon)
                    case .failure(let error):
                        self.delegate?.didFailWithError(errorString: "An error occurred while retrieving last known location data.", error: error)
                    }
                }
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .denied, status != .notDetermined, CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        } else {
            fetchLastKnownLocation() { result in
                switch result {
                case .success(let location):
                    self.currentSelectedLocation = CLLocation(latitude: location.lat, longitude: location.lon)
                    
                    self.fetchWeather()
                    
                case .failure(let error):
                    self.delegate?.didFailWithError(errorString: "An error occurred while retrieving last known location data.", error: error)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentSelectedLocation == nil{
            currentSelectedLocation = locations.first
            locationManager.stopUpdatingLocation()
            self.fetchWeather()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(errorString: "An error occurred while retrieving location data.", error: error)
    }}

extension MainTableViewModel {
    
    //MARK: - DailyWeather
    func dailyWeather(at index: Int) -> Daily? {
        dailyWeather[safe: index]
    }
    
    func dailyWeatherSunrise(at index: Int) -> Int? {
        dailyWeather[safe: index]?.sunrise
    }
    
    //MARK: - CurrentWeather
    var percentageChanceOfRain: Double {
        dailyWeather[0].chanceOfRain
    }
    
    var isDayTime: Bool {
        guard let current = currentWeather else { return true }
        return current.isDayTime
    }
    
    var currentWeatherDescription: String {
        guard let current = currentWeather else { return "" }
        return current.weather[0].description
    }
    
    var currentTemp: String {
        guard let current = currentWeather else { return "" }
        
        return "\(Measurement(value: current.temp, unit: UnitTemperature.celsius))"
    }
}

//MARK: - Local Notifications
extension MainTableViewModel {
    private func setupLocalNotification() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if error != nil {
                self.delegate?.didFailWithError(errorString: "An error occurred while setting notification permissions.", error: error!)
            }
        }
    }
    
    func registerLocalNotification() {
        //Create a notification, which is scheduled for 2 days to remind the user to check the weather
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Are you sure you Know the Weather?"
        content.body = "Come back to check the weather and make sure you do"
        content.sound = .default
        
        /* Actual trigger in app
         var dateComponents = DateComponents()
         dateComponents.day = 2
         
         let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
         */
        
        //For demo
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
}
