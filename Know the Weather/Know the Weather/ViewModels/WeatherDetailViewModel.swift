//
//  WeatherDetailViewModel.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/17.
//

import Foundation

class WeatherDetailViewModel {
    var tempInfo = ""
    var summary = ""
    var feelsLikeInfo = ""
    var windInfo = ""
    var pressureInfo = ""
    var chanceOfRainInfo = ""
    var humidityInfo = ""
    var cloudsInfo = ""
    var sunriseInfo = ""
    var sunsetInfo = ""
    
    func setupInfoLabelsText(with current: Current, chanceOfRain: String) {
        feelsLikeInfo = "\(current.feelsLike)°"
        windInfo = "\(windDirectionFromDeg(current.windDeg)) \(current.windSpeed)m/s"
        pressureInfo = "\(current.pressure)"
        chanceOfRainInfo = chanceOfRain
        humidityInfo = "\(current.humidity)%"
        cloudsInfo = "\(current.clouds)%"
        sunriseInfo = getTimeForSun(Date(timeIntervalSince1970: Double(current.sunrise)))
        sunsetInfo = getTimeForSun(Date(timeIntervalSince1970: Double(current.sunset)))
    }
    
    func setupInfoLabelsText(with day: Daily) {
        feelsLikeInfo = "\(day.feelsLike.day)°"
        windInfo = "\(windDirectionFromDeg(day.windDeg)) \(day.windSpeed)m/s"
        pressureInfo = "\(day.pressure)"
        chanceOfRainInfo = "\(day.chanceOfRain)%"
        humidityInfo = "\(day.humidity)%"
        cloudsInfo = "\(day.clouds)%"
        sunriseInfo = getTimeForSun(Date(timeIntervalSince1970: Double(day.sunrise)))
        sunsetInfo = getTimeForSun(Date(timeIntervalSince1970: Double(day.sunset)))
    }
    
    func setupHeaderLabelsText(with current: Current) {
        feelsLikeInfo = "FeelsLike: \(current.feelsLike)°"
        summary = current.weather[0].description
        tempInfo = "\(current.temp)°"
    }
    
    func setupHeaderLabelsText(with dayWeather: Daily) {
        feelsLikeInfo = "\(dayWeather.feelsLike.day)°"
        summary = dayWeather.weather[0].description
        tempInfo = "\(dayWeather.temp.day)°"
    }
    
    private func getTimeForSun(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    func getTitleFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }
    
    private func windDirectionFromDeg(_ degrees : Double) -> String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let i: Int = Int((degrees + 11.25)/22.5)
        return directions[i % 16]
    }
}
