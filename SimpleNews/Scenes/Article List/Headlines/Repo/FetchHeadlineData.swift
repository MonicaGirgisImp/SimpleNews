//
//  FetchHeadlineData.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 01/08/2023.
//

import Foundation

class HeadlineDataRepo: HeadlineRepoProtocol {
    
    func fetchArticles(page: Int, pageSize: Int, country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>)->())?){
        APIRoute.shared.fetchRequest(clientRequest: .GetData(country: country,category: category, page: page, pageSize: pageSize), decodingModel: APIResponse<[Article]>.self) {  response in
            completion?(response)
        }
    }
    
    func getCashedData(completion: (([Article])->())? ) {
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
    
    func fetchData(page: Int, pageSize: Int, country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>)->())?) {
        if Network.reachability.isReachable {
            fetchArticles(page: page, pageSize: pageSize, country: country, category: category) { result in
                completion?(result)
            }
        }else{
            getCashedData { data in
                completion?(.success(APIResponse(articles: data)))
            }
        }
    }
    
    func fetchSearchResultWith(_ searchText: String, page: Int, pageSize: Int, country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>)->())?) {
        APIRoute.shared.fetchRequest(clientRequest: .Search(searchText: searchText,category: category, page: page, pageSize: pageSize), decodingModel: APIResponse<[Article]>.self) { response in
            completion?(response)
        }
    }
    
    func casheArticles(articles: [Article]) {
        var articlesDB = articles.map({ ArticleDB(category: $0.category, source: $0.source, author: $0.author, title: $0.title, articleDescription: $0.articleDescription, url: $0.url, urlToImage: $0.urlToImage, publishedAt: $0.publishedAt, date: $0.date, content: $0.content, isSaved: $0.isSaved) })
        
        let cashedData = CasheManager.shared.getCashedObjects(ArticleDB.self)
        cashedData.forEach { articleDB in
            articlesDB.removeAll(where: { $0.url == articleDB.url })
        }
        
        CasheManager.shared.casheObjects(articlesDB)
    }
    
    func removeAllCashedArticles() {
        CasheManager.shared.deleteObjects(ArticleDB.self)
    }
    
    func updateCashedObject(primaryKey: String?) {
        if let primaryKey = primaryKey {
            CasheManager.shared.updateCashedObj(ArticleDB.self, with: primaryKey) { objc in
                objc.isSaved = !objc.isSaved
            }
        }
    }
}
