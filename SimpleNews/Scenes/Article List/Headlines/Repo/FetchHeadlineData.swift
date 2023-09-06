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
    
    func fetchSearchResultWith(_ searchText: String, page: Int, pageSize: Int, country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>)->())?) {
        APIRoute.shared.fetchRequest(clientRequest: .Search(searchText: searchText,category: category, page: page, pageSize: pageSize), decodingModel: APIResponse<[Article]>.self) { response in
            completion?(response)
        }
    }
}
