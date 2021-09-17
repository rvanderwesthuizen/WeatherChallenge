//
//  MainTableViewModel.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/02.
//

import Foundation
import CoreLocation
import MapKit

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
    
    //MARK: - Calculated Variables
    var dailyCount: Int {
        dailyWeather.count
    }
    
    override init() {
        super.init()
        setupLocation()
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
    
    func dayTimeFlag(time: Int, sunriseTime: Int, sunsetTime: Int) -> Bool {
        if time < sunsetTime && time >= sunriseTime {
            return true
        }
        return false
    }
    
    func conditionImage(conditionID: Int, scope: WeatherScope) -> String{
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
            switch scope {
            case .current(let model):
                if !dayTimeFlag(time: model.time, sunriseTime: model.sunrise, sunsetTime: model.sunset) {
                    return "\(imageNamePrefix)fullmoon"
                }
                return "\(imageNamePrefix)sun"
            case .daily(_):
                return "\(imageNamePrefix)sun"
            }
        case 801:
            switch scope {
            case .current(let model):
                if !dayTimeFlag(time: model.time, sunriseTime: model.sunrise, sunsetTime: model.sunset) {
                    return "\(imageNamePrefix)moon_cloud"
                }
                return "\(imageNamePrefix)cloud_sun"
            case .daily(_):
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
