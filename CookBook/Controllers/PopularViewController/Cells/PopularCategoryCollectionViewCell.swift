//
//  PopularCategoryCollectionViewCell.swift
//  CookBook
//
//  Created by Михаил Позялов on 28.02.2023.
//

import UIKit

class PopularCategoryCollectionViewCell: UICollectionViewCell {
    
    let favoriteManager = FavoriteManager()
    let spinner: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    var recipeID: Int?
    
    private let view: UIView = {
      let view = UIView()
        view.backgroundColor = Theme.yellowColor
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backImageView: UIView = {
      let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var favoriteButton: FavoriteButton = {
        let button = FavoriteButton(iconPointSize: 30)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = .zero
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let popularCategoryImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Theme.imageCornerRadius
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let popularCategoryLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
//        translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.addTarget(self, action: #selector(tappedFavoriteButton), for: .touchUpInside)
        
        addSubview(view)
        view.addSubview(popularCategoryLabel)
        view.addSubview(readyInMinutesLabel)
        addSubview(backImageView)
        backImageView.addSubview(popularCategoryImageView)
        view.addSubview(favoriteButton)
    }
    
    func configureCell(image: UIImage?, recipeName: String, readyInMinutes: Int, recipeID: Int) {
        if let image = image {
            spinner.removeFromSuperview()
            popularCategoryImageView.image = image
            popularCategoryImageView.layer.shadowColor = UIColor.black.cgColor
            popularCategoryImageView.layer.shadowRadius = 3.0
            popularCategoryImageView.layer.shadowOpacity = 1.0
            popularCategoryImageView.layer.shadowOffset = CGSize(width: 0, height: 15)
        } else {
            addSubview(spinner)
            spinner.makeSpinner(popularCategoryImageView)
        }
        popularCategoryLabel.text = recipeName
        
        // Форматирование времени приготовления
        let hours = readyInMinutes / 60
        let minutes = readyInMinutes % 60
        let formattedTime = hours > 0 ? "\(hours) h \(minutes) min" : "\(minutes) min"
        readyInMinutesLabel.text = "Time: \(formattedTime)"
        
        if favoriteManager.checkForFavorite(recipeID: recipeID) {
            favoriteButton.setActive()
        } else {
            favoriteButton.setInactive()
        }
        self.recipeID = recipeID
    }
    
    func setConstraints() {
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5),
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 80),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50),
            favoriteButton.widthAnchor.constraint(equalTo: favoriteButton.heightAnchor),
            
            backImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backImageView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            backImageView.widthAnchor.constraint(equalToConstant: 120),
            backImageView.heightAnchor.constraint(equalToConstant: 120),
            
            popularCategoryImageView.topAnchor.constraint(equalTo: backImageView.topAnchor, constant: 0),
            popularCategoryImageView.leadingAnchor.constraint(equalTo: backImageView.leadingAnchor, constant: 0),
            popularCategoryImageView.trailingAnchor.constraint(equalTo: backImageView.trailingAnchor, constant: 0),
            popularCategoryImageView.bottomAnchor.constraint(equalTo: backImageView.bottomAnchor, constant: 0),
            
            readyInMinutesLabel.topAnchor.constraint(equalTo: backImageView.bottomAnchor, constant: 10),
            readyInMinutesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyInMinutesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            readyInMinutesLabel.heightAnchor.constraint(equalToConstant: 15),
            readyInMinutesLabel.bottomAnchor.constraint(equalTo: popularCategoryLabel.topAnchor, constant: -5),
            
            popularCategoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            popularCategoryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            popularCategoryLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5)
        ])
    }
}

extension PopularCategoryCollectionViewCell {
    @objc func tappedFavoriteButton(_ button: FavoriteButton) {
        if let recipeID = recipeID {
            if button.isFavorite == false {
               
                print("Recipe ID is: \(recipeID)")
                let image = popularCategoryImageView.image?.pngData()
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
