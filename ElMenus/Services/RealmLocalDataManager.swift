//
//  LocalDataManagerProtocol
//  CountriesApp
//
//  Created by MAC on 12/27/19.
//  Copyright © 2019 Dalia Hosny. All rights reserved.
//

import Foundation
import RealmSwift

protocol LocalDataManagerProtocol {
    
    func getAllTage(inPage: Int) -> [Tag]
    func saveTags(tags: [Tag], inPage: Int)
    func getAllItems(tagName: String) -> [Item]
    func saveItems(items: [Item], tagName: String)
}

class RealmLocalDataManager: LocalDataManagerProtocol{
    
    func getAllTage(inPage: Int) -> [Tag] {
        // Get the default Realm
        let realm = try! Realm()
        let data = realm.objects(Tag.self).filter("page == \(inPage)")
        return Array(data)
    }
    
    func saveTags(tags: [Tag], inPage: Int) {
        let realm = try! Realm()
        // query all objects where the id in not included
        let objectsToDelete = realm.objects(Tag.self).filter("page == \(inPage)")
        // and then just remove the set with
        if objectsToDelete.count > 0 {
            try! realm.write() {
                 realm.delete(objectsToDelete)
            }
        }
        
        try! realm.write() {
            realm.add(tags)
        }
    }
    
    func getAllItems(tagName: String) -> [Item] {
        // Get the default Realm
        let realm = try! Realm()
        let data = realm.objects(Item.self).filter("tagName == '\(tagName)'")
        return Array(data)
    }
    
    func saveItems(items: [Item], tagName: String) {
        let realm = try! Realm()
        // query all objects where the id in not included
        let objectsToDelete = realm.objects(Item.self).filter("tagName == '\(tagName)'")
        // and then just remove the set with
        if objectsToDelete.count > 0 {
            try! realm.write() {
                realm.delete(objectsToDelete)
            }
        }
        
        try! realm.write() {
            realm.add(items)
        }
    }
    
//    func getSelectedCountries() -> [Country] {
//        // Get the default Realm
//        let realm = try! Realm()
//        let country = realm.objects(Country.self).filter("isSelected == true")
//        return Array(country)
//    }
//    
//    func getFilteredCountriesBy(name: String) -> [Country] {
//        // Get the default Realm
//        let realm = try! Realm()
//        let country = realm.objects(Country.self).filter("name CONTAINS[c] '\(name)'");
//        return Array(country)
//    }
//    
//    func saveCountries(countries: [Country]) {
//        let realm = try! Realm()
//        try! realm.write() {
//            realm.add(countries)
//        }
//    }
//    
//    func selectCountryBy(code: String){
//        // Get the default Realm
//        let realm = try! Realm()
//        let c = realm.objects(Country.self).filter("alpha2Code == '\(code)'").first
//        try! realm.write {
//            c?.isSelected = true
//        }
//    }
//    
//    func unSelectCountryBy(code: String){
//        // Get the default Realm
//        let realm = try! Realm()
//        let c = realm.objects(Country.self).filter("alpha2Code == '\(code)'").first
//        try! realm.write {
//            c?.isSelected = false
//        }
//    }
    
}
