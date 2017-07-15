//
//  NSNumber+.swift
//  MensaplanDesktop
//
//  Created by Nick Podratz on 22.12.16.
//  Copyright © 2016 Nick Podratz. All rights reserved.
//

import Foundation

extension NSNumber {
    
    var germanCurrencyFormatted: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "de_DE")
        return formatter.string(from: self)
    }
    
    
}

