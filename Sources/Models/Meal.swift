//
//  Meal.swift
//  HPI-Mobile
//
//  Created by Nick Podratz on 12.12.16.
//  Copyright © 2016 HPI Mobile Developer Klub. All rights reserved.
//

import Moya
import SwiftyJSON

class Meal: NSObject {

    var title: String
    var category: String?
    var price: NSNumber?
    var date: Date?
    var location: String?
    var imageUrl: URL?
    
    init(title: String, category: String?, price: NSNumber?, date: Date?, location: String?, imageUrl: URL? = nil) {
        self.title = title
        self.category = category
        self.price = price
        self.date = date
        self.location = location
        self.imageUrl = imageUrl
    }
    
    
    // MARK: - Convenience Properties
    
    var priceString: String? {
        guard let price = price else { return nil }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        return numberFormatter.string(from: price)
    }
    
    var locationCategoryString: String {
        var result = ""
        if let location = location {
            result.append(location)
        }
        if let category = category {
            if !result.isEmpty {
                result.append(": ")
            }
            result.append(category)
        }
        return result
    }
    
    
    // MARK: - Custom String Convertible
    
    override var description: String {
        let dateString = date?.germanFormatted
        let priceString = price?.germanCurrencyFormatted
        let description = [dateString, location, category, title, priceString].flatMap{$0}.joined(separator: " > ")
        return "🍕 \(description)"
    }
    
    
    // MARK: - JSON Deserializing
    
    static func array(fromResponse response: Response) -> [Meal] {
        let json = JSON(data: response.data)
        return Meal.array(fromJSON: json)
    }
    
    static func array(fromJSON json: JSON) -> [Meal] {
        var meals: [Meal] = []
        
        guard let locationsJSON = json[0].dictionary else { print("No locationsJSON"); return [] }
        for locationJSON in locationsJSON {
            let locationTitle = locationJSON.value.dictionary?["title"]?.string
            guard let menusJSON = locationJSON.value.dictionary?["menu"]?.array else { print("No menusJSON"); continue }
            for menuJSON in menusJSON {
                let date: Date? = {
                    guard let dateString = menuJSON["day"].string else { return nil }
                    return Date(from: dateString, format: "yyyy-MM-dd")
                }()
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
        return meals
    }
    
    
}

