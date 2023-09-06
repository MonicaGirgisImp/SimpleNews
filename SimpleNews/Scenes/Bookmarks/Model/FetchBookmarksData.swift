//
//  FetchBookmarksData.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 01/08/2023.
//

import Foundation
import Realm
import RealmSwift

class FetchBookmarksData {
    
    let realm = try! Realm()
    
    func getCashedData(completion: (([Article])->())? ) {
        let articlesDB = realm.objects(ArticleDB.self).where({ $0.isSaved == true })
        var articles: [Article] = []
        articlesDB.forEach { articleDB in
            articles.append( Article(category: articleDB.category,
                                     source: Source(id: articleDB.source?.id, name: articleDB.source?.name),
                                     author: articleDB.author,
                                     title: articleDB.title,
                                     articleDescription: articleDB.articleDescription,
                                     url: articleDB.url,
                                     urlToImage: articleDB.urlToImage,
                                     publishedAt: articleDB.publishedAt,
                                     date: articleDB.date,
                                     content: articleDB.content,
                                     isSaved: articleDB.isSaved))
        }
        completion?(articles)
    }
    
    func unmarkAllArticles() {
        let articles = realm.objects(ArticleDB.self).where({ $0.isSaved == true })
        try! self.realm.write {
            for article in articles {
                article.isSaved = false
                realm.add(article, update: .all)
            }
        }
    }
    
    func updateCashedObject(primaryKey: String?) {
        let article = realm.objects(ArticleDB.self).where {
            $0.url == primaryKey
        }.first!
        try! realm.write {
            article.isSaved = !article.isSaved
        }
    }
}
