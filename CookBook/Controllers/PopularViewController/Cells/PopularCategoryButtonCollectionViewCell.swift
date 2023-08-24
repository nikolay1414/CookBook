//
//  PopularCategoryButtonCollectionView.swift
//  CookBook
//
//  Created by Михаил Позялов on 02.03.2023.
//

//import UIKit
//
//class PopularCategoryButtonCollectionViewCell: UICollectionViewCell {
//
////     private lazy var mealLabel: UILabel = {
////        let label = UILabel()
////         label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
////         label.translatesAutoresizingMaskIntoConstraints = false
////         return label
////    }()
//
//    private lazy var mealLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 10)
//        label.textColor = .label
//        label.numberOfLines = 0
//        label.textAlignment = .center
//        label.text = "Loading..."
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        setupView()
//        setConstraints()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//
//    func setupView() {
//        addSubview(mealLabel)
//    }
//
//    func configureCell(buttonName: String) {
//        mealLabel.text = buttonName
//    }
//
//
//    func setConstraints() {
//
//        NSLayoutConstraint.activate([
//            mealLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
//            mealLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
//            mealLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
//            mealLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: 0),
//
//        ])
//
//    }
//}

import UIKit

class PopularCategoryButtonCollectionViewCell: UICollectionViewCell {
    
    lazy var mealButton: UIButton = {
        let button = UIButton(type: .system)
//        button.backgroundColor = Theme.yellowColor
//        button.tintColor = .gray
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.textAlignment = .center
//        button.titleLabel?.minimumScaleFactor = .greatestFiniteMagnitude
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        setDefaults()
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setDefaults()
    }
        
//    @objc func updateUI() {
//        backgroundColor = Theme.yellowColor
//    }
    
    func setDefaults() {
        backgroundColor = UIColor.systemGray4.withAlphaComponent(0.2)
        mealButton.titleLabel?.font = .systemFont(ofSize: 13)
        layer.cornerRadius = 10
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowColor = UIColor.systemGray.cgColor
    }
    
    func setupView() {
        addSubview(mealButton)
    }
    
    func configureCell(buttonName: String) {
        mealButton.setTitle(buttonName, for: .normal)
    }
   
    func buttonTapped() {
        mealButton.setTitleColor(UIColor.systemOrange, for: .normal)
    }
    
    func deselectButton() {
        mealButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    func setConstraints() {
        
        NSLayoutConstraint.activate([
            mealButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            mealButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            mealButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            mealButton.bottomAnchor.constraint(equalTo: topAnchor, constant: -20),
//            mealButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }

}
