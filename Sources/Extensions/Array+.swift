//
//  Array+.swift
//  MensaplanDesktop
//
//  Created by Nick Podratz on 21.06.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    var orderedSet: Array {
        var array: [Element] = []
        return flatMap {
            if array.contains($0) {
                return nil
            } else {
                array.append($0)
                return $0
            }
        }
    }
    
    
}

