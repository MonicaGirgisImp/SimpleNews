//
//  APIResponse.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 08/01/2022.
//

import Foundation

struct APIResponse<R: Codable>: Equatable, Codable {
    static func == (lhs: APIResponse<R>, rhs: APIResponse<R>) -> Bool {
        return (lhs.articles as? [Article])?.count == (rhs.articles as? [Article])?.count
    }
    
    var page: Int?
    var totalResults: Int?
    var articles: R
    var status: String?
}

struct httpHeader:Decodable {
    var key:String
    var value:String
}

struct GeneralErrorMessage: Decodable{
    var status: String?
    var code: String?
    var message: String?
}
