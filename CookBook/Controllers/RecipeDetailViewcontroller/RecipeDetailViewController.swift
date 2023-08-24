//
//  RecipeDetailViewController.swift
//  CookBook
//
//  Created by Sergey on 03.03.2023.
//

import UIKit


class RecipeDetailViewController: CustomViewController<RecipeDetailView> {
    // Create Enum for image size
    enum IngredientsSizes {
        static let small = "100x100"
        static let medium = "250x250"
        static let big = "500x500"
    }
    // Dictionary for save checked ingredients when CollectionView is scrolling
    var selectedIngredients: [Int: Bool] = [:]
    
    private var recipeData: Recipe!
    private var ingredients: [Ingredient] = []
    private var sourceUrl: URL?
    private var index: IndexPath!
    
    private var favoriteManager = FavoriteManager()
    private var networkManager = NetworkManager()
    
    
    init(with recipeData: Recipe, index: IndexPath) {
        self.recipeData = recipeData
        if let ingredients = recipeData.extendedIngredients {
            self.ingredients = ingredients
            for key in 0...ingredients.count {
                // Save to dictionary all ingredients and status of visible checkedImage
                self.selectedIngredients[key] = true
            }
        }
        self.index = index
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Loading recipe detail view (general information)
    
    override func loadView() {
        view = RecipeDetailView(with: recipeData.nutrition)
        configureViewWithData()
    }
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRecipeImage(with: recipeData.image)
        customView.backgroundDimmedLayer.frame = customView.backgroundImageView.bounds
        customView.delegate = self
        customView.ingredientsCollectionView.delegate = self
        customView.ingredientsCollectionView.dataSource = self
    }
    
    // Make size and effects
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customView.backgroundDimmedLayer.frame = customView.backgroundImageView.bounds
        let backLayer = customView.backButton
        let favoriteLayer = customView.favoriteButton
        backLayer.layer.cornerRadius = 0.5 * backLayer.bounds.size.width
        favoriteLayer.layer.cornerRadius = 0.5 * favoriteLayer.bounds.size.width
    }
}

// MARK: - DetailViewDelegate

extension RecipeDetailViewController: DetailViewDelegate {
    func detailView(didTapFavoriteButton button: FavoriteButton) {
        let recipeID = recipeData.id
        if button.isFavorite == false {
            
            print("Recipe ID is: \(recipeID)")
            let image = customView.backgroundImageView.image?.pngData()
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
    
    func detailView(didTapBackButton button: UIButton) {
        dismiss(animated: true)
    }
    
    func detailView(didTapInstructionsButton button: UIButton) {
        if let url = sourceUrl {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension RecipeDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    //Mark selected ingredient
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? IngredientsCollectionViewCell {
            cell.checkImage.isHidden.toggle()
            selectedIngredients.updateValue(cell.checkImage.isHidden, forKey: indexPath.row)
        }
    }
    
    //Create CollectionViewCell content
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientsCollectionViewCell.reuseId, for: indexPath) as! IngredientsCollectionViewCell
        let ingredient = ingredients[indexPath.row]
        cell.configureCell(for: ingredient.name, with: nil, isSelected: selectedIngredients[indexPath.row])
        if let imageName = ingredient.image {
            networkManager.fetchImage(for: .ingredient, with: imageName, size: IngredientsSizes.small) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let imageData):
                        cell.configureCell(for: ingredient.name, with: UIImage(data: imageData), isSelected: nil)
                    case .failure(let error):
                        self.showErrorAlert(error: error)
                    }
                }
            }
        }
        return cell
    }
}


extension RecipeDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 50, height: 70)
    }
}


private extension RecipeDetailViewController {
    
    func loadRecipeImage(with name: String?) {
        customView.spinner.makeSpinner(customView.backgroundImageView)
        guard let imageName = name else { return }
        networkManager.fetchImage(for: .recipe, with: imageName.changeImageSize(to: ImageSizes.huge), size: IngredientsSizes.small) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.customView.spinner.removeFromSuperview()
                    self.customView.backgroundImageView.image = UIImage(data: data)
                case .failure(let error):
                    self.showErrorAlert(error: error)
                }
            }
        }
    }
    
    //Make view content (tags, ingredients label, preparations label)
    
    func configureViewWithData() {
        customView.backgroundColor = .systemBackground
        customView.titleLabel.text = recipeData.title
        customView.sourceLabel.text = "by: \(recipeData.sourceName ?? "uknown")"
        
        // Форматирование времени приготовления
        let hours = recipeData.readyInMinutes / 60
        let minutes = recipeData.readyInMinutes % 60
        let timeString: String
        if hours > 0 {
            timeString = "\(hours) h \(minutes) min"
        } else {
            timeString = "\(minutes) min"
        }
        customView.prepTimeLabel.text = "Time: \(timeString)"
        
        populateTags(with: recipeData)
        populateIngredientInfo(with: recipeData.extendedIngredients)
        populatePreparationInfo(with: recipeData.analyzedInstructions)
        
        if favoriteManager.checkForFavorite(recipeID: recipeData.id) {
            customView.favoriteButton.setActive()
        }
    }
    
    func populateTags(with recipe: Recipe) {
        let cuisineTags = recipe.cuisines
        let dishTags = recipe.dishTypes
        let dietTags = recipe.diets
        let occasionTags = recipe.occasions
        
        customView.tagsListView.addTags(cuisineTags + dishTags + dietTags + occasionTags)
        customView.tagsListView.tagViews.forEach { tagView in
            guard let tagTitle = tagView.titleLabel?.text else {
                return
            }
            tagView.setTitle(tagTitle, for: .normal)
            if cuisineTags.contains(tagTitle) {
                tagView.textColor = .systemOrange
            }
            if dietTags.contains(tagTitle) {
                tagView.textColor = .systemGreen
            }
            if occasionTags.contains(tagTitle) {
                tagView.textColor = .systemPurple
            }
            tagView.cornerRadius = 5
        }
    }
    
    func populateIngredientInfo(with ingredients: [Ingredient]?) {
        
        guard let ingredients = ingredients else { return }
        let finalString = NSMutableAttributedString()
        let symAtr = [NSAttributedString.Key.foregroundColor : UIColor.systemGreen]
        let sym = NSMutableAttributedString(string: " ➳ ", attributes: symAtr)
        for ingredient in ingredients {
            if let textInfo = ingredient.original {
                let string = NSMutableAttributedString(string: "\(textInfo)\n")
                finalString.append(sym)
                finalString.append(string)
            }
        }
        customView.ingredientsInfoLabel.attributedText = finalString
    }
    
    // MARK: - The funny thing
    func populatePreparationInfo(with instructions: [Instruction]) {
        
        guard let instruction = instructions.first,
              instruction.steps.capacity != 1
        else {
            if let url = URL(string: recipeData.sourceUrl) {
                sourceUrl = url
                customView.buildLinkButton()
            }
            return
        }
        let finalString = NSMutableAttributedString()
        let indexAtr = [NSAttributedString.Key.foregroundColor : UIColor.systemGreen]
        for step in instruction.steps {
            let indexString = NSMutableAttributedString(string: "\(step.number)." ,attributes: indexAtr)
            let string = NSMutableAttributedString(string: "  \(step.step)\n\n")
            finalString.append(indexString)
            finalString.append(string)
        }
        customView.buildInstructions(with: finalString)
    }
}

extension RecipeDetailViewController {
    func showErrorAlert(error: Error) {
        
        let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default) { alertAction in
            return
        }
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
    }
}
