//
//  HeadlineViewModel.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 31/07/2023.
//

import Foundation
import Combine

class HeadlinesViewModel: BaseViewModel {
    
    let country = UserManager.shared.getSelectedCountry()
    let categories = UserManager.shared.getSelectedCategories()
    let headlineRepo: HeadlineRepoProtocol
    
    private var didGetNextPage = false
    
    private var articlesData: APIResponse<[Article]> = APIResponse(page: nil, totalResults: nil, articles: [], status: nil)
    
    var articles: CurrentValueSubject<[Article] , Never> = .init([])
    
    init(headlineRepo: HeadlineRepoProtocol) {
        self.headlineRepo = headlineRepo
    }
    
    func fetchData() {
        guard let country = country, let category = categories?.first else { return }
        didGetNextPage = true
        headlineRepo.fetchData(country: country, category: category, completion: { [weak self] response in
            guard let self = self else { return }
            didGetNextPage = false
            switch response {
            case .success(let data):
                articlesData = data
                articles.value = data.articles
                autoUpdateView.send(())
            case .failure(let error):
                failedWithError.send(error.localizedDescription)
            }
        })
    }
    
//    private func settingUpDataSource(newData: APIResponse<[Article]>) {
//        if newData.page == 1 {
//            articlesData = newData
//            delegate?.autoUpdateView()
//        }else{
//            let initialIndex = articlesData.articles.count - 1
//            articlesData.articles.append(contentsOf: newData.articles)
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
        guard let country = country, let category = categories?.first else { return }
        showLoader.send(true)
        headlineRepo.fetchSearchData(searchText, page: 1, country: country, category: category) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                articlesData = data
                autoUpdateView.send(())
            case .failure(let error):
                failedWithError.send(error.localizedDescription)
            }
        }
    }
    
    func addArticleToBookmarks(at index: Int) {
        guard index >= 0, index < articlesData.articles.count else { return }
        articlesData.articles[index].isSaved = !(articlesData.articles[index].isSaved ?? false)
        articles.value[index].isSaved = !(articles.value[index].isSaved ?? false)
        if let url = articlesData.articles[index].url {
            CasheManager.shared.updateCashedObj(ArticleDB.self, with: url) { objc in
                objc.isSaved = !objc.isSaved
            }
        }
    }
}
