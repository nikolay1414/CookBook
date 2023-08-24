//
//  CustomView.swift
//  CookBook
//
//  Created by Sergey on 03.03.2023.
//

import UIKit

class CustomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setViews()
        layoutViews()
    }
    
    func setViews() {
        backgroundColor = Theme.whiteColor
    }
    
    func layoutViews() {
        
    }
}

