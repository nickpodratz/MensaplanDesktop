//
//  Date+.swift
//  
//
//  Created by Nick Podratz on 22.12.16.
//
//

import Foundation

extension Date {
    
    var isToday: Bool {
        return Calendar.current.isDate(self, inSameDayAs: Date())
    }
    
    var isTomorrow: Bool {
        guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) else { return false }
        return Calendar.current.isDate(self, inSameDayAs: tomorrow)
    }

    var germanDateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }
    
    init? (from string: String, format: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: string) else { return nil }
        self = date
    }
    
    
}

