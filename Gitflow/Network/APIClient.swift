//
//  APIClient.swift
//  Gitflow
//
//  Created by mac on 2018. 10. 27..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import Foundation

enum Either<T>{
    case success(T)
    case error(Error)
}
enum APIError:Error {
    case unknown, badResponse, jsonDecoder
}
protocol APIClient {
    var session : URLSession { get }
    func get<T: Codable>(with request: URLRequest, completion: @escaping(Either<[T]>)-> Void)
    
}
extension APIClient {
    var session: URLSession {
        return URLSession.shared
    }
    
    func get<T: Codable>(with request: URLRequest, completion: @escaping(Either<[T]>)-> Void){
        let task = session.dataTask(with: request) { (data,response,error) in
            guard error == nil else {
                completion(.error(error!))
                return
            }
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                print("리스폰스 에러")
                completion(.error(APIError.badResponse))
                return
            }
            guard let value = try? JSONDecoder().decode([T].self, from: data!) else {
                print("디코더 에러")
                completion(.error(APIError.jsonDecoder))
                return
            }
            DispatchQueue.main.async {
                completion(.success(value))
            }
        }
        task.resume()
    }   
}
