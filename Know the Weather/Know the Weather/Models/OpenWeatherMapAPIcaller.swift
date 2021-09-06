//
//  WeatherModel.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/08/27.
//

import Foundation
import CoreLocation


struct OpenWeatherMapAPICaller {
    let weatherURL = "https://api.openweathermap.org/data/2.5/onecall?appid=2bd3a9a6ffcb9a792ca0753f462e1081&units=metric&exclude=minutely,alerts"
    
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(error!))
            }
            if let safeData = data {
                do {
                    let result = try JSONDecoder().decode(WeatherData.self, from: safeData)
                    let data: WeatherData = result
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
