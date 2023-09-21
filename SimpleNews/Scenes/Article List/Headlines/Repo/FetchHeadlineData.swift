//
//  FetchHeadlineData.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 01/08/2023.
//

import Foundation

class HeadlineDataRepo: HeadlineRepoProtocol {
    
    let pageSize = 20
    
    private var articlesData: APIResponse<[Article]> = APIResponse(page: nil, totalResults: nil, articles: [], status: nil)
    
    private func setupDataSource() {
        articlesData.articles = getCashedData()
        let count = articlesData.articles.count
        articlesData.page = count / pageSize
    }
    
    func fetchData(country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>)->())?) {
        
        var page: Int!
        if articlesData.articles.isEmpty {
            setupDataSource()
            page = 1
            completion?(.success(articlesData))
        }else{
            setupDataSource()
            page = (articlesData.page ?? 0) + 1
        }
        
        if let totalResult = articlesData.totalResults, articlesData.articles.count == totalResult {
            return
        }
        
        fetchArticles(page: page, pageSize: pageSize, country: country, category: category) { response in
            completion?(response)
        }
    }
    
    func fetchArticles(page: Int, pageSize: Int, country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>)->())?) {
        APIRoute.shared.fetchRequest(clientRequest: .GetData(country: country,category: category, page: page, pageSize: pageSize), decodingModel: APIResponse<[Article]>.self) { [weak self] response in
            guard let self = self else { return}
            switch response {
            case .success(let data):
                articlesData.totalResults = data.totalResults
                
                var tempData = data.articles
                for i in 0..<tempData.count {
                    tempData[i].category = category
                    if let date = saveDateStringToDate(dateString: tempData[i].publishedAt ?? "") {
                        tempData[i].date = date
                    }
                }
                
                if data.articles.first?.url == articlesData.articles.first?.url, page == 1 {
                    fetchData(country: country, category: category, completion: nil)
                }else if page == 1 {
                    deleteAllRecords()
                    casheArticles(articles: tempData)
                    setupDataSource()
                    completion?(.success(articlesData))
                    
                }else{
                    casheArticles(articles: tempData)
                    completion?(.success(articlesData))
                }
                
                
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    internal func saveDateStringToDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "MMM d, h:mm a"
        
        guard let date = dateFormatter.date(from: dateString) else { return nil}
        guard let newDate = newDateFormatter.date(from: newDateFormatter.string(from: date)) else { return nil }
        
        return newDate
    }
    
    func fetchSearchData(_ searchText: String, page: Int, country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>)->())?) {
        
        fetchSearchResultWith(searchText, page: page, pageSize: pageSize, country: country, category: category) { response in
           completion?(response)
        }
    }
    func fetchSearchResultWith(_ searchText: String, page: Int, pageSize: Int, country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>)->())?) {
        
        APIRoute.shared.fetchRequest(clientRequest: .Search(searchText: searchText,category: category, page: page, pageSize: pageSize), decodingModel: APIResponse<[Article]>.self) { [weak self] response in
            guard let self = self else { return}
            switch response {
            case .success(let data):
                var tempData = data.articles
                for i in 0..<tempData.count {
                    tempData[i].category = category
                    if let date = saveDateStringToDate(dateString: tempData[i].publishedAt ?? "") {
                        tempData[i].date = date
                    }
                }
                
                articlesData.page = page
                if page == 1 {
                    articlesData.articles = tempData
                }else{
                    articlesData.articles.append(contentsOf: tempData)
                }
                completion?(.success(articlesData))
                
            case .failure(let error):
                completion?(.failure(error))
            }
            
        }
    }
    
    func getCashedData() -> [Article] {
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
        return articles
    }
    
    func casheArticles(articles: [Article]) {
        var articlesDB = articles.map({ ArticleDB(category: $0.category, source: $0.source, author: $0.author, title: $0.title, articleDescription: $0.articleDescription, url: $0.url, urlToImage: $0.urlToImage, publishedAt: $0.publishedAt, date: $0.date, content: $0.content, isSaved: $0.isSaved) })
        
        CasheManager.shared.casheObjects(articlesDB)
    }
    
    func deleteAllRecords() {
        CasheManager.shared.deleteObjects(ArticleDB.self)
    }
}
