//
//  SearchController.swift
//  CookBook
//
//  Created by Sergey on 11.03.2023.
//

import UIKit

class RecipesSearchController: UISearchController {

    private let customSearchBar = CustomSearchBar()
    
    override var searchBar: CustomSearchBar {
        return customSearchBar
    }
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        searchBar.showsCancelButton = false
        searchBar.searchTextField.backgroundColor = .systemBackground
        obscuresBackgroundDuringPresentation = false
        customSearchBar.searchTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - UITextFieldDelegate
extension RecipesSearchController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        isActive = false
        return true
    }
}





