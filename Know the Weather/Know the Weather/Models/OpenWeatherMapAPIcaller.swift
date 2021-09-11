//
//  WeatherModel.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/08/27.
//

import Foundation
import CoreLocation


struct OpenWeatherMapService {
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let urlString = "\(Constants.weatherURL)&lat=\(lat)&lon=\(lon)"
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(error!))
            }
            if let safeData = data {
                do {
                    let result = try JSONDecoder().decode(WeatherData.self, from: safeData)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
