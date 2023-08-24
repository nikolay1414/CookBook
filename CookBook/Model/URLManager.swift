//
//  URLManager.swift
//  CookBook
//
//  Created by Sergey on 02.03.2023.
//

import Foundation


struct ApiURL {
    let path: String
    var urlQueryItems: [URLQueryItem]
}


extension ApiURL {
    
    static func searchByID(recipeID: [Int]) -> ApiURL {
        var idString: String = ""
        var i = 0
        for id in recipeID {
            if i == 0 {
                idString = String(id)
            } else {
                idString = String("\(idString),\(id)")
            }
            i = i+1
        }
        let url = ApiURL(path: SearchPath.findByID.rawValue, urlQueryItems: [
            URLQueryItem(name: "apiKey", value: Secrets.apiKey.rawValue),
            URLQueryItem(name: "ids", value: idString),
        ])
        return url
        
    }
    
    static func randomSearch(number: Int, tags: [String] = [] ) -> ApiURL {
        var tagsString: String = ""
        for string in tags {
            if string != tags.last {
                tagsString += string.lowercased() + ","
            } else {
                tagsString += string.lowercased()
            }
        }
        let url = ApiURL(path: SearchPath.random.rawValue,
                         urlQueryItems: [
                            URLQueryItem(name: "apiKey", value: Secrets.apiKey.rawValue),
                            URLQueryItem(name: "number", value: String(number)),
                            URLQueryItem(name: "tags", value: tagsString)
                         ])
        return url
    }
    
    static func searchWithFilter(_ filter: FilterProperty, query: String?, number: Int) -> ApiURL {
        
        let intolerances = arrayToString(array: filter.intolerances)
        let maxCalories: String = filter.maxCalories == nil ? "10000" : String(filter.maxCalories!)
        let url = ApiURL( path: SearchPath.complexSearch.rawValue,
                          urlQueryItems: [
                            URLQueryItem(name: "apiKey", value: Secrets.apiKey.rawValue),
                            URLQueryItem(name: "addRecipeNutrition", value: "true"),
                            URLQueryItem(name: "fillIngredients", value: "true"),
                            URLQueryItem(name: "query", value: query),
                            URLQueryItem(name: "number", value: String(number)),
                            URLQueryItem(name: "type", value: filter.type),
                            URLQueryItem(name: "cuisine", value: filter.cuisine),
                            URLQueryItem(name: "diet", value: filter.diet),
                            URLQueryItem(name: "intolerances", value: intolerances),
                            URLQueryItem(name: "maxCalories", value: maxCalories),
                            URLQueryItem(name: "sort", value: filter.sort)
            ]
        )
        return url
    }
    
    static func arrayToString (array: [String]) -> String {

        var finalString: String = ""
        for string in array {
            if string != array.last {
                finalString += string.lowercased() + ","
            } else {
                finalString += string.lowercased()
            }
        }
        return finalString
    }
    
    var url: URL? {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spoonacular.com"
        components.path = path
        components.queryItems = urlQueryItems
        
        return components.url
    }
}
