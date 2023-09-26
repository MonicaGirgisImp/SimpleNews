//
//  FakeHeadlineRepo.swift
//  SimpleNewsTests
//
//  Created by Monica Girgis Kamel on 01/08/2023.
//

import Foundation

@testable import SimpleNews

enum ResultState {
    case success
    case fail
}

final class FakeHeadlineRepo: HeadlineRepoProtocol {
    
    var testCaseState: ResultState = .success
    var successModel = APIResponse(totalResults: 1, articles: [Article(category: "categoory", source: Source(id: "id", name: "name"), author: "authtor", title: "title", articleDescription: "description", url: "url", urlToImage: "url", publishedAt: "published", date: Date(), content: "content", isSaved: false)], status: "success")
    
    func setTestCaseState(testCaseState: ResultState) {
        self.testCaseState = testCaseState
    }
    
    func fetchData(country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>) -> ())?) {
        switch testCaseState {
        case .success:
            completion?(.success(successModel))
        case .fail:
            completion?(.failure(.responseUnsuccessful))
            
        }
    }
    
    func fetchArticles(page: Int, pageSize: Int, country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>) -> ())?) {
        switch testCaseState {
        case .success:
            completion?(.success(successModel))
        case .fail:
            completion?(.failure(.responseUnsuccessful))
            
        }
    }
    
    func fetchSearchData(_ searchText: String, page: Int, country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>) -> ())?) {
        switch testCaseState {
        case .success:
            completion?(.success(successModel))
        case .fail:
            completion?(.failure(.responseUnsuccessful))
            
        }
    }
    
    func fetchSearchResultWith(_ searchText: String, page: Int, pageSize: Int, country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>) -> ())?) {
        switch testCaseState {
        case .success:
            completion?(.success(successModel))
        case .fail:
            completion?(.failure(.responseUnsuccessful))
            
        }
    }
    
    func getCashedData() -> [Article] {
        return successModel.articles
    }
    
    func casheArticles(articles: [Article]) {
        successModel.articles = articles
    }
    
    func deleteAllRecords() {
        successModel.articles = []
    }
}
