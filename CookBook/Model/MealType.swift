//
//  MealType.swift
//  CookBook
//
//  Created by Sergey on 06.03.2023.
//

import Foundation

enum MealType: String, CaseIterable {
    case mainCourse = "Main course"
    case sideDish = "Side dish"
    case dessert = "Dessert"
    case appetizer = "Appetizer"
    case salad = "Salad"
    case bread = "Bread"
    case breakfast = "Breakfast"
    case soup = "Soup"
    case beverage = "Beverage"
    case sauce = "Sauce"
    case marinade = "Marinade"
    case fingerfood = "Fingerfood"
    case snack = "Snack"
    case drink = "Drink"
    case dinner = "Dinner"
    case lunch = "Lunch"
    
    static var mealArray: [String] = {
        return MealType.allCases.map { $0.rawValue }
    }()
    
}
