//
//  DailyWeatherTableViewModel.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/06.
//

import Foundation

class DailyWeatherTableViewCellModel {
    
    func conditionImage(conditionID: Int) -> String{
        let imageNamePrefix = "weezle_"
        
        switch conditionID {
        case 200...232:
            return "\(imageNamePrefix)cloud_thunder_rain"
        case 300...321:
            return "\(imageNamePrefix)medium_rain"
        case 500...531:
            return "\(imageNamePrefix)rain"
        case 600...622:
            return "\(imageNamePrefix)snow"
        case 701...781:
            return "\(imageNamePrefix)fog"
        case 800:
            return "\(imageNamePrefix)sun"
        case 801:
            return "\(imageNamePrefix)cloud_sun"
        case 802:
            return "\(imageNamePrefix)cloud"
        case 803:
            return "\(imageNamePrefix)max_cloud"
        case 804:
            return "\(imageNamePrefix)overcast"
        default:
            return "\(imageNamePrefix)sun"
        }
    }
    
    func getDayFromDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "EEEE"
        return formatter.string(from: inputDate)
    }
}
