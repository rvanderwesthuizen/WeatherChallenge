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
    
    private let measurementsFormatter = MeasurementFormatter()
    
    init() {
        setupMeasurements()
    }
    
    func setupMeasurements(){
        measurementsFormatter.numberFormatter.maximumFractionDigits = 0
        measurementsFormatter.numberFormatter.roundingMode = .halfUp
    }
    
    func setupInfoLabelsText(with current: Current, chanceOfRain: String) {
        feelsLikeInfo = "\(measurementsFormatter.string(from: Measurement(value: current.feelsLikeTemp.rounded(), unit: UnitTemperature.celsius)))"
        windInfo = "\(windDirectionFromDeg(current.windDeg)) \(measurementsFormatter.string(from: Measurement(value: current.windSpeed, unit: UnitSpeed.metersPerSecond)))"
        pressureInfo = "\(current.pressure)"
        chanceOfRainInfo = chanceOfRain
        humidityInfo = "\(current.humidity)%"
        cloudsInfo = "\(current.clouds)%"
        sunriseInfo = getTimeFormDate(Date(timeIntervalSince1970: Double(current.sunrise)))
        sunsetInfo = getTimeFormDate(Date(timeIntervalSince1970: Double(current.sunset)))
    }
    
    func setupInfoLabelsText(with day: Daily) {
        feelsLikeInfo = "\(measurementsFormatter.string(from: Measurement(value: day.feelsLikeTemp.day, unit: UnitTemperature.celsius)))"
        windInfo = "\(windDirectionFromDeg(day.windDeg)) \(measurementsFormatter.string(from: Measurement(value: day.windSpeed, unit: UnitSpeed.metersPerSecond)))"
        pressureInfo = "\(day.pressure)"
        chanceOfRainInfo = "\(day.chanceOfRain)%"
        humidityInfo = "\(day.humidity)%"
        cloudsInfo = "\(day.clouds)%"
        sunriseInfo = getTimeFormDate(Date(timeIntervalSince1970: Double(day.sunrise)))
        sunsetInfo = getTimeFormDate(Date(timeIntervalSince1970: Double(day.sunset)))
    }
    
    func setupHeaderLabelsText(with current: Current) {
        feelsLikeInfo = "FeelsLike: \(measurementsFormatter.string(from: Measurement(value: current.feelsLikeTemp, unit: UnitTemperature.celsius)))"
        summary = current.weather[0].description
        tempInfo = "\(measurementsFormatter.string(from:Measurement(value: current.feelsLikeTemp, unit: UnitTemperature.celsius)))"
    }
    
    func setupHeaderLabelsText(with dayWeather: Daily) {
        feelsLikeInfo = "FeelsLike: \(measurementsFormatter.string(from: Measurement(value: dayWeather.feelsLikeTemp.day, unit: UnitTemperature.celsius)))"
        summary = dayWeather.weather[0].description
        tempInfo = "\(measurementsFormatter.string(from: Measurement(value: dayWeather.temp.day, unit: UnitTemperature.celsius)))"
    }
    
    private func getTimeFormDate(_ date: Date) -> String {
        DateFormatter.time.string(from: date)
    }
    
    func getTitleFromDate(_ date: Date) -> String {
        DateFormatter.dayAndDate.string(from: date)
    }
    
    private func windDirectionFromDeg(_ degrees : Double) -> String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let i: Int = Int((degrees + 11.25)/22.5)
        return directions[i % 16]
    }
}
