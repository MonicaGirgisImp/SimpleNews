//
//  APIProtocol.swift
//  SimpleNews
//
//  Created by Monica Imperial on 20/09/2023.
//

import Foundation

protocol APIProtocol {
    func initRequest(_ clientRequest:SimpleNews)->URLRequest?
    func JSONTask<T:Decodable>(with request: URLRequest, decodingModel: T.Type, completion: @escaping (Result<T, APIError>)-> Void) -> URLSessionDataTask
    func fetchRequest<T: Codable>(clientRequest: SimpleNews, decodingModel: T.Type, completion: @escaping (Result<T, APIError>) -> ())
}
