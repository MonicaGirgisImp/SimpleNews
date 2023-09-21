//
//  HeadlineViewModel.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 31/07/2023.
//

import Foundation

class HeadlinesViewModel {
    
    let country = UserManager.shared.getSelectedCountry()
    let categories = UserManager.shared.getSelectedCategories()
    let headlineRepo: HeadlineRepoProtocol
    
    private var didGetNextPage = false
    
    private (set) var articlesData: APIResponse<[Article]> = APIResponse(page: nil, totalResults: nil, articles: [], status: nil)
    
    var delegate: ViewModelDelegates?
    
    init(headlineRepo: HeadlineRepoProtocol) {
        self.headlineRepo = headlineRepo
    }
    
    func fetchData() {
        guard let country = country, let categories = categories else { return }
        didGetNextPage = true
        headlineRepo.fetchData(country: country, categories: categories, completion: { [weak self] response in
            guard let self = self else { return }
            didGetNextPage = false
            switch response {
            case .success(let data):
                articlesData = data
                delegate?.autoUpdateView()
            case .failure(let error):
                delegate?.failedWithError(error.localizedDescription)
            }
        })
    }
    
//    private func settingUpDataSource() {
//        if page == 1, !tempArticles.isEmpty {
//            articlesData.articles = tempArticles
//            delegate?.autoUpdateView()
//        }else{
//            let initialIndex = articlesData.articles.count - 1
//            articlesData.articles.append(contentsOf: tempArticles)
//            let endIndex = articlesData.articles.count - 1
//            delegate?.insertNewRows(initialIndex, endIndex, 0)
//        }
//    }
    
    func getNextPage() {
        guard Network.reachability.isReachable, !didGetNextPage else { return }
        fetchData()
    }
    
    func resetResults() {
        headlineRepo.deleteAllRecords()
        fetchData()
    }
    
    func searchArticles(with searchText: String, completion: ((Result<APIResponse<[Article]>, APIError>)->())? = nil) {
        guard let country = country, let categories = categories else { return }
        delegate?.loaderIsHidden(false)
        headlineRepo.fetchSearchData(searchText, page: 1, country: country, categories: categories) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                articlesData = data
                delegate?.autoUpdateView()
            case .failure(let error):
                delegate?.failedWithError(error.localizedDescription)
            }
        }
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
