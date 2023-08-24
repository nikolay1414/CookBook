//
//  FavoriteError.swift
//  CookBook
//
//  Created by Sergey on 11.03.2023.
//

import Foundation
enum FavoriteError: LocalizedError {
    case favoriteExist
    case cantEncode
    case notInFavorite
    case wrongCode
}

extension FavoriteError {
    var localizedDescription: String {
        switch self {
        case .favoriteExist:
            return NSLocalizedString("This recipe already in favorite list!", comment: "")
        case .cantEncode:
            return NSLocalizedString("Can`t encode data!", comment: "")
        case .notInFavorite:
            return NSLocalizedString("Recipe is not in favorite list!", comment: "")
        case .wrongCode:
            return NSLocalizedString("Error code response", comment: "")
        }
    }
}
