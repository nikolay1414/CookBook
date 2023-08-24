//
//  IngredientsCollectionView.swift
//  CookBook
//
//  Created by Sergey on 03.03.2023.
//

import UIKit

class IngredientsCollectionView: UICollectionView {

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        super.init(frame: .zero, collectionViewLayout: layout)
        
        register(IngredientsCollectionViewCell.self, forCellWithReuseIdentifier: IngredientsCollectionViewCell.reuseId)
        backgroundColor = .none
        contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class IngredientsCollectionViewCell: UICollectionViewCell {
    
    let spinner: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    static let reuseId = "IngredientsCollectionViewCell"
    
    var isImageLoaded: Bool = false
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Loading..."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var checkImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "checkmark.square")
        image.tintColor = .systemGreen
        image.contentMode = .scaleAspectFit
        image.isHidden = true
        image.alpha = 1
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setViews() {
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(checkImage)
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            checkImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            checkImage.topAnchor.constraint(equalTo: topAnchor),
            checkImage.heightAnchor.constraint(equalTo: checkImage.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

extension IngredientsCollectionViewCell {
    func configureCell(for ingredientName: String?, with image: UIImage?, isSelected: Bool?) {
        if let image = image {
            
            spinner.removeFromSuperview()
            isImageLoaded = true
            imageView.image = image
            
        } else {
            addSubview(spinner)
            spinner.makeSpinner(imageView)
        }
        if isSelected != nil {
            if isSelected == false {
                checkImage.isHidden = false
            } else {
                checkImage.isHidden = true
            }
        }
        nameLabel.text = ingredientName ?? "?"
    }
   
}


