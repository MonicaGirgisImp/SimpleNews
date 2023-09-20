//
//  CasheManager.swift
//  SimpleNews
//
//  Created by Monica Imperial on 06/09/2023.
//

import Foundation
import Realm
import RealmSwift

class CasheManager: CasheManagerProtocol {
    
    static let shared:CasheManager = CasheManager()
    
    private var realm = try! Realm()
    private init(){}
    
    func casheObject<T: Object>( _ realmObject: T) {
        do {
            try realm.write({
                realm.add(realmObject, update: .all)
            })
        }catch let err{
            print(err.localizedDescription)
        }
    }
    func casheObjects<T: Object>( _ realmObjects: [T]) {
        do {
            try realm.write({
                realm.add(realmObjects, update: .all)
            })
        }catch let err{
            print(err.localizedDescription)
        }
    }
    
    func getCashedObjects<T: Object>(_ model: T.Type) -> Results<T> {
        return realm.objects(T.self)
    }
    func getCashedObject<T: Object>(_ model: T.Type, with primaryKey: Any) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: primaryKey)
    }
    
    func deleteObjects<T: Object>(_ model: T.Type) {
        do {
            realm.beginWrite()
            let cashedData = realm.objects(T.self)
            guard !cashedData.isEmpty else { return }
            realm.delete(cashedData)
            try realm.commitWrite()
            
        }catch let err{
            print(err.localizedDescription)
        }
    }
    
    func updateCashedObj<T: Object>(_ model: T.Type, with primaryKey: Any, completion: ((T)->())?) {
        if let obj = getCashedObject(T.self, with: primaryKey) {
            do  {
                try realm.write({
                    completion?(obj)
                    realm.add(obj, update: .all)
                })
            }catch let err{
                print(err.localizedDescription)
            }
        }
    }
    
    func resetRealm() {
        realm = try! Realm()
    }
}
