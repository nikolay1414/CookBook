//
//  TimeManager.swift
//  CookBook
//
//  Created by Sergey on 07.03.2023.
//

import Foundation

struct MealTime {
    static func getMealTime() -> [String] {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH"
        
        let currentHour = Int(dateFormatter.string(from: currentDate))
        
        var result = ["Good morning!", "Breakfast"]
        if let currentHour = currentHour {
            switch currentHour {
            case let currentHour where 6...11 ~= currentHour:
                break
            case let currentHour where 12...16 ~= currentHour:
                result = ["Good afternoon!", "Lunch"]
            case let currentHour where 17...23 ~= currentHour:
                result = ["Good evening!", "Dinner"]
            case let currentHour where 0...5 ~= currentHour:
                result = ["Good night!", "Snacks"]
            default:
                print("Wrong hours!")
            }
            
        }
        return result
    }
}
