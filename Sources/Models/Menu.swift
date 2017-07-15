//
//  Menu.swift
//  MensaplanDesktop
//
//  Created by Nick Podratz on 14.06.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import Moya
import SwiftyJSON

class Menu {
    
    var creationDate: Date
    var meals: [Meal]
    
    init() {
        creationDate = Date()
        meals = []
    }
    
    
    // MARK: - Convenience Properties
    
    var dates: [Date] {
        let mealsWithDates = meals.flatMap { $0.date }
        return Set(mealsWithDates).sorted()
    }
    
    var mealsByDate: [Date: [Meal]] {
        var result: [Date: [Meal]] = [:]
        for day in dates {
            result[day] = meals.filter { $0.date == day }
        }
        return result
    }
    
    var today: [Meal] {
        #if DEBUG
            return comingNext // The spoof-meals of the nearest day from now are shown such that a distant date works fine.
        #else
            return meals.filter{
                guard let date = $0.date else { return false }
                return Calendar.current.isDateInToday(date)
            }
        #endif
    }
    
    var comingNext: [Meal] {
        guard let minDate = dates.min() else { return [] }
        return mealsByDate[minDate]!
    }
    
    
    // MARK: - Convenience Initializing
    
    convenience init?(fromResponse response: Response) {
        let json = JSON(data: response.data)
        self.init(fromJSON: json)
    }
    
    convenience init?(fromJSON json: JSON) {
        self.init()
        guard let locationsJSON = json[0].dictionary else { print("No locationsJSON"); return nil }
        for locationJSON in locationsJSON {
            let locationTitle = locationJSON.value.dictionary?["title"]?.string?.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
            
            guard let menusJSON = locationJSON.value.dictionary?["menu"]?.array else { print("No menusJSON"); continue }
            for menuJSON in menusJSON {
                var date: Date?
                if let dateString = menuJSON["day"].string {
                    date = Date(from: dateString, format: "yyyy-MM-dd")
                }
                guard let mealsJSON = menuJSON["meals"].array else { print("No mealsJSON"); continue }
                for mealJSON in mealsJSON {
                    guard let mealTitle = mealJSON["title"].string else { print("No mealTitle"); continue }
                    let category = mealJSON["category"].string
                    let price = mealJSON["price"].number
                    let meal = Meal(title: mealTitle, category: category, price: price, date: date, location: locationTitle)
                    meals.append(meal)
                }
            }
        }
    }

    
}

