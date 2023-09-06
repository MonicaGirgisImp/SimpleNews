//
//  ArticlesDB.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 31/07/2023.
//

import Foundation
import Realm
import RealmSwift

class ArticleDB: Object {
    
    @Persisted var category: String?
    @Persisted var source: SourceDB?
    @Persisted var author: String?
    @Persisted var title: String?
    @Persisted var articleDescription: String?
    @Persisted(primaryKey: true) var url: String?
    @Persisted var urlToImage: String?
    @Persisted var publishedAt: String?
    @Persisted var date: Date?
    @Persisted var content: String?
    @Persisted var isSaved: Bool = false
    
    convenience init(category: String?, source: Source?, author: String?, title: String?, articleDescription: String?, url: String?, urlToImage: String?, publishedAt: String?, date: Date?, content: String?, isSaved: Bool?) {
        self.init()
        self.category = category
        self.source = SourceDB(id: source?.id, name: source?.name)
        self.author = author
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.date = date
        self.content = content
        self.isSaved = isSaved ?? false
    }
}
