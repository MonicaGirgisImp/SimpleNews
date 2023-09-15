//
//  HeadlineOfflineDataRepo.swift
//  SimpleNews
//
//  Created by Monica Imperial on 15/09/2023.
//

import Foundation

class HeadlineOfflineDataRepo: HeadlineLocalDataProtocol {
    func getCashedData(completion: (([Article]) -> ())?) {
        let articlesDB = CasheManager.shared.getCashedObjects(ArticleDB.self)
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
    
    func casheArticles(articles: [Article]) {
        var articlesDB = articles.map({ ArticleDB(category: $0.category, source: $0.source, author: $0.author, title: $0.title, articleDescription: $0.articleDescription, url: $0.url, urlToImage: $0.urlToImage, publishedAt: $0.publishedAt, date: $0.date, content: $0.content, isSaved: $0.isSaved) })
        
        let cashedData = CasheManager.shared.getCashedObjects(ArticleDB.self)
        cashedData.forEach { articleDB in
            articlesDB.removeAll(where: { $0.url == articleDB.url })
        }
        
        CasheManager.shared.casheObjects(articlesDB)
    }
}
