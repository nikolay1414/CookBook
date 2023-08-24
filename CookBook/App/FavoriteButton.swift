//
//  FavoriteButton.swift
//  CookBook
//
//  Created by Sergey on 08.03.2023.
//

import UIKit

protocol FavoriteButtonDelegate: AnyObject {
    func tappedFavoriteButton(_ sender: FavoriteButton, recipeID: Int)
}

class FavoriteButton: UIButton {
    private var iconConfiguration: UIImage.SymbolConfiguration!
    private var defaultColor: UIColor!
    var isFavorite: Bool?
    
    init(iconPointSize: CGFloat = 35, withColor color: UIColor = .systemGray3) {
        super.init(frame: .zero)
        
        iconConfiguration = UIImage.SymbolConfiguration(pointSize: iconPointSize, weight: .medium, scale: .medium)
        let image = UIImage(systemName: "star.circle", withConfiguration: iconConfiguration)
        setImage(image, for: .normal)
        self.defaultColor = color
        tintColor = .systemGray3
        isFavorite = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setActive() {
        setImage(UIImage(systemName: "star.circle.fill", withConfiguration: iconConfiguration), for: .normal)
        tintColor = .systemGreen
        isFavorite = true
        print(isFavorite as Any)
    }
    
    func setInactive() {
        setImage(UIImage(systemName: "star.circle", withConfiguration: iconConfiguration), for: .normal)
        tintColor = defaultColor
        isFavorite = false
        print(isFavorite as Any)
    }
}

