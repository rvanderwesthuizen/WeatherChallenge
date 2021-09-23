//
//  WeatherData.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/08/31.
//

import Foundation

struct WeatherData: Codable {
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
}
struct Current: Codable {
    let time: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feelsLikeTemp: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windDeg: Double
    let clouds: Double
    let weather: [Weather]
    
    var isDayTime: Bool {
        time < sunset && time >= sunrise
    }
    
    private enum CodingKeys: String, CodingKey {
        case time = "dt"
        case sunrise = "sunrise"
        case sunset = "sunset"
        case feelsLikeTemp = "feels_like"
        case temp = "temp"
        case humidity = "humidity"
        case pressure = "pressure"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case clouds = "clouds"
        case weather = "weather"
    }
}

struct Hourly: Codable {
    let time: Int
    let temp: Double
    let weather: [Weather]
    
    private enum CodingKeys: String, CodingKey {
        case time = "dt"
        case temp = "temp"
        case weather = "weather"
    }
}

struct Daily: Codable {
    let time: Int
    let sunrise: Int
    let sunset: Int
    let temp: Temp
    let feelsLikeTemp: Feel
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windDeg: Double
    let clouds: Double
    let chanceOfRain: Double
    let weather: [Weather]
    
    private enum CodingKeys: String, CodingKey {
        case time = "dt"
        case sunrise = "sunrise"
        case sunset = "sunset"
        case temp = "temp"
        case feelsLikeTemp = "feels_like"
        case humidity = "humidity"
        case pressure = "pressure"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case clouds = "clouds"
        case chanceOfRain = "pop"
        case weather = "weather"
    }
}

struct  Feel: Codable {
    let day: Double
}

struct Temp: Codable {
    let day: Double
    let min: Double
    let max: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
}
