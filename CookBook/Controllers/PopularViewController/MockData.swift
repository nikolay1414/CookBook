//
//  MockData.swift
//  CookBook
//
//  Created by Михаил Позялов on 28.02.2023.
//

import Foundation

struct MockData {
    
    static let shared = MockData()
    
    private let trendingNow: ListSection = {
        .trendingNow([.init(title: "image1", image: "image1", creatorName: "Pam Param", photoCreator: "Avatar1", category: ""),
                      .init(title: "image2", image: "image2", creatorName: "Pam Param", photoCreator: "Avatar2", category: ""),
                      .init(title: "image3", image: "image3", creatorName: "Pam Param", photoCreator: "Avatar3", category: ""),
                      .init(title: "image4", image: "image4", creatorName: "Pam Param", photoCreator: "Avatar1", category: "")])
    }()
    
    private let popularCategoryButton: ListSection = {
        .popularCategoryButton([.init(title: "", image: "", creatorName: "", photoCreator: "", category: "Salad"),
                                .init(title: "", image: "", creatorName: "", photoCreator: "", category: "Breakfast"),
                                .init(title: "", image: "", creatorName: "", photoCreator: "", category: "Appetizer"),
                                .init(title: "", image: "", creatorName: "", photoCreator: "", category: "Noodle"),
                                .init(title: "", image: "", creatorName: "", photoCreator: "", category: "Breakfast"),
                                .init(title: "", image: "", creatorName: "", photoCreator: "", category: "Appetizer"),
                                .init(title: "", image: "", creatorName: "", photoCreator: "", category: "Noodle"),
                                .init(title: "", image: "", creatorName: "", photoCreator: "", category: "Salad"),])
    }()
    
    private let popularCategory: ListSection = {
        .popularCategory([.init(title: "image9", image: "image1", creatorName: "Pam Param", photoCreator: "", category: ""),
                          .init(title: "image10", image: "image2", creatorName: "Pam Param", photoCreator: "", category: ""),
                          .init(title: "image11", image: "image3", creatorName: "Pam Param", photoCreator: "", category: ""),
                          .init(title: "image12", image: "image4", creatorName: "Pam Param", photoCreator: "", category: "")])
        
    }()
    
    private let recentRecipe: ListSection = {
        .recentRecipe([.init(title: "image9", image: "image1", creatorName: "Pam Param", photoCreator: "Avatar1", category: ""),
                       .init(title: "image10", image: "image2", creatorName: "Pam Param", photoCreator: "Avatar2", category: ""),
                       .init(title: "image11", image: "image3", creatorName: "Pam Param", photoCreator: "Avatar3", category: ""),
                       .init(title: "image12", image: "image4", creatorName: "Pam Param", photoCreator: "Avatar1", category: "")])
       
    }()
    
    var pageData: [ListSection] {
        [trendingNow, popularCategoryButton, popularCategory, recentRecipe]
    }
}
