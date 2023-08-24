//
//  SearchTableView.swift
//  CookBook
//
//  Created by Sergey on 11.03.2023.
//

import Foundation
import UIKit

class SearchTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        backgroundColor = UIColor.systemBackground
        register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseId)
        rowHeight = 130
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
