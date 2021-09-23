//
//  DailyWeatherTableViewCell.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/02.
//

import UIKit

class DailyWeatherTableViewCell: UITableViewCell {

    @IBOutlet private weak var highTempLabel: UILabel!
    @IBOutlet private weak var lowTempLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var conditionImage: UIImageView!
    
    static let identifier = "DailyWeatherTableViewCell"
    
    static func nib() -> UINib {
        UINib(nibName: "DailyWeatherTableViewCell", bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: Daily, conditionImageString: String){
        highTempLabel.text = "\(Measurement(value: model.temp.max, unit: UnitTemperature.celsius))"
        lowTempLabel.text = "\(Measurement(value: model.temp.min, unit: UnitTemperature.celsius))"
        dateLabel.text = DateFormatter.weekday.string(from: (Date(timeIntervalSince1970: Double(model.time))))
        conditionImage.image = UIImage(named: conditionImageString)
    }
}
