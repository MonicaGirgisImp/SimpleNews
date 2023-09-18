//
//  CasheManagerProtocol.swift
//  SimpleNews
//
//  Created by Monica Imperial on 18/09/2023.
//

import Foundation
import Realm
import RealmSwift

protocol CasheManagerProtocol: AnyObject {
    func casheObject<T: Object>( _ realmObject: T)
    func casheObjects<T: Object>( _ realmObjects: [T])
    func getCashedObjects<T: Object>(_ model: T.Type) -> Results<T>
    func getCashedObject<T: Object>(_ model: T.Type, with primaryKey: Any) -> T?
    func deleteObjects<T: Object>(_ model: T.Type)
    func updateCashedObj<T: Object>(_ model: T.Type, with primaryKey: Any, completion: ((T)->())?)
}
