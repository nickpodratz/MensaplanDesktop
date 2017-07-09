//
//  Date+.swift
//  
//
//  Created by Nick Podratz on 22.12.16.
//
//

import Foundation

extension Date {
    
    var germanFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }

    var germanWeekdayFormatted: String {
        let formatter = DateFormatter()
        if componentValue(.year) == Date().componentValue(.year) {
            formatter.dateFormat = "EEEE, d.M."
        } else {
            formatter.dateFormat = "EEEE, d.M.YY"
        }
        return formatter.string(from: self)
    }
    
    func componentValue(_ unitFlags: Calendar.Component) -> Int {
        return Calendar.current.component(unitFlags, from: self)
    }
    
    init? (from string: String, format: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: string) else { return nil }
        self = date
    }
    
    
}

