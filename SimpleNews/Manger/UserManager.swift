//
//  UserManager.swift
//  FaceDoct
//
//  Created by Mina Malak on 21/06/2021.
//

import Foundation

class UserManager{
    
    public static let shared = UserManager()
    private init(){}
    
    func setData(country: Countries, categories: [Categories]){
        UserDefaults.standard.set(true, forKey: "FirstLaunch")
        UserDefaults.standard.set(country.code, forKey: "SelectedCountry")
        UserDefaults.standard.set(categories.map {$0.rawValue}, forKey: "SelectedCategories")
    }
    
    func userDidFirstLaunch() -> Bool?{
        return UserDefaults.standard.bool(forKey: "FirstLaunch")
    }
    
    func getSelectedCountry() -> String?{
        return UserDefaults.standard.string(forKey: "SelectedCountry")
    }
    
    func getSelectedCategories() -> [String]?{
        return UserDefaults.standard.value(forKey: "SelectedCategories") as? [String]
    }
    
    func clearData(){
        UserDefaults.standard.removeObject(forKey: "FirstLaunch")
        UserDefaults.standard.removeObject(forKey: "SelectedCountry")
        UserDefaults.standard.removeObject(forKey: "SelectedCategories")
    }
}
