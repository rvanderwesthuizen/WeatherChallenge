//
//  DailyWeatherTableViewModel.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/06.
//

import Foundation

class DailyWeatherTableViewCellModel {
    
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
