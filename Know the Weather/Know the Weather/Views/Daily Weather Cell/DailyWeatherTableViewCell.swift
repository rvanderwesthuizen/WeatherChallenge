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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: Daily){
        highTempLabel.text = "\(model.temp.max)°"
        lowTempLabel.text = "\(model.temp.min)°"
        dateLabel.text = getDayFromDate(Date(timeIntervalSince1970: Double(model.time)))
        conditionImage.image = MainTableViewModel().conditionImage(conditionID: model.weather[0].id, model: model)
    }
    
    private func getDayFromDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "EEEE"
        return formatter.string(from: inputDate)
    }
}
