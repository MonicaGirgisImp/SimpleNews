//
//  FakeCasheManager.swift
//  SimpleNewsTests
//
//  Created by Monica Imperial on 26/09/2023.
//

import Foundation
import Realm
import RealmSwift

@testable import SimpleNews

class FakeCasheManager<D: Object>: CasheManagerProtocol {
    
    var arrayOfObject: [D] = []
    
    func casheObject<T: Object>(_ realmObject: T) where T : RealmSwiftObject {
        arrayOfObject.append(realmObject as! D)
    }
    
    func casheObjects<T: Object>(_ realmObjects: [T]) where T : RealmSwiftObject {
        if let objects = realmObjects as? [D] {
            arrayOfObject.append(contentsOf: objects)
        }else{
            print("failed")
        }
    }
    
    func getCashedObjects<T: Object>(_ model: T.Type) -> [T] where T : RealmSwiftObject {
        return arrayOfObject as! [T]
    }
    
    func getCashedObject<T>(_ model: T.Type, with primaryKey: Any) -> T? where T : RealmSwiftObject {
        switch model {
        case is ArticleDB.Type:
            if let primaryKey = primaryKey as? String {
                return getCashedObjects(ArticleDB.self).first(where: { $0.url == primaryKey }) as? T
            }
            return nil
            
        default:
            return nil
        }
    }
    
    func deleteObjects<T: Object>(_ model: T.Type) where T : RealmSwiftObject {
        arrayOfObject.removeAll()
    }
    
    func updateCashedObj<T: Object>(_ model: T.Type, with primaryKey: Any, completion: ((T) -> ())?) where T : RealmSwiftObject {
        if let obj = getCashedObject(T.self, with: primaryKey) {
            completion?(obj)
        }
    }
}
