//
//  FetchHeadlineData.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 01/08/2023.
//

import Foundation

class HeadlineDataRepo: HeadlineRepoProtocol {
    
    let pageSize = 20
    private var dispatchGroup = DispatchGroup()
    private var isSameDataFlag: Bool = false
    private var tempArticles: [Article] = []
    
    private var articlesData: APIResponse<[Article]> = APIResponse(page: nil, totalResults: nil, articles: [], status: nil)
    
    
    func fetchData(country: String, categories: [String], completion: ((Result<APIResponse<[Article]>, APIError>)->())?) {
        
        setupDataSource()
        let page = (articlesData.page ?? 0) + 1
        if page == 1 {
            completion?(.success(articlesData))
        }
        
        dispatchGroup = DispatchGroup()
        tempArticles = []
        categories.forEach { category in
            dispatchGroup.enter()
            fetchArticles(page: page, pageSize: pageSize, country: country, category: category) { [weak self] response in
                guard let self = self else { return }
                dispatchGroup.leave()
                switch response {
                case .success(_): break
                case .failure(let error):
                    completion?(.failure(error))
                }
            }
        }
        handleDispatchGroupNotification(page: page, country: country, categories: categories) { response in
            completion?(response)
        }
    }
    
    func fetchSearchData(_ searchText: String, page: Int, country: String, categories: [String], completion: ((Result<APIResponse<[Article]>, APIError>)->())?) {
    
        dispatchGroup = DispatchGroup()
        tempArticles = []
        categories.forEach { category in
            dispatchGroup.enter()
            fetchSearchResultWith(searchText, page: page, pageSize: pageSize, country: country, category: category) { [weak self] response in
                guard let self = self else { return }
                dispatchGroup.leave()
                switch response {
                case .success(_): break
                case .failure(let error):
                    completion?(.failure(error))
                }
            }
        }
        handleSearchDispatchGroup(page: page, completion: completion)
    }
    
    private func setupDataSource() {
        articlesData.articles = getCashedData()
        articlesData.totalResults = articlesData.articles.count
//        articlesData.page = articlesData.totalResults! / (pageSize * 3) /// 3 apis are called and each give 20 record (page size)
    }
    
    private func handleDispatchGroupNotification(page: Int, country: String, categories: [String], completion: ((Result<APIResponse<[Article]>, APIError>)->())?) {
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            if (tempArticles.first?.url == articlesData.articles.first?.url || isSameDataFlag), page == 1 {
                isSameDataFlag = false
                articlesData.page = 1
                fetchData(country: country, categories: categories, completion: nil)
            }else if page == 1 {
                deleteAllRecords()
                casheArticles(articles: tempArticles)
                setupDataSource()
                articlesData.page = 1
                completion?(.success(articlesData))
            }else{
                casheArticles(articles: tempArticles)
                articlesData.page = page
                completion?(.success(articlesData))
            }
        }
    }
    
    private func handleSearchDispatchGroup(page: Int, completion: ((Result<APIResponse<[Article]>, APIError>)->())?) {
        dispatchGroup.notify(queue: .main){ [weak self] in
            guard let self = self else { return }
            articlesData.page = page
            if page == 1 {
                articlesData.articles = tempArticles
            }else{
                articlesData.articles.append(contentsOf: tempArticles)
            }
            completion?(.success(articlesData))
        }
    }
    
    func fetchArticles(page: Int, pageSize: Int, country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>)->())?) {
        APIRoute.shared.fetchRequest(clientRequest: .GetData(country: country,category: category, page: page, pageSize: pageSize), decodingModel: APIResponse<[Article]>.self) { [weak self] response in
            guard let self = self else { return}
            switch response {
            case .success(let data):
                if articlesData.articles.contains(where: { $0.url == data.articles.first?.url }) {
                    isSameDataFlag = true
                }
                
                var tempData = data.articles
                for i in 0..<tempData.count {
                    tempData[i].category = category
                    if let date = saveDateStringToDate(dateString: tempData[i].publishedAt ?? "") {
                        tempData[i].date = date
                    }
                }
                tempArticles.append(contentsOf: tempData)
                
            case .failure(_): break
            }
            completion?(response)
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
                tempArticles.append(contentsOf: tempData)
                
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
