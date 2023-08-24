//
//  NetworkManager.swift
//  CookBook
//
//  Created by Sergey on 02.03.2023.
//

import UIKit

protocol NetworkManagerProtocol: AnyObject {
    
    func fetchRecipes(_ url: ApiURL, then completionBlock: @escaping(Result<RecipeModel, Error>) -> Void)
    func fetchRecipeByID(_ url: ApiURL, then completionBlock: @escaping(Result<[Recipe], Error>) -> Void)
    func fetchImage(for imageType: ImageType, with name: String, size: String?, completionBlock: @escaping(Result<Data, Error>) -> Void)
    
}

class NetworkManager: NetworkManagerProtocol {
    
    var imageCache = NSCache<NSString, NSData>()
    
    func fetchRecipes(_ url: ApiURL, then completionBlock: @escaping (Result<RecipeModel, Error>) -> Void) {
       
        guard let url = url.url else {
            completionBlock(.failure(NetworkError.wrongUrl))
            return
        }
        loadDataFromUrl(url) { result in
            switch result {
            case .success(let data):
                do {
                    let recipeData = try JSONDecoder().decode(RecipeModel.self, from: data)
                    completionBlock(.success(recipeData))
                } catch let error as NSError {
                    completionBlock(.failure(error))
                }
            case .failure(let error):
                completionBlock(.failure(error))
            }
        }
    }
    
    func fetchRecipeByID(_ url: ApiURL, then completionBlock: @escaping (Result<[Recipe], Error>) -> Void) {
        
        guard let url = url.url else {
            completionBlock(.failure(NetworkError.wrongUrl))
            return
        }
        
        loadDataFromUrl(url) { result in
            switch result {
            case .success(let data):
                do {
                    let recipeData = try JSONDecoder().decode([Recipe].self, from: data)
                    completionBlock(.success(recipeData))
                } catch let error as NSError {
                    completionBlock(.failure(error))
                }
            case .failure(let error):
                completionBlock(.failure(error))
            }
        }
        
    }
    
    func fetchImage(for imageType: ImageType, with name: String, size: String?, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        let baseURL = "https://spoonacular.com"
        var assembledUrl: String = ""
        
        switch imageType {
        case .recipe:
            assembledUrl = name
        case .ingredient:
            assembledUrl = "\(baseURL + imageType.rawValue)_\(size!)/\(name)"
        }
        
        guard let url = URL(string: assembledUrl) else {
            completionBlock(.failure(NetworkError.wrongUrl))
            return
        }
        
        if let cachedImageData = imageCache.object(forKey: url.absoluteString as NSString) as? Data {
            print("Loading from cache")
            completionBlock(.success(cachedImageData))
            return
        }
        
        loadDataFromUrl(url) { result in
            print("Image loaded")
            if let data = try? result.get() as NSData {
                self.imageCache.setObject(data, forKey: url.absoluteString as NSString)
            }
            completionBlock(result)
        }
    }
    
    private func loadDataFromUrl(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 10)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...300).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.wrongCode))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.notFoundData))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
