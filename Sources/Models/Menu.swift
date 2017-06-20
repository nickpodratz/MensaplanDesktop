//
//  Menu.swift
//  MensaplanDesktop
//
//  Created by Nick Podratz on 14.06.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import SwiftyJSON
import Moya

class Menu {
    
    var creationDate: Date
    var meals: [Meal]
    var byDay: [Date: [Meal]] {
        get {
            var result: [Date: [Meal]] = [:]
            for meal in meals {
                guard let date = meal.date else { continue }
                if result[date] != nil {
                    result[date]?.append(meal)
                } else {
                    result[date] = [meal]
                }
            }
            return result
        }
    }
    var today: [Meal] {
        #if DEBUG
            // The spoof-meals of the nearest day from now are shown such that a distant date works fine.
            return comingNext
        #else
            return meals.filter{ $0.date?.isToday ?? false }
        #endif
    }
    var comingNext: [Meal] {
        guard let minDate = byDay.keys.min(),
            let meals = byDay[minDate] else { return [] }
        return meals
    }
    
    init() {
        meals = []
        creationDate = Date()
    }
    
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

