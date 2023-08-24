//
//  ImageType.swift
//  CookBook
//
//  Created by Sergey on 02.03.2023.
//

import Foundation

enum ImageType: String {
    case ingredient = "/cdn/ingredients"
    case recipe = "/recipeImages/"
}

enum ImageSizes: String {
    case mini = "90x90"
    case verySmall = "240x150"
    case small = "312x150"
    case medium = "312x231"
    case big = "480x360"
    case bigger = "556x370"
    case huge = "636x393"
}
