//
//  CustomSerchBar.swift
//  CookBook
//
//  Created by Sergey on 11.03.2023.
//


import UIKit



class CustomSearchBar: UISearchBar {
    
    enum Names {
        static let searchField = "searchField"
        static let slider = "slider.horizontal.3"
    }
    
    
    
    lazy var textField: UITextField? = {
        guard let textField = value(forKey: Names.searchField) as? UITextField else {
            print("ERROR: Can't get UITextField from SearchBar")
            return nil
        }
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setViews() {
        placeholder = "Search recipes here..."
        scopeButtonTitles = ["Any", "Breakfast", "Snack", "Main course", "Side dish"]
        guard let textField = textField else {
            return
        }
        
        textField.leftView?.tintColor = .systemGreen
        textField.layer.shadowOffset = CGSize(width: 0, height: 4)
        textField.layer.shadowOpacity = 0.25
        searchTextField.textColor = .label
        let textFieldBackground = textField.subviews.first
        textFieldBackground?.subviews.forEach({ $0.removeFromSuperview() })
        
    }
    
    func layoutViews() {
        
        guard let textField = textField else {
            return
        }
        
        
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            
        ])
    }
}



