//
//  FavouritesTableViewCell.swift
//  CookBook
//
//  Created by Sergey on 12.03.2023.
//

import Foundation
import UIKit

class FavouritesTableViewCell: RecipesTableViewCell {
    static let reuseId = "FavouritesTableViewCell"
    
    override func layoutViews() {
        super.layoutViews()
        recipeNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
    }
}
