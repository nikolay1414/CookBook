//
//  FavoriteViewController.swift
//  CookBook
//
//  Created by Alexander Altman on 26.02.2023.
//

import UIKit

class FavoriteViewController: UIViewController {    
    var tableView = UITableView()
    let networkManager = NetworkManager()
    let favoriteManager = FavoriteManager()
    var recipes: [Recipe] = []
    
    private let backGround: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "Chef-PNG-Cutout")
//        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backGround)
        setBackground()
        fetchFavouriteRecipes()
        createTable()
        setupNavigationDar()
        setupConstraints()
        view.addSubview(tableView)
        
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
//        setBackground()
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        dismissAlert()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recipes = []
        fetchFavouriteRecipes()
        setBackground()
        self.view.layoutIfNeeded()
    }
    
    func setBackground() {
        if tableView.visibleCells.isEmpty {
            tableView.backgroundColor = .clear
        } else {
//            view.backgroundColor = Theme.appColor
            tableView.backgroundColor = Theme.appColor
        }
    }
    
    internal func dismissAlert() {
        if let vc = self.presentedViewController, vc is UIAlertController {
            dismiss(animated: false, completion: nil)
        }
    }
    
    
    
}
//MARK: - TableView
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    //создание TableView
    func createTable() {
        view.addSubview(tableView)
//        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.register(FavouritesTableViewCell.self, forCellReuseIdentifier: FavouritesTableViewCell.reuseId)
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.rowHeight = 130
        tableView.reloadData()

        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    //установка количество строк
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipes.count
    }
    
    //установка текста и изображения в TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouritesTableViewCell.reuseId, for: indexPath)
        guard let newCell = cell as? FavouritesTableViewCell else {
            showErrorAlert(error: SearchError.errorConfigureCell)
            return cell
        }
        let recipe = recipes[indexPath.row]
        newCell.configureCell(for: recipe, with: nil)
        guard let image = recipe.image else { return newCell }
        
        networkManager.fetchImage(for: .recipe, with: image.changeImageSize(to: .small), size: ImageSizes.small.rawValue) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    newCell.configureCell(for: recipe, with: UIImage(data: data))
                case .failure(let error):
                    self.showErrorAlert(error: error)
                }
            }
        }
        
        return newCell
    }
    
    //    Захват выбранной строки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var detailViewController: RecipeDetailViewController!
        detailViewController = RecipeDetailViewController(with: recipes[indexPath.row], index: indexPath)
        present(detailViewController, animated: true)
    }
    
    //удаление строк
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDeleteItem = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, result) in
            
            self.favoriteManager.deleteFromFavorite(recipeID: self.recipes[indexPath.row].id) { results in
                switch results {
                    
                case .success(_):
                    self.recipes.remove(at: indexPath.row)
                    tableView.reloadData()
                case .failure(let error):
                    self.showErrorAlert(error: error)
                }
                result(true)
            }
        }
        actionDeleteItem.backgroundColor = .red
        let swipeAction = UISwipeActionsConfiguration(actions: [actionDeleteItem])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
        
    }
    
    
}
//MARK: - настройка NavigationBar

extension FavoriteViewController {
    
    func setupNavigationDar () {
        //установка хэдера
        let label = UILabel()
        label.text = "Favorite"
        label.textColor = .orange
        label.font = UIFont(name: "AvenirNextCondensed-Bold", size: 50)
        navigationItem.titleView = label
        navigationController?.navigationBar.backgroundColor = .none
    }
}
//MARK: -  constaints
extension FavoriteViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backGround.heightAnchor.constraint(equalToConstant: 300),
            backGround.widthAnchor.constraint(equalToConstant: 300),
            backGround.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backGround.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func fetchFavouriteRecipes() {
        favoriteManager.getAllRecipeFromFavorite { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let recipesData):
                    self.recipes = recipesData
                    self.tableView.reloadData()
                case .failure(let error):
                    self.showErrorAlert(error: error)
                }
            }
        }
    }
}

extension FavoriteViewController {
    func showErrorAlert(error: Error) {
        
        let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default) { alertAction in
            return
        }
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
    }
}
