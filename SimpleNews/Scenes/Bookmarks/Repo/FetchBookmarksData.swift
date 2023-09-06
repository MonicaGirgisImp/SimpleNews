//
//  FetchBookmarksData.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 01/08/2023.
//

import Foundation

class FetchBookmarksData: BookmarksRepoProtocol {
    
    func getCashedData(completion: (([Article])->())? ) {
        let articlesDB = CasheManager.shared.getCashedObjects(ArticleDB.self).filter({ $0.isSaved == true })
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
        let articles = CasheManager.shared.getCashedObjects(ArticleDB.self).filter({ $0.isSaved == true })
        articles.forEach { articleDB in
            if let url = articleDB.url {
                CasheManager.shared.updateCashedObj(ArticleDB.self, with: url) { objc in
                    objc.isSaved = false
                }
            }
            
        }
    }
    
    func updateCashedObject(primaryKey: String?) {
        if let primaryKey = primaryKey {
            CasheManager.shared.updateCashedObj(ArticleDB.self, with: primaryKey) { obj in
                obj.isSaved = !obj.isSaved
            }
        }
    }
}
