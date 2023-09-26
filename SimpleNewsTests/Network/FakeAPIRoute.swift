//
//  FakeAPIRoute.swift
//  SimpleNewsTests
//
//  Created by Monica Imperial on 26/09/2023.
//

import Foundation

@testable import SimpleNews

class FakeAPIRoute: APIProtocol {
    
    let failureModel = APIError.responseUnsuccessful
    
    var testCaseState: ResultState = .success
    
    func setTestCaseState(testCaseState: ResultState) {
        self.testCaseState = testCaseState
    }
    
    private func getSuccessModel<T>(decodingModel: T.Type) -> T? {
        switch decodingModel {
        case is APIResponse<[Article]>.Type:
            return APIResponse(totalResults: 1, articles: [Article(category: "category", source: Source(id: "id", name: "name"), author: "authtor", title: "title", articleDescription: "description", url: "url", urlToImage: "url", publishedAt: "published", date: Date(), content: "content", isSaved: false)], status: "success") as? T
            
        default:
            return nil
        }
    }
    
    func fetchRequest<T>(clientRequest: SimpleNews, decodingModel: T.Type, completion: @escaping (Result<T, APIError>) -> ()) where T : Decodable, T : Encodable {
        switch testCaseState {
        case .success:
            if let successModel = getSuccessModel(decodingModel: T.self) {
                completion(.success(successModel))
            }
            
        case .fail:
            completion(.failure(failureModel))
        }
    }
}
