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
    let feelsLike: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windDeg: Double
    let weather: [Weather]
    
    private enum CodingKeys: String, CodingKey {
        case time = "dt"
        case sunrise = "sunrise"
        case sunset = "sunset"
        case feelsLike = "feels_like"
        case temp = "temp"
        case humidity = "humidity"
        case pressure = "pressure"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather = "weather"
    }
}

struct Hourly: Codable {
    let time: Int
    let temp: Double
    let feelsLike: Double
    let chanceOfRain: Double
    let weather: [Weather]
    
    private enum CodingKeys: String, CodingKey {
        case time = "dt"
        case temp = "temp"
        case feelsLike = "feels_like"
        case chanceOfRain = "pop"
        case weather = "weather"
    }
}

struct Daily: Codable {
    let time: Int
    let temp: Temp
    let sunrise: Int
    let sunset: Int
    let feelsLike: Feel
    let chanceOfRain: Double
    let weather: [Weather]
    
    private enum CodingKeys: String, CodingKey {
        case time = "dt"
        case temp = "temp"
        case sunrise = "sunrise"
        case sunset = "sunset"
        case feelsLike = "feels_like"
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
