//
//  StringProtocol.swift
//  CookBook
//
//  Created by Sergey on 03.03.2023.
//

import Foundation

extension StringProtocol {
    func changeImageSize(to size: ImageSizes) -> String {
        let imageName = self.dropLast(11)
        let finalString = imageName + size.rawValue + ".jpg"
        return finalString
    }
}
