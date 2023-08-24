//
//  FavoriteManager.swift
//  CookBook
//
//  Created by Sergey on 11.03.2023.
//

import Foundation
import RealmSwift

protocol FavoriteManagerProtocol: AnyObject {
    func addToFavorite(recipeID: Int, recipeImage: Data?, completionBlock: @escaping (Result<Bool, Error>) -> Void)
    func deleteFromFavorite(recipeID: Int , completionBlock: @escaping (Result<Bool, Error>) -> Void)
    func getFromFavorite(recipeID: Int, completionBlock: @escaping (Result<RecipeModel, Error>) -> Void)
    func getAllRecipeFromFavorite(completionBlock: @escaping (Result<[Recipe], Error>) -> Void)
    func checkForFavorite(recipeID: Int) -> Bool
}

class FavoriteManager: FavoriteManagerProtocol {
    
    var defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let networkManager = NetworkManager()
    
    //MARK: - Add to favorite method
    
    
    func addToFavorite(recipeID: Int, recipeImage: Data?, completionBlock: @escaping (Result<Bool, Error>) -> Void) {
        var recipeData: Data?
        
        if checkForFavorite(recipeID: recipeID) == true {
            completionBlock(.failure(FavoriteError.favoriteExist))
        } else {
            
            var favoriteIDList = self.defaults.object(forKey: "favoriteList") as? [Int] ?? [Int]()
            favoriteIDList.append(recipeID)
            self.defaults.set(favoriteIDList, forKey: "favoriteList")
            completionBlock(.success(true))
            //            networkManager.fetchRecipeByID(.searchByID(recipeID: recipeID)) { result in
            //                switch result {
            //                case .success(let data):
            //                    recipeData = data
            //                    let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            //                    let realm = try! Realm(configuration: config)
            //
            //                    // путь в проекте к файлу БД Realm (нужна RealmStudio):
            //                    print (realm.configuration.fileURL ?? "")
            //
            //                    // Создаем экземпляр класса RealmRecipeModel
            //                    let recipeRealm = RealmRecipeModel()
            //
            //                    //Присваиваем значения в объекты Realm
            //                    recipeRealm.id = recipeID
            //                    recipeRealm.data = data
            //
            //                    if let recipeImage = recipeImage {
            //                        recipeRealm.image = recipeImage
            //                    }
            //
            //                    do {
            //                        //добавление в БД и проверка на обновленные данные
            //                        try realm.write {
            //                            realm.add(recipeRealm, update: .modified)
            //                        }
            //                        var favoriteIDList = self.defaults.object(forKey: "favoriteList") as? [Int] ?? [Int]()
            //                        favoriteIDList.append(recipeID)
            //                        self.defaults.set(favoriteIDList, forKey: "favoriteList")
            //                        completionBlock(.success(true))
            //                    } catch {
            //                        completionBlock(.failure(error))
            //                    }
            //                case .failure(let error):
            //                    completionBlock(.failure(error))
            //                }
            //            }
        }
        
        //        guard let data = recipeData else {
        //            completionBlock(.failure(FavoriteError.wrongCode))
        //            return
        //        }
        // Здесь мы записываем данные (recipeData а так же recipeImage ) в базу, а так же и в UserDefaults и возвращаем результат сохранения в completionBlock
        
        // Создаем конфигурацию экземпляра Realm для перезаписи БД, чтобы данные не дублировались
        
    }
    
    //MARK: - Deleting from favorite method
    
