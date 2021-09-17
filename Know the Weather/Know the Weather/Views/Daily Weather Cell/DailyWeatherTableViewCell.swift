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
    
    private let viewModel = DailyWeatherTableViewCellModel()
    
    static let identifier = "DailyWeatherTableViewCell"
    
    static func nib() -> UINib {
        UINib(nibName: "DailyWeatherTableViewCell", bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: Daily, conditionImageString: String){
        highTempLabel.text = "\(model.temp.max)°"
        lowTempLabel.text = "\(model.temp.min)°"
        dateLabel.text = viewModel.getDayFromDate(Date(timeIntervalSince1970: Double(model.time)))
        conditionImage.image = UIImage(named: conditionImageString)
    }
}
