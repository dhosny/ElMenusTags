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
    
    func getAllTage() -> [Tag]
   
}

class RealmLocalDataManager: LocalDataManagerProtocol{
    
    func getAllTage() -> [Tag] {
        // Get the default Realm
        let realm = try! Realm()
        let country = realm.objects(Tag.self)
        return Array(country)
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