    func deleteFromFavorite(recipeID: Int, completionBlock: @escaping (Result<Bool, Error>) -> Void) {
        
        if checkForFavorite(recipeID: recipeID) == false {
            completionBlock(.failure(FavoriteError.notInFavorite))
            return
        }
        var favoriteIDList = defaults.object(forKey: "favoriteList") as? [Int] ?? [Int]()
        if let index = favoriteIDList.firstIndex(of: recipeID) {
            favoriteIDList.remove(at: index)
            defaults.set(favoriteIDList, forKey: "favoriteList")
        }
        completionBlock(.success(true))
        
        //        //создание экземпляра класса Realm
        //        let realm = try! Realm()
        //
        //        //обращение к объектам в базе по id
        //        guard let recipeRealm = realm.object(ofType: RealmRecipeModel.self, forPrimaryKey: recipeID) else {
        //            completionBlock(.failure(FavoriteError.notInFavorite))
        //            return
        //        }
        //
        //        do {
        //            //удаление из БД
        //            try realm.write {
        //                realm.delete(recipeRealm)
        //            }
        //            var favoriteIDList = defaults.object(forKey: "favoriteList") as? [Int] ?? [Int]()
        //            if let index = favoriteIDList.firstIndex(of: recipeID) {
        //                favoriteIDList.remove(at: index)
        //                defaults.set(favoriteIDList, forKey: "favoriteList")
        //            }
        //            completionBlock(.success(true))
        //        } catch let error {
        //            completionBlock(.failure(error))
        //        }
    }
    
    //MARK: - Getting from favorite method
    
    func getFromFavorite(recipeID: Int, completionBlock: @escaping (Result<RecipeModel, Error>) -> Void) {
        
        if checkForFavorite(recipeID: recipeID) == false {
            completionBlock(.failure(FavoriteError.notInFavorite))
            return
        }
        
        //создание экземпляра базы данных Realm
        let realm = try! Realm()
        
        //запрос на чтение по id из БД
        let recipeRealm = realm.objects(RealmRecipeModel.self).filter("id = \(recipeID)").first
        
        //получаем свойство data у найденного объекта RealmRecipeModel:
        if let recipe = recipeRealm {
            
            //Здесь мы проверяем, что recipe не равен nil, и, если он существует, записываем данные data в переменную recipeEncoded и продолжаем обработку данных
            let recipeEncoded = recipe.data
            do {
                let recipes = try JSONDecoder().decode(RecipeModel.self, from: recipeEncoded)
                completionBlock(.success(recipes))
            } catch let error {
                completionBlock(.failure(error))
            }
        } else {
            completionBlock(.failure(FavoriteError.notInFavorite))
            return
        }
    }
    
    //MARK: - Getting all recipe from favorite
    
    func getAllRecipeFromFavorite(completionBlock: @escaping (Result<[Recipe], Error>) -> Void) {
        
        // создание экземпляра базы данных Realm
//        let realm = try! Realm()
//
//        // получаем все объекты типа RealmRecipeModel из базы данных
//        let recipesRealm = realm.objects(RealmRecipeModel.self)
        
        // создаем массив для хранения рецептов
        //var recipes: Recipe?
        
        var favoriteIDList = defaults.object(forKey: "favoriteList") as? [Int] ?? [Int]()
        networkManager.fetchRecipeByID(.searchByID(recipeID: favoriteIDList)) { result in
            switch result {
                
            case .success(let data):
                completionBlock(.success(data))
            case .failure(let error):
                completionBlock(.failure(error))
            }
        }
        
        
//        for recipeRealm in recipesRealm {
//            // преобразовываем каждый объект RealmRecipeModel в объект RecipeModel
//            let recipeData = recipeRealm.data
//            if let recipe = try? JSONDecoder().decode(RecipeModel.self, from: recipeData) {
//                recipes = recipe
//            }
//        }
//
//        if recipes != nil {
//            completionBlock(.failure(FavoriteError.notInFavorite))
//        } else {
//            guard let recipes = recipes else { return }
//            completionBlock(.success(recipes))
//        }
    }
    
    //MARK: - Checking is favorite exist
    
    func checkForFavorite(recipeID: Int) -> Bool {
        let favoriteIDList = defaults.object(forKey: "favoriteList") as? [Int] ?? [Int]()
        if favoriteIDList.contains(where: {$0 == recipeID}) {
            return true
        } else {
            return false
        }
    }
    
}
