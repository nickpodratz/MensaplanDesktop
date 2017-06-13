//
//  Date+.swift
//  
//
//  Created by Nick Podratz on 22.12.16.
//
//

import Foundation

extension Date {
    
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

