//
//  GlobalEnums.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/16.
//

import Foundation

enum WeatherScope {
    case current(Current)
    case daily(Daily)
}

extension DateFormatter {
    private static let formatter = DateFormatter()
    
    static let time: DateFormatter = {
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    static let weekday: DateFormatter = {
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    static let dayAndDate: DateFormatter = {
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }()
    
}
