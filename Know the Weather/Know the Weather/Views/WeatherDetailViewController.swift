//
//  WeatherDetailViewController.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/16.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    var scope: WeatherScope?
    var isDay: Bool?
    var conditionImageString: String?
    var chanceOfRainToday: String?
    
    @IBOutlet private weak var conditionImageView: UIImageView!
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var feelsLikeLabel: UILabel!
    @IBOutlet private weak var summaryLabel: UILabel!
    @IBOutlet private weak var feelsLikeInfoLabel: UILabel!
    @IBOutlet private weak var windInfoLabel: UILabel!
    @IBOutlet private weak var pressureInfoLabel: UILabel!
    @IBOutlet private weak var chanceOfRainInfoLabel: UILabel!
    @IBOutlet private weak var humidityInfoLabel: UILabel!
    @IBOutlet private weak var cloudsInfoLabel: UILabel!
    @IBOutlet private weak var sunriseInfoLabel: UILabel!
    @IBOutlet private weak var sunsetInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let dayTimeCheck = isDay else { return }
        guard let imageString = conditionImageString else { return }
        view.backgroundColor = (dayTimeCheck ? UIColor(patternImage: #imageLiteral(resourceName: "DaytimeBackground")) : UIColor(patternImage: #imageLiteral(resourceName: "NightimeBackground")))
        
        setupHeaderLabels(with: imageString)
        setupInfoLabels()
        
    }
    
    private func setupHeaderLabels(with imageString: String) {
        switch scope {
        case .current(let current):
                        title = getTitleFromDate(Date(timeIntervalSince1970: Double(current.time)))
            tempLabel.text = "\(current.temp)°"
            feelsLikeLabel.text = "Feels: \(current.feelsLike)°"
            summaryLabel.text = current.weather[0].description
            conditionImageView.image = UIImage(named: imageString)
        case .daily(let dayWeather):
                        title = getTitleFromDate(Date(timeIntervalSince1970: Double(dayWeather.time)))
            tempLabel.text = "\(dayWeather.temp.day)°"
            feelsLikeLabel.text = "FeelsLike: \(dayWeather.feelsLike.day)°"
            summaryLabel.text = dayWeather.weather[0].description
            conditionImageView.image = UIImage(named: imageString)
        case .none:
            return
        }
    }
    
    private func setupInfoLabels() {
        switch scope {
        case .current(let weatherInfo):
            feelsLikeInfoLabel.text = "\((weatherInfo).feelsLike)°"
            windInfoLabel.text = "\(windDirectionFromDeg(weatherInfo.windDeg)) \(weatherInfo.windSpeed)m/s"
            pressureInfoLabel.text = "\(weatherInfo.pressure)"
            chanceOfRainInfoLabel.text = chanceOfRainToday!
            humidityInfoLabel.text = "\(weatherInfo.humidity)%"
            cloudsInfoLabel.text = "\(weatherInfo.clouds)%"
            sunriseInfoLabel.text = getTimeForSun(Date(timeIntervalSince1970: Double(weatherInfo.sunrise)))
            sunsetInfoLabel.text = getTimeForSun(Date(timeIntervalSince1970: Double(weatherInfo.sunset)))
            
        case .daily(let weatherInfo):
            feelsLikeInfoLabel.text = "\(weatherInfo.feelsLike.day)°"
            windInfoLabel.text = "\(windDirectionFromDeg(weatherInfo.windDeg)) \(weatherInfo.windSpeed)m/s"
            pressureInfoLabel.text = "\(weatherInfo.pressure)"
            chanceOfRainInfoLabel.text = "\(weatherInfo.chanceOfRain)%"
            humidityInfoLabel.text = "\(weatherInfo.humidity)%"
            cloudsInfoLabel.text = "\(weatherInfo.clouds)%"
            sunriseInfoLabel.text = getTimeForSun(Date(timeIntervalSince1970: Double(weatherInfo.sunrise)))
            sunsetInfoLabel.text = getTimeForSun(Date(timeIntervalSince1970: Double(weatherInfo.sunset)))
        case .none:
            return
        }
    }
    
    private func getTimeForSun(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    private func getTitleFromDate(_ date: Date) -> String {
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
