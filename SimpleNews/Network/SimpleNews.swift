//
//  SimpleNews.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 06/01/2022.
//

import Foundation

enum SimpleNews {
    case GetData(country: String, category: String, page: Int, pageSize: Int)
    case Search(searchText: String, category: String, page: Int, pageSize: Int)
}

extension SimpleNews: Endpoint{
    var base: String {
        return Bundle.main.baseURL
    }
    
    var urlSubFolder: String {
        return Bundle.main.urlSubFolder
    }
    
    var path: String {
        return ""
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .GetData(let country, let category, let page, let pageSize):
            return [URLQueryItem(name: "country", value: country),
                    URLQueryItem(name: "category", value: category),
                    URLQueryItem(name: "page", value: "\(page)"),
                    URLQueryItem(name: "pageSize", value: "\(pageSize)")]
            
        case .Search(let searchText, let category, let page, let pageSize):
            return [URLQueryItem(name: "q", value: searchText),
                    URLQueryItem(name: "category", value: category),
                    URLQueryItem(name: "page", value: "\(page)"),
                    URLQueryItem(name: "pageSize", value: "\(pageSize)")]
        }
    }
    
    var headers : [httpHeader] {
        let httpHeaders = [
            httpHeader(key: "X-Api-Key", value: "291fe5f954674cf9bd005c09f389ce70")
        ]
        
        return httpHeaders
    }
    
    var method: HTTPMethod {
        switch self{
        default:
            return .get
        }
    }
    
    var body: [String: Any]?{
        return nil
    }
    
}

extension URLRequest{
    mutating func addHeaders(_ Headers:[httpHeader]){
        for Header in Headers {
            self.addValue(Header.value, forHTTPHeaderField: Header.key)
        }
    }
}

extension Bundle {
    var baseURL: String {
        return object(forInfoDictionaryKey: "BaseURL") as? String ?? ""
    }
    
    var urlSubFolder: String {
        return object(forInfoDictionaryKey: "URLSubFolder") as? String ?? ""
    }
}
