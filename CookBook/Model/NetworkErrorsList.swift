//
//  NetworkErrorsList.swift
//  CookBook
//
//  Created by Sergey on 03.03.2023.
//

import Foundation

enum NetworkError: LocalizedError {
    case wrongUrl
    case notFoundData
    case wrongImageType
    case wrongCode
}

extension NetworkError {
    var localizedDescription: String {
        switch self {
        case .wrongUrl:
            return NSLocalizedString("Invalid URL!", comment: "")
        case .notFoundData:
            return NSLocalizedString("No data from network call!", comment: "")
        case .wrongImageType:
            return NSLocalizedString("Undefined image type!", comment: "")
        case .wrongCode:
            return NSLocalizedString("Error code response", comment: "")
        }
    }
}
