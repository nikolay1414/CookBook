//
//  RealmRecipeModel.swift
//  CookBook
//
//  Created by Марк Райтман on 11.03.2023.
//

import Foundation
import RealmSwift

//класс наследует от Object, класса, который предоставляет основные функциональные возможности Realm, и реализует протокол Codable, который позволяет преобразовывать объекты класса в данные JSON и обратно
class RealmRecipeModel: Object, Codable {
    
    //@Persisted var id: Int определяет id как сохраняемое свойство, а primaryKey() возвращает строку "id" в качестве первичного ключа для данной модели
    @Persisted var id: Int
    
    //@Persisted var data: Data указывает на то, что данные модели будут храниться в виде объекта Data
    @Persisted var data: Data
    
    //@Persisted var image: Data? позволяет сохранить опциональное изображение
    @Persisted var image: Data?
    
    //создание ключа по id
    override class func primaryKey() -> String? {
        return "id"
    }
}
