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
    
    let headlineRepo: HeadlineDataRepo
    
    private var dispatchGroup = DispatchGroup()
    private var page = 1
    private var tempArticles: [Article] = []
    
    private (set) var articlesData: APIResponse<[Article]> = APIResponse(totalResults: nil, articles: [], status: nil)
    
    var delegate: ViewModelDelegates?
    
    init(headlineRepo: HeadlineDataRepo) {
        self.headlineRepo = headlineRepo
    }
    
    
    func handleRepo(completion: ((Result<APIResponse<[Article]>, APIError>)->())? = nil) {
        guard let country = country else { return}
        dispatchGroup = DispatchGroup()
        delegate?.loaderIsHidden(false)
        tempArticles = []
        categories?.forEach({ category in
            dispatchGroup.enter()
            headlineRepo.fetchData(page: page, pageSize: pageSize, country: country, category: category) { [weak self] response in
                completion?(response)
                guard let self = self else { return}
                switch response{
                case .success(let data):
                    var tempData = data.articles
                    for i in 0..<tempData.count {
                        tempData[i].category = category
                    }
                    tempArticles.append(contentsOf: tempData)
                    headlineRepo.casheArticles(articles: tempData)
                case .failure(let error):
                    delegate?.failedWithError(error.localizedDescription)
                }
                dispatchGroup.leave()
            }
        })
        
        handleDispatchGroupNotification()
    }
    
    private func orderByDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "MMM d, h:mm a"
        
        for (index, article) in tempArticles.enumerated() {
            guard let date = dateFormatter.date(from: article.publishedAt ?? "") else { return}
            guard let newDate = newDateFormatter.date(from: newDateFormatter.string(from: date)) else { return}
            tempArticles[index].date = newDate
        }
    }
    
    private func handleDispatchGroupNotification() {
        dispatchGroup.notify(queue: .main){ [weak self] in
            guard let self = self else { return }
            orderByDate()
            delegate?.loaderIsHidden(true)
            
            if page == 1 {
                articlesData.articles = tempArticles
                delegate?.autoUpdateView()
            }else{
                let initialIndex = articlesData.articles.count - 1
                articlesData.articles.append(contentsOf: tempArticles)
                let endIndex = articlesData.articles.count - 1
                delegate?.insertNewRows(initialIndex, endIndex, 0)
            }
        }
    }
    
    private func deleteCashedArticles() {
        headlineRepo.removeAllCashedArticles()
    }
    
    func getNextPage() {
        guard Network.reachability.isReachable else { return }
        page += 1
        handleRepo()
    }
    
    func resetResults() {
        page = 1
        handleRepo()
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
        articlesData.articles[index].isSaved = !(articlesData.articles[index].isSaved ?? false)
        headlineRepo.updateCashedObject(primaryKey: articlesData.articles[index].url)
    }
}
