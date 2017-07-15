//
//  MealService.swift
//  MensaplanDesktop
//
//  Created by Nick Podratz on 12.12.16.
//  Copyright © 2016 Nick Podratz. All rights reserved.
//

import Moya
import MoyaSugar

enum BackendService: SugarTargetType {
    
    case getMeals

    var baseURL: URL { return URL(string: "https://mobile-developer.hpi.uni-potsdam.de")! }
    
    var route: Route {
        switch self {
        case .getMeals: return .get("/mensa")
        }
    }
    
    var task: Task {
        switch self {
        case .getMeals: return .request
        }
    }
    
    var params: Parameters? {
        switch self {
        case .getMeals: return nil
        }
    }
    
    var httpHeaderFields: [String: String]? {
        return nil
    }
    
    var sampleData: Data {
        let file: File
        switch self {
        case .getMeals: file = File(name: "SampleResponses/MealsSample", suffix: "json")
        }
        do {
            return try file.readContents()
        } catch let error as File.AccessError {
            return error.jsonFormattedData ?? Data()
        } catch let error as NSError {
            return File.AccessError.other(error: error, withFile: file).jsonFormattedData ?? Data()
        }
    }
    
    
}

