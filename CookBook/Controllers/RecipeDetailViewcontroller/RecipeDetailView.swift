//
//  RecipeDetailView.swift
//  CookBook
//
//  Created by Sergey on 03.03.2023.
//

import UIKit
import TagListView

protocol DetailViewDelegate: AnyObject {
    func detailView(didTapBackButton button: UIButton)
    func detailView(didTapInstructionsButton button: UIButton)
    func detailView(didTapFavoriteButton button: FavoriteButton)
}

class RecipeDetailView: CustomView {
    
    let spinner: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    init(with nutrition: Nutrition?) {
        if let nutrition = nutrition {
            nutritionCombinedView = NutritionCombinedView(nutrition: nutrition)
        }
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    weak var delegate: DetailViewDelegate?
    
    private var isRecipeNutrition: Bool = false
    
    lazy var backgroundDimmedLayer: CALayer = {
        let dimmedLayer = CALayer()
        dimmedLayer.backgroundColor = UIColor.black.cgColor
        dimmedLayer.opacity = 0.1
        return dimmedLayer
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let iconConfiguration = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium, scale: .medium)
        let image = UIImage(systemName: "arrow.left", withConfiguration: iconConfiguration)
        button.setImage(image, for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var favoriteButton: FavoriteButton = {
        let button = FavoriteButton()
        button.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var prepTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Min"
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var prepTimeIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "alarm"))
        imageView.tintColor = .secondaryLabel
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var tagsListView: TagListView = {
        let tagList = TagListView()
        tagList.textColor = .secondaryLabel
        tagList.tagBackgroundColor = .secondaryLabel.withAlphaComponent(0.15)
        tagList.textFont = UIFont.preferredFont(forTextStyle: .subheadline)
        tagList.isUserInteractionEnabled = false
        
        tagList.paddingY = 7
        tagList.paddingX = 11
        tagList.alignment = .leading
        
        tagList.translatesAutoresizingMaskIntoConstraints = false
        return tagList
    }()
    
    lazy var nutritionTitleLabel: UILabel = {
        RecipeDetailView.createTitleLabel(with: "Nutrition")
    }()
    
    private lazy var nutritionDivider: UIView = {
        RecipeDetailView.createDivider()
    }()
    
    var nutritionCombinedView: NutritionCombinedView?
    
    private lazy var ingredientsTitleLabel: UILabel = {
        RecipeDetailView.createTitleLabel(with: "Ingredients")
    }()
    
    private lazy var ingredientsDivider: UIView = {
        RecipeDetailView.createDivider()
    }()
    
    let ingredientsCollectionView = IngredientsCollectionView()
    
    lazy var ingredientsInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var prepTitleLabel: UILabel = {
        RecipeDetailView.createTitleLabel(with: "Preparation")
    }()
    
    private let prepDivider: UIView = {
        createDivider()
    }()
    
    override func setViews() {
        super.setViews()
        backgroundImageView.layer.addSublayer(backgroundDimmedLayer)
        addSubview(backgroundImageView)
        addSubview(backButton)
        addSubview(scrollView)
        addSubview(spinner)
        addSubview(favoriteButton)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(prepTimeLabel)
        contentView.addSubview(prepTimeIcon)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(tagsListView)
        if let nutritionView = nutritionCombinedView {
            contentView.addSubview(nutritionTitleLabel)
            contentView.addSubview(nutritionDivider)
            contentView.addSubview(nutritionView)
        }
        contentView.addSubview(ingredientsTitleLabel)
        contentView.addSubview(ingredientsDivider)
        contentView.addSubview(ingredientsCollectionView)
        contentView.addSubview(ingredientsInfoLabel)
        
        contentView.addSubview(prepTitleLabel)
        contentView.addSubview(prepDivider)
        
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
        
        contentView.clipsToBounds = false
    }
    
    override func layoutViews() {
        super.layoutViews()
        
        // MARK: - Constraints
        NSLayoutConstraint.activate([
            
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            favoriteButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50),
            favoriteButton.widthAnchor.constraint(equalTo: favoriteButton.heightAnchor),
            
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/2),
            
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35),
            
            prepTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            prepTimeLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            prepTimeIcon.trailingAnchor.constraint(equalTo: prepTimeLabel.leadingAnchor, constant: -5),
            prepTimeIcon.centerYAnchor.constraint(equalTo: prepTimeLabel.centerYAnchor),
            
            sourceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            sourceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            
            tagsListView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            tagsListView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            tagsListView.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 15),
        ])
        
        var viewBottomAnchor = tagsListView.bottomAnchor
        if let nutritionView = nutritionCombinedView {
            NSLayoutConstraint.activate([
                nutritionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
                nutritionTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
                nutritionTitleLabel.topAnchor.constraint(equalTo: tagsListView.bottomAnchor, constant: 15),
                
                nutritionDivider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
                nutritionDivider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
                nutritionDivider.topAnchor.constraint(equalTo: nutritionTitleLabel.bottomAnchor, constant: 10),
                
                nutritionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
                nutritionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
                nutritionView.topAnchor.constraint(equalTo: nutritionDivider.bottomAnchor, constant: 15),
            ])
            viewBottomAnchor = nutritionView.bottomAnchor
        }
        
        ingredientsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ingredientsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            ingredientsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            ingredientsTitleLabel.topAnchor.constraint(equalTo: viewBottomAnchor, constant: 25),
            
            ingredientsDivider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            ingredientsDivider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            ingredientsDivider.topAnchor.constraint(equalTo: ingredientsTitleLabel.bottomAnchor, constant: 10),
            
            ingredientsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ingredientsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ingredientsCollectionView.topAnchor.constraint(equalTo: ingredientsDivider.bottomAnchor, constant: 10),
            ingredientsCollectionView.heightAnchor.constraint(equalToConstant: 100),
            
            ingredientsInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            ingredientsInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            ingredientsInfoLabel.topAnchor.constraint(equalTo: ingredientsCollectionView.bottomAnchor, constant: 10),
            
            prepTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            prepTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            prepTitleLabel.topAnchor.constraint(equalTo: ingredientsInfoLabel.bottomAnchor, constant: 25),
            
            prepDivider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            prepDivider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            prepDivider.topAnchor.constraint(equalTo: prepTitleLabel.bottomAnchor, constant: 10),
        ])
    }
}

