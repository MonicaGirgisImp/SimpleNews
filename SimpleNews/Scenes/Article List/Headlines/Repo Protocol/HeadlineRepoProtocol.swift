//
//  HeadlineRepoProtocol.swift
//  SimpleNews
//
//  Created by Monica Imperial on 06/09/2023.
//

import Foundation

protocol HeadlineRepoProtocol: AnyObject {
    func fetchData(country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>)->())?)
    func fetchArticles(page: Int, pageSize: Int, country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>)->())?)
    func fetchSearchData(_ searchText: String, page: Int, country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>)->())?)
    func fetchSearchResultWith(_ searchText: String, page: Int, pageSize: Int, country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>)->())?)
    func getCashedData() -> [Article]
    func casheArticles(articles: [Article])
    func deleteAllRecords()
}
