//
//  SourceDB.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 31/07/2023.
//

import Foundation
import Realm
import RealmSwift

class SourceDB: Object {
    
    @Persisted var id: String?
    @Persisted var name: String?
    
    convenience init(id: String?, name: String?) {
        self.init()
        self.id = id
        self.name = name
    }
}
