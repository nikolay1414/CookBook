//
//  PopularCreatorsCollectionViewCell.swift
//  CookBook
//
//  Created by Михаил Позялов on 28.02.2023.
//

import UIKit

class PopularCreatorsCollectionViewCell: UICollectionViewCell {
    
    private let popularCreatorsImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let popularCreatorsLabel: UILabel = {
       let label = UILabel()
        label.text = "Some text"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
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
    
    func setupView() {
        backgroundColor = Theme.whiteColor

        addSubview(popularCreatorsImageView)
        addSubview(popularCreatorsLabel)
    }
    
    func configureCell(creatorImageName: String, creatorName: String) {
        popularCreatorsImageView.image = UIImage(named: creatorImageName)
        popularCreatorsLabel.text = creatorName
    }
    
    func setConstraints() {
        
        NSLayoutConstraint.activate([
            popularCreatorsImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            popularCreatorsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            popularCreatorsImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            popularCreatorsImageView.bottomAnchor.constraint(equalTo: popularCreatorsLabel.topAnchor, constant: -10),
            
            popularCreatorsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            popularCreatorsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            popularCreatorsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            popularCreatorsLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
        
    }
}
