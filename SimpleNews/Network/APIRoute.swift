//
//  APIRoute.swift
//  Project
//
//  Created by Monica Girgis Kamel on 05/12/2021.
//

import Foundation

class APIRoute{
    
    static let shared:APIRoute = APIRoute()
    private init(){}
    
    private func initRequest(_ clientRequest:SimpleNews)->URLRequest? {
        var request:URLRequest = clientRequest.request
        
        request.httpMethod = clientRequest.method.rawValue
        if clientRequest.body != nil{
            let jsonData = try? JSONSerialization.data(withJSONObject: clientRequest.body as Any, options: .prettyPrinted)
            request.httpBody = jsonData
        }
        request.addHeaders(clientRequest.headers)
        
        print("=======================================")
        print(request)
        print(clientRequest.body ?? [:])
        print(clientRequest.queryItems)
        print(request.allHTTPHeaderFields ?? [:])
        print("=======================================")
        
        return request
    }
    
    private func JSONTask<T:Decodable>(with request: URLRequest, decodingModel: T.Type, completion: @escaping (Result<T, APIError>)-> Void) -> URLSessionDataTask {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }
                print("request url:\(String(describing: request.url)) with status code \(httpResponse.statusCode)")
            switch httpResponse.statusCode {
            case 200...204:
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                var responseModel:T!
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    guard JSONSerialization.isValidJSONObject(json) else {
                        completion(.failure(.invalidData))
                        return
                    }
                    print(json)
                    responseModel = try JSONDecoder().decode(T.self, from: data)
                } catch let err {
                    print("request url:\(String(describing: request.url)) with serialization error \(err)")
                    
                    completion(.failure(.jsonConversionFailure))
                    return
                }
                completion(.success(responseModel))
                
            case 400...504:
                guard data != nil else {
                    completion(.failure(.invalidData))
                    return
                }
                
                completion(.failure(.responseUnsuccessful))
                
            default:
                completion(.failure(.responseUnsuccessful))
            }
        }
        return task
    }
    
    func fetchRequest<T: Codable>(clientRequest: SimpleNews, decodingModel: T.Type, completion: @escaping (Result<T, APIError>) -> ()){
        
        guard let urlRequest:URLRequest = self.initRequest(clientRequest) else {return}
        
        let dataTask = self.JSONTask(with: urlRequest, decodingModel: decodingModel.self) { (result) in
            
            DispatchQueue.main.async {
                completion(result)
            }
            
            
        }
        dataTask.resume()
    }
}
