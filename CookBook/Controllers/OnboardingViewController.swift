//
//  OnboardingViewController.swift
//  CookBook
//
//  Created by Alexander Altman on 27.02.2023.
//

import UIKit

protocol OnboardingViewControllerDelegate: AnyObject {
    func didFinishOnboarding()
}

final class OnboardingViewController: UIViewController {
    
    weak var delegate: OnboardingViewControllerDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting elements and their constraints
        setupViews()
        setupConstraints()
    }
    
    //MARK: - Properties
    //creating view
    let backImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "onboardingScreenImage")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start Cooking", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = Theme.buttonCornerRadius
        button.backgroundColor = Theme.yellowColor
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let letsCookingLabel:UILabel =  {
        let label = UILabel()
        label.textColor = Theme.whiteColor
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.text = "Let's Cooking"
        label.font = UIFont.boldSystemFont(ofSize: 70.0)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bestRecipesLabel:UILabel =  {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.text = "Find the best recipes"
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Methods
    //go to the next controller by pressing the button
    @objc func buttonTapped (_ sender: UIButton) {
        delegate?.didFinishOnboarding()
    }
 
    //setting items on the root view
    func setupViews() {
        view.addSubview(backImageView)
        view.addSubview(startButton)
        view.addSubview(letsCookingLabel)
        view.addSubview(bestRecipesLabel)
    }
}

//MARK: - Extension: constraints
extension OnboardingViewController {
    //adjusting the arrangement of elements on the screen
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            letsCookingLabel.bottomAnchor.constraint(equalTo: bestRecipesLabel.bottomAnchor, constant: -50),
            letsCookingLabel.heightAnchor.constraint(equalToConstant: 200),
            letsCookingLabel.widthAnchor.constraint(equalToConstant: 200),
            letsCookingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            bestRecipesLabel.bottomAnchor.constraint(equalTo: startButton.bottomAnchor, constant: -50),
            bestRecipesLabel.heightAnchor.constraint(equalToConstant: 100),
            bestRecipesLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            bestRecipesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

        ])
    }
}

//import SwiftUI
//struct ListProvider: PreviewProvider {
//    static var previews: some View {
//        ContainterView().edgesIgnoringSafeArea(.all)
//            .previewDevice("iPhone 12 Pro Max")
//            .previewDisplayName("iPhone 12 Pro Max")
//        
//        ContainterView().edgesIgnoringSafeArea(.all)
//            .previewDevice("iPhone SE (3rd generation)")
//            .previewDisplayName("iPhone SE (3rd generation)")
//    }
//    
//    struct ContainterView: UIViewControllerRepresentable {
//        let listVC = OnboardingViewController()
//        func makeUIViewController(context:
//                                  UIViewControllerRepresentableContext<ListProvider.ContainterView>) -> OnboardingViewController {
//            return listVC
//        }
//        
//        func updateUIViewController(_ uiViewController:
//                                    ListProvider.ContainterView.UIViewControllerType, context:
//                                    UIViewControllerRepresentableContext<ListProvider.ContainterView>) {
//        }
//    }
//}