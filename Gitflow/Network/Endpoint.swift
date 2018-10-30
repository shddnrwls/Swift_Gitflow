//
//  Endpoint.swift
//  Gitflow
//
//  Created by mac on 2018. 10. 27..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import Foundation

protocol Endpoint {
    var baseUrl: String{ get }
    var path: String { get }
    var urlParameters: [URLQueryItem] { get }
    
}
extension Endpoint {
    var urlComponent: URLComponents {
        var urlComponent = URLComponents(string: baseUrl)
        urlComponent?.path = path
        urlComponent?.queryItems = urlParameters
        print(urlComponent!)
        return urlComponent!
    }
    var request: URLRequest {
//        print(urlComponent.url)
        return URLRequest(url: urlComponent.url!)
    }
}
enum GitflowEndpoint: Endpoint {
    case userlists(id:String, loginId:String)
    
    var baseUrl: String{
        return "https://gitflow.org/api/"
    }
    var path: String{
        switch self {
        case .userlists(let id,let loginId):
            return "users/\(id)/\(loginId)"
        }
    }
    var urlParameters: [URLQueryItem]{
        switch self {
        case .userlists:
            return []
        }
    }
}
