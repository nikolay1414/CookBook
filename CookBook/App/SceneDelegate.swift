//
//  SceneDelegate.swift
//  CookBook
//
//  Created by Alexander Altman on 26.02.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let onboardingViewController = OnboardingViewController()
    private let mainViewController = CustomTabBarController()
//    private let mainViewController = MainViewController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        onboardingViewController.delegate = self

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        window?.backgroundColor = .systemBackground
        window?.rootViewController = onboardingViewController
        window?.makeKeyAndVisible()
    }
}

extension SceneDelegate {
    private func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard animated, let window = window else {
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
            return
        }
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil,
            completion: nil
        )
    }
    
    private func prepareMainView() {
        
//        mainViewController.setStatusBar()
//        UINavigationBar.appearance().isTranslucent = false
//        UINavigationBar.appearance().backgroundColor = Theme.appColor
    }
}

// MARK: - OnboardingViewControllerDelegate
extension SceneDelegate: OnboardingViewControllerDelegate {
    func didFinishOnboarding() {
        prepareMainView()
        setRootViewController(mainViewController)
    }


}

