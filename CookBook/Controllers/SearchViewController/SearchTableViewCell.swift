//
//  SearchTableViewCell.swift
//  CookBook
//
//  Created by Sergey on 11.03.2023.
//

import UIKit

class SearchTableViewCell: RecipesTableViewCell {
    
    static let reuseId = "SearchTableViewCell"
    weak var delegate: FavoriteButtonDelegate?
    let favoriteManager = FavoriteManager()
    var index: IndexPath!
    var recipeID: Int?
    var recipeImage: UIImage?
    
    let favoriteButton: FavoriteButton = {
        let button = FavoriteButton(iconPointSize: 30, withColor: .secondaryLabel)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func setViews() {
        super.setViews()
        contentView.addSubview(favoriteButton)
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
    }
    
    override func layoutViews() {
        super.layoutViews()
        NSLayoutConstraint.activate([
            recipeNameLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -5),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            favoriteButton.topAnchor.constraint(equalTo: recipeNameLabel.topAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 25),
            favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.widthAnchor)
        ])
    }
    
    
    override func configureCell(for recipe: Recipe?, with image: UIImage?) {
        super.configureCell(for: recipe, with: image)
        guard let recipe = recipe else { return }
        recipeID = recipe.id
        guard let recipeID = recipeID else { return }
        if let image = image {
            recipeImage = image
        }
        if favoriteManager.checkForFavorite(recipeID: recipeID) {
            favoriteButton.setActive()
        }
    }
}

extension SearchTableViewCell {
    @objc private func didTapFavoriteButton(_ button: FavoriteButton) {
        guard let recipeID = recipeID else { return }
        guard let recipeImage = recipeImage else { return }
       
            if button.isFavorite == false {
               
                print("Recipe ID is: \(recipeID)")
                let image = recipeImage.pngData()
                favoriteManager.addToFavorite(recipeID: recipeID, recipeImage: image) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(_):
                            button.setActive()
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                  
                }
                
            } else {
                favoriteManager.deleteFromFavorite(recipeID: recipeID) { result in
                    switch result {
                    case .success(_):
                        button.setInactive()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
               
            }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favoriteButton.setInactive()
    }
}

