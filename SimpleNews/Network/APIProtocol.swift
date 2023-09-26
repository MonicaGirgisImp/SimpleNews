//
//  APIProtocol.swift
//  SimpleNews
//
//  Created by Monica Imperial on 20/09/2023.
//

import Foundation

protocol APIProtocol {
    func fetchRequest<T: Codable>(clientRequest: SimpleNews, decodingModel: T.Type, completion: @escaping (Result<T, APIError>) -> ())
}
