//
//  HourWeatherCollectionViewCell.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/03.
//

import UIKit

class HourWeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var timestampLabel: UILabel!
    @IBOutlet private weak var conditionImage: UIImageView!
    
    private let viewModel = HourWeatherCollectionViewCellModel()
    
    static let identifier = "HourWeatherCollectionViewCell"
    
    static func nib() -> UINib {
        UINib(nibName: "HourWeatherCollectionViewCell", bundle: nil)
    }
    
    func configure(with model: Hourly, currentSunriseTime: Int, currentSunsetTime: Int, nextDaySunriseTime: Int) {
        tempLabel.text = "\(Measurement(value: model.roundedTemp, unit: UnitTemperature.celsius))"
        timestampLabel.text = viewModel.getTimeFromDate(Date(timeIntervalSince1970: Double(model.time)))
        conditionImage.contentMode = .scaleAspectFit
        conditionImage.image = UIImage(named: viewModel.conditionImage(
                                        conditionID: model.weather[0].id,
                                        hour: model.time,
                                        currentSunsetTime: currentSunsetTime,
                                        currentSunriseTime: currentSunriseTime,
                                        nextDaySunriseTime: nextDaySunriseTime))
    }
    
}
