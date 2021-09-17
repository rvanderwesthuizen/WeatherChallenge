//
//  DetailWeatherTableViewCell.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/16.
//

import UIKit

class DetailWeatherTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var informationLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    static let identifier = "DetailWeatherTableViewCell"
    
    static let nib = UINib(nibName: "DetailWeatherTableViewCell", bundle: nil)
    
    func configureWith(scope: WeatherScope, day: Daily , index: Int) {
        switch scope {
        case .current(let current):
            switch index {
            case 0:
                setupDisplayWith(title: "FeelsLike", image: UIImage(systemName: "thermometer")!, information: "\(current.feelsLike)°")
            case 1:
                setupDisplayWith(title: "Wind", image: UIImage(systemName: "wind")!, information: "\(windDirectionFromDeg(current.windDeg)) \(current.windSpeed)m/s")
            case 2:
                setupDisplayWith(title: "Pressure", image: UIImage(systemName: "aqi.medium")!, information: "\(current.pressure)")
            case 3:
                setupDisplayWith(title: "Chance of rain", image: UIImage(systemName: "cloud.rain")!, information: "\(day.chanceOfRain)%")
            case 4:
                setupDisplayWith(title: "Humidity", image: UIImage(named: "humidity")!, information: "\(current.humidity)%")
            default:
                return
            }
        case .daily(_):
            switch index {
            case 0:
                setupDisplayWith(title: "FeelsLike", image: UIImage(systemName: "thermometer")!, information: "\(day.feelsLike.day)°")
            case 1:
                setupDisplayWith(title: "Wind", image: UIImage(systemName: "wind")!, information: "\(windDirectionFromDeg(day.windDeg)) \(day.windSpeed)m/s")
            case 2:
                setupDisplayWith(title: "Pressure", image: UIImage(systemName: "aqi.medium")!, information: "\(day.pressure)")
            case 3:
                setupDisplayWith(title: "Chance of rain", image: UIImage(systemName: "cloud.rain")!, information: "\(day.chanceOfRain)%")
            case 4:
                setupDisplayWith(title: "Humidity", image: UIImage(named: "humidity")!, information: "\(day.humidity)%")
            default:
                return
            }
        }
    }
    
    func windDirectionFromDeg(_ degrees : Double) -> String {
        
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let i: Int = Int((degrees + 11.25)/22.5)
        return directions[i % 16]
    }
    
    func setupDisplayWith(title: String, image: UIImage, information: String) {
        titleLabel.text = title
        informationLabel.text = information
        iconImageView.image = image
    }
}
