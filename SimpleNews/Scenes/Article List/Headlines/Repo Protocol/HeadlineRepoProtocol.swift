//
//  HeadlineRepoProtocol.swift
//  SimpleNews
//
//  Created by Monica Imperial on 06/09/2023.
//

import Foundation

protocol HeadlineRepoProtocol: AnyObject {
    func fetchArticles(page: Int, pageSize: Int, country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>)->())?)
    func getCashedData(completion: (([Article])->())? )
    func fetchData(page: Int, pageSize: Int, country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>)->())?)
    func fetchSearchResultWith(_ searchText: String, page: Int, pageSize: Int, country: String, category: String, completion: ((Result<APIResponse<[Article]>, APIError>)->())?)
    func casheArticles(articles: [Article])
    func removeAllCashedArticles()
    func updateCashedObject(primaryKey: String?)
}
