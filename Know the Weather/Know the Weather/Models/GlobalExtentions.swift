//
//  GlobalExtentions.swift
//  Know the Weather
//
//  Created by Ruan van der Westhuizen on 2021/09/20.
//

import Foundation

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

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
