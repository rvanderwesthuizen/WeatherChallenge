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
    
    static let identifier = "HourWeatherCollectionViewCell"
    
    static func nib() -> UINib {
        UINib(nibName: "HourWeatherCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with model: Hourly) {
        tempLabel.text = "\(model.temp)°"
        timestampLabel.text = getTimeFromDate(Date(timeIntervalSince1970: Double(model.time)))
        conditionImage.contentMode = .scaleAspectFit
        conditionImage.image = #imageLiteral(resourceName: "NightimeBackground")
    }
    
    private func getTimeFromDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: inputDate)
    }

}
