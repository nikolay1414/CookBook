//
//  SearchViewController.swift
//  CookBook
//
//  Created by Alexander Altman on 26.02.2023.
//


import UIKit

enum SearchError: LocalizedError {
    case errorConfigureCell
}

extension SearchError {
    var localizedDescription: String {
        switch self {
        case .errorConfigureCell:
            return NSLocalizedString("Cannot configure cell!", comment: "")
        
        }
    }
}

class SearchViewController: UITableViewController {

    // MARK: - Properties
    private var searchController: RecipesSearchController!
    
    private var randomRecipes: [Recipe] = []
    private var fetchedRecipes: [Recipe] = []
    
    private var isSearching: Bool = false
    private var isChangingFilters: Bool = false
    
    private var selectedSegment: Int = 0
    private var selectedMealType: String? {
        guard let scopeTitles = searchController?.searchBar.scopeButtonTitles else {
            return nil
        }
        if scopeTitles[selectedSegment] == "Any" {
            return nil
        }
        return scopeTitles[selectedSegment]
    }
    
    private let notificationCenter = NotificationCenter.default
    private let networkManager = NetworkManager()
    
    // MARK: - Life cycle
    
    override func loadView() {
        tableView = SearchTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRandomRecipes()
        configureSearchController()
        definesPresentationContext = true
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var detailViewController: RecipeDetailViewController!
        if isSearching && !fetchedRecipes.isEmpty {
            detailViewController = RecipeDetailViewController(with: fetchedRecipes[indexPath.row], index: indexPath)
        } else if !randomRecipes.isEmpty {
            detailViewController = RecipeDetailViewController(with: randomRecipes[indexPath.row], index: indexPath)
        } else {
            return
        }
        present(detailViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return fetchedRecipes.count
        }
        return Theme.countOfRecipes
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseId, for: indexPath)
        guard let newCell = cell as? SearchTableViewCell else {
            showErrorAlert(error: SearchError.errorConfigureCell)
            return cell
        }
        
        var recipe: Recipe?
        
        if isSearching {
            recipe = fetchedRecipes[indexPath.row]
        } else if randomRecipes.count != 0 {
            recipe = randomRecipes[indexPath.row]
        }
        
        newCell.configureCell(for: recipe, with: nil)
        newCell.index = indexPath
        if let image = recipe?.image {
            networkManager.fetchImage(for: .recipe, with: image.changeImageSize(to: ImageSizes.verySmall), size: nil) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        newCell.configureCell(for: recipe, with: UIImage(data: data))
                    case .failure(let error):
                        self.showErrorAlert(error: error)
                    }
                }
            }
        } else if recipe?.title != nil {
            newCell.configureCell(for: recipe, with: UIImage(systemName: "carrot.fill"))
        }
        return newCell
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let text = searchBar.text ?? ""
        fetchRecipesForSearchText(text.lowercased())
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
        if let text = searchBar.text, text.isEmpty && isSearching {
            tableView?.reloadData()
            let topRow = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: topRow, at: .top, animated: false)
            
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        selectedSegment = selectedScope
    }
}

private extension SearchViewController {
    func configureSearchController() {
        searchController = RecipesSearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.setShowsScope(true, animated: false)
    }
    
    
    func fetchRandomRecipes() {
        var filterProperty = FilterProperty()
        filterProperty.sort = "random"
        
        networkManager.fetchRecipes(.searchWithFilter(filterProperty, query: nil, number: Theme.countOfRecipes)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let recipes = data.results {
                        self.randomRecipes = recipes
                        self.tableView?.reloadData()
                    }
                case .failure(let error):
                    self.showErrorAlert(error: error)
                }
            }
        }
    }
    
    func fetchRecipesForSearchText(_ searchText: String) {

        var filterProperty = FilterProperty()
        filterProperty.sort = "random"
        networkManager.fetchRecipes(.searchWithFilter(filterProperty, query: searchText, number: Theme.countOfRecipes)) { result in
            switch result {
            case .success(let data):
                if let recipes = data.results {
                    DispatchQueue.main.async {
                        self.fetchedRecipes = recipes
                        self.isSearching = true
                        self.tableView?.reloadData()
                    }
                }
            case .failure(let error):
                self.showErrorAlert(error: error)
            }
        }
    }
}

extension SearchViewController {
    func showErrorAlert(error: Error) {
        
        let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default) { alertAction in
            return
        }
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
    }
}
