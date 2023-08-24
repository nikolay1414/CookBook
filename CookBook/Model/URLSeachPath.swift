//
//  URLSeachPath.swift
//  CookBook
//
//  Created by Sergey on 02.03.2023.
//

import Foundation

enum SearchPath: String {
    case complexSearch = "/recipes/complexSearch"
    case random = "/recipes/random"
    case findByNutrients = "/recipes/findByNutrients"
    case findByIngredients = "/recipes/findByIngredients"
    case findByID = "/recipes/informationBulk"
}
