////
////  FilterView.swift
////  CookBook
////
////  Created by Sergey on 12.03.2023.
////
//
//import Foundation
//import UIKit
//import TagListView
//
//class FilterView: CustomView {
//    private let contentView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    private let cuisineLabel: UILabel = {
//        createLabel(with: "Select Cuisine")
//    }()
//    
//    let cuisineFieldContainer: UIView = {
//        createTextField(with: "Select cuisine", rightView: "chevron.down", editable: false)
//    }()
//    
//    private let dietLabel: UILabel = {
//        createLabel(with: "Diet")
//    }()
//    
//    let dietFieldContainer: UIView = {
//        createTextField(with: "Select diet", rightView: "chevron.down", editable: false)
//    }()
//    
//    private let intolerancesLabel: UILabel = {
//        createLabel(with: "Intolerances")
//    }()
//    
//    let intolerancesView: TagListView = {
//        let tagList = TagListView()
//        // Change properties here
//        tagList.textFont = UIFont.preferredFont(forTextStyle: .body)
//        
//        tagList.tagBackgroundColor = UIColor.systemGray6
//        tagList.tagSelectedBackgroundColor = UIColor.systemOrange
//        tagList.textColor = UIColor.systemGray
//        tagList.selectedTextColor = .label
//        
//        tagList.paddingX = 8
//        tagList.paddingY = 8
//        tagList.alignment = .leading
//        
//        tagList.addTags(["Dairy","Egg","Gluten","Grain","Peanut",
//                         "Seafood","Sesame","Shellfish","Soy",
//                         "Sulfite","Tree Nut","Wheat"])
//        
//        for tag in tagList.tagViews {
//            tag.layer.cornerRadius = 5
//        }
//        tagList.translatesAutoresizingMaskIntoConstraints = false
//        return tagList
//    }()
//    
//    let cuisinePicker = UIPickerView()
//    let dietPicker = UIPickerView()
//    
//    private let caloriesLabel: UILabel = {
//        createLabel(with: "Calories")
//    }()
//    
//    let caloriesSlider: UISlider = {
//        let slider = UISlider()
//        slider.minimumValue = 0
//        slider.maximumValue = 2500
//        slider.tintColor = .systemGreen
//        slider.minimumValueImage = UIImage(systemName: "flame")
//        slider.maximumValueImage = UIImage(systemName: "flame.fill")
//        slider.translatesAutoresizingMaskIntoConstraints = false
//        return slider
//    }()
//    
//    private let leftCaloriesLabel: UILabel = {
//        let label = UILabel()
//        label.text = "0"
//        label.textColor = .secondaryLabel
//        label.font = UIFont.preferredFont(forTextStyle: .footnote)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let rightCaloriesLabel: UILabel = {
//        let label = UILabel()
//        label.text = "2500"
//        label.textColor = .secondaryLabel
//        label.font = UIFont.preferredFont(forTextStyle: .footnote)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let currentCalories: UILabel = {
//        let label = UILabel()
//        label.text = "Max calories: 0"
//        label.textColor = .label
//        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    override func setViews() {
//        super.setViews()
//        addSubview(contentView)
//        contentView.addSubview(cuisineLabel)
//        contentView.addSubview(cuisineFieldContainer)
//        contentView.addSubview(dietLabel)
//        contentView.addSubview(dietFieldContainer)
//        contentView.addSubview(intolerancesLabel)
//        contentView.addSubview(intolerancesView)
//        contentView.addSubview(caloriesLabel)
//        contentView.addSubview(caloriesSlider)
//        contentView.addSubview(leftCaloriesLabel)
//        contentView.addSubview(rightCaloriesLabel)
//        contentView.addSubview(currentCalories)
//        
//        if let cuisineTextField = cuisineFieldContainer.subviews.first as? FilterTextField,
//           let dietTextField = dietFieldContainer.subviews.first as? FilterTextField {
//            cuisineTextField.inputView = cuisinePicker
//            dietTextField.inputView = dietPicker
//        }
//    }
//    
//    override func layoutViews() {
//        super.layoutViews()
//        
//     
//    }
//}
//
//// Private support functions
//private extension FilterView {
//    // Created to avoid code duplication
//    static func createTextField(with placeholder: String?, rightView: String, editable: Bool) -> UIView {
//        let container = UIView()
//        container.backgroundColor = .systemBackground
//        container.layer.cornerRadius = 10
//        container.translatesAutoresizingMaskIntoConstraints = false
//        
//        let textField = editable ? UITextField() : FilterTextField()
//        textField.rightView = UIImageView(image: UIImage(systemName: rightView))
//        textField.rightViewMode = .always
//        textField.placeholder = placeholder
//        textField.rightView?.tintColor = .label
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.textColor = .label
//        
//        container.addSubview(textField)
//        
//        textField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
//        textField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20).isActive = true
//        textField.topAnchor.constraint(equalTo: container.topAnchor, constant: 5).isActive = true
//        textField.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -5).isActive = true
//        
//        return container
//    }
//    
//    static func createLabel(with text: String) -> UILabel {
//        let label = UILabel()
//        label.text = text
//        label.textColor = .secondaryLabel
//        label.font = .preferredFont(forTextStyle: .callout)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }
//}
