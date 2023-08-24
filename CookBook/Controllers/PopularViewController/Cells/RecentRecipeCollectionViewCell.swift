//
//  RecentRecipeCollectionViewCell.swift
//  CookBook
//
//  Created by Михаил Позялов on 28.02.2023.
//

import UIKit

class RecentRecipeCollectionViewCell: UICollectionViewCell {
    
    let favoriteManager = FavoriteManager()
    let spinner: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    var recipeID: Int?
    
    private let recipeImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.contentScaleFactor = 1.0
        imageView.layer.cornerRadius = Theme.imageCornerRadius
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let recipeLabel: UILabel = {
       let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.minimumScaleFactor = 0.7
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoriteButton: FavoriteButton = {
        let button = FavoriteButton()
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = .zero
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let readyInMinutesLabel: UILabel = {
       let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favoriteButton.setInactive()
    }
    
    func setupView() {
        favoriteButton.addTarget(self, action: #selector(tappedFavoriteButton), for: .touchUpInside)
        addSubview(recipeImageView)
        addSubview(recipeLabel)
        addSubview(readyInMinutesLabel)
        addSubview(favoriteButton)
    }
    
    func configureCell(recipeImage: UIImage?, recipeName: String, readyInMinutes: Int, recipeID: Int) {
        if let image = recipeImage {
            spinner.removeFromSuperview()
            recipeImageView.image = image
            recipeImageView.layer.shadowColor = UIColor.black.cgColor
            recipeImageView.layer.shadowRadius = 3.0
            recipeImageView.layer.shadowOpacity = 1.0
            recipeImageView.layer.shadowOffset = CGSize(width: 0, height: 15)
        } else {
            addSubview(spinner)
            spinner.makeSpinner(recipeImageView)
        }
        recipeLabel.text = recipeName
        
        // Форматирование времени приготовления
        let hours = readyInMinutes / 60
        let minutes = readyInMinutes % 60
        let formattedTime = hours > 0 ? "\(hours) h \(minutes) min" : "\(minutes) min"
        readyInMinutesLabel.text = "Time: \(formattedTime)"
        
        self.recipeID = recipeID
        if favoriteManager.checkForFavorite(recipeID: recipeID) {
            favoriteButton.setActive()
        } else {
            favoriteButton.setInactive()
        }
        self.recipeID = recipeID
    }
    
    func setConstraints() {
        
        NSLayoutConstraint.activate([
            
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50),
            favoriteButton.widthAnchor.constraint(equalTo: favoriteButton.heightAnchor),
            
            recipeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            recipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            recipeImageView.bottomAnchor.constraint(equalTo: readyInMinutesLabel.topAnchor, constant: -10),
            
            readyInMinutesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            readyInMinutesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            readyInMinutesLabel.heightAnchor.constraint(equalToConstant: 15),
            readyInMinutesLabel.bottomAnchor.constraint(equalTo: recipeLabel.topAnchor, constant: -5),
            
            recipeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            recipeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            recipeLabel.heightAnchor.constraint(equalToConstant: 40),
            recipeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}

extension RecentRecipeCollectionViewCell {
    @objc func tappedFavoriteButton(_ button: FavoriteButton) {
        if let recipeID = recipeID {
            if button.isFavorite == false {
               
                print("Recipe ID is: \(recipeID)")
                let image = recipeImageView.image?.pngData()
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
    }
}