// MARK: External
extension RecipeDetailView {
    func buildLinkButton() {
        lazy var linkButton = UIButton()
        linkButton.backgroundColor = .systemGreen
        linkButton.setTitle("Instructions", for: .normal)
        linkButton.setTitleColor(.white, for: .normal)
        linkButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        linkButton.layer.cornerRadius = 10
        linkButton.layer.shadowColor = UIColor.black.cgColor
        linkButton.layer.shadowOpacity = 0.33
        linkButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        linkButton.layer.shadowRadius = 4
        
        linkButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(linkButton)
        
        linkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        linkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        linkButton.topAnchor.constraint(equalTo: prepDivider.bottomAnchor, constant: 15).isActive = true
        linkButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        linkButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        linkButton.addTarget(self, action: #selector(didTapInstructionsButton(_:)), for: .touchUpInside)
    }
    
    func buildInstructions(with text: NSMutableAttributedString) {
        let prepInfoLabel = UILabel()
        prepInfoLabel.font = UIFont.preferredFont(forTextStyle: .body)
        prepInfoLabel.textColor = .label
        prepInfoLabel.numberOfLines = 0
        prepInfoLabel.attributedText = text
        prepInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(prepInfoLabel)
        
        prepInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        prepInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        prepInfoLabel.topAnchor.constraint(equalTo: prepDivider.bottomAnchor, constant: 15).isActive = true
        prepInfoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}

// MARK: Internal
private extension RecipeDetailView {
    
    static func createTitleLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textColor = .label
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func createDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.5)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        return divider
    }
    
    @objc func didTapBackButton(_ button: UIButton) {
        delegate?.detailView(didTapBackButton: button)
    }
    
    @objc func didTapInstructionsButton(_ button: UIButton) {
        delegate?.detailView(didTapInstructionsButton: button)
    }
    
    @objc func didTapFavoriteButton(_ button: FavoriteButton) {
        delegate?.detailView(didTapFavoriteButton: button)
    }
}
