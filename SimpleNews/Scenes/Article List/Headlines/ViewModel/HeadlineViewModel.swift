//
//  HeadlineViewModel.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 31/07/2023.
//

import Foundation

class HeadlinesViewModel {
    
    let pageSize = 20
    let country = UserManager.shared.getSelectedCountry()
    let categories = UserManager.shared.getSelectedCategories()
    
    let headlineRepo: HeadlineRepoProtocol
    let headlineOfflineRepo: HeadlineLocalDataProtocol
    
    private var dispatchGroup = DispatchGroup()
    private var page = 1
    private var tempArticles: [Article] = []
    
    private (set) var articlesData: APIResponse<[Article]> = APIResponse(totalResults: nil, articles: [], status: nil)
    
    var delegate: ViewModelDelegates?
    
    init(headlineRepo: HeadlineRepoProtocol, headlineOfflineRepo: HeadlineLocalDataProtocol) {
        self.headlineRepo = headlineRepo
        self.headlineOfflineRepo = headlineOfflineRepo
    }
    
    func handleRepo(completion: ((Result<APIResponse<[Article]>, APIError>)->())? = nil) {
        tempArticles = []
        headlineOfflineRepo.getCashedData { [weak self] data in
            guard let self = self else { return }
            tempArticles = data
            settingUpDataSource()
        }
        fetchData { result in
            completion?(result)
        }
    }
    
    func fetchData(completion: ((Result<APIResponse<[Article]>, APIError>)->())? = nil) {
        guard let country = country else { return}
        dispatchGroup = DispatchGroup()
//        delegate?.loaderIsHidden(false)
        tempArticles = []
        categories?.forEach({ category in
            dispatchGroup.enter()
            headlineRepo.fetchArticles(page: page, pageSize: pageSize, country: country, category: category) { [weak self] response in
                completion?(response)
                guard let self = self else { return}
                switch response{
                case .success(let data):
                    var tempData = data.articles
                    for i in 0..<tempData.count {
                        tempData[i].category = category
                        if let date = saveDateStringToDate(dateString: tempData[i].publishedAt ?? "") {
                            tempData[i].date = date
                        }
                    }
                    tempArticles.append(contentsOf: tempData)
                    headlineOfflineRepo.casheArticles(articles: tempData)
                case .failure(let error):
                    delegate?.failedWithError(error.localizedDescription)
                }
                dispatchGroup.leave()
            }
        })
        handleDispatchGroupNotification()
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
    
    private func settingUpDataSource() {
        if page == 1, !tempArticles.isEmpty {
            articlesData.articles = tempArticles
            delegate?.autoUpdateView()
        }else{
            let initialIndex = articlesData.articles.count - 1
            articlesData.articles.append(contentsOf: tempArticles)
            let endIndex = articlesData.articles.count - 1
            delegate?.insertNewRows(initialIndex, endIndex, 0)
        }
    }
    
    private func handleDispatchGroupNotification() {
        dispatchGroup.notify(queue: .main){ [weak self] in
            guard let self = self else { return }
            delegate?.loaderIsHidden(true)
            settingUpDataSource()
        }
    }
    
    func getNextPage() {
        guard Network.reachability.isReachable else { return }
        page += 1
        fetchData()
    }
    
    func resetResults() {
        page = 1
        fetchData()
    }
    
    func searchArticles(with searchText: String, completion: ((Result<APIResponse<[Article]>, APIError>)->())? = nil) {
        guard let country = country else { return }
        page = 1
        dispatchGroup = DispatchGroup()
        delegate?.loaderIsHidden(false)
        tempArticles = []
        categories?.forEach({ category in
            dispatchGroup.enter()
            headlineRepo.fetchSearchResultWith(searchText, page: page, pageSize: pageSize, country: country, category: category) { [weak self] response in
                completion?(response)
                guard let self = self else { return}
                switch response{
                case .success(let data):
                    var tempData = data.articles
                    for i in 0..<tempData.count {
                        tempData[i].category = category
                    }
                    tempArticles.append(contentsOf: tempData)
                case .failure(let error):
                    delegate?.failedWithError(error.localizedDescription)
                }
                dispatchGroup.leave()
                
            }
        })
        
        handleDispatchGroupNotification()
    }
    
    func addArticleToBookmarks(at index: Int) {
        guard index >= 0, index < articlesData.articles.count else { return }
        articlesData.articles[index].isSaved = !(articlesData.articles[index].isSaved ?? false)
        if let url = articlesData.articles[index].url {
            CasheManager.shared.updateCashedObj(ArticleDB.self, with: url) { objc in
                objc.isSaved = !objc.isSaved
            }
        }
    }
}
