//
//  FakeHeadlineRepo.swift
//  SimpleNewsTests
//
//  Created by Monica Girgis Kamel on 01/08/2023.
//

import Foundation
import Realm
import RealmSwift

@testable import SimpleNews

enum ResultState {
    case success
    case fail
}

final class FakeHeadlineRepo: HeadlineDataRepo {
    
    var testCaseState: ResultState = .success
    let successModdel = APIResponse(totalResults: 1, articles: [Article(category: "categoory", source: Source(id: "id", name: "name"), author: "authtor", title: "title", articleDescription: "description", url: "url", urlToImage: "url", publishedAt: "published", date: Date(), content: "content", isSaved: false)], status: "success")
    
    func setTestCaseState(testCaseState: ResultState) {
        self.testCaseState = testCaseState
    }
    
    
    override func fetchArticles(page: Int, pageSize: Int, country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>)->())?) {
        switch testCaseState {
        case .success:
            completion?(.success(successModdel))
        case .fail:
            completion?(.failure(.responseUnsuccessful))
        }
    }
    
    override func fetchSearchResultWith(_ searchText: String, page: Int, pageSize: Int, country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>)->())?) {
        switch testCaseState {
        case .success:
            completion?(.success(successModdel))
        case .fail:
            completion?(.failure(.responseUnsuccessful))
        }
    }
    
    override func fetchData(page: Int, pageSize: Int, country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>)->())?) {
            fetchArticles(page: page, pageSize: pageSize, country: country, category: category) { result in
                completion?(result)
            }
        }
}
