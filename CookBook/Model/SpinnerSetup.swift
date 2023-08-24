//
//  SpinnerSetup.swift
//  CookBook
//
//  Created by Sergey on 05.03.2023.
//

import UIKit

extension UIActivityIndicatorView {
    func makeSpinner(_ imageView: UIImageView) {
        let spinner = self
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
}
