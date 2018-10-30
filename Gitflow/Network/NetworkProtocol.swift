//
//  NetworkProtocol.swift
//  Gitflow
//
//  Created by mac on 2018. 9. 23..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum ResultCode:Int, Error{
    case success = 200
    case unauthorized = 401
    
}


enum NetworkProtocol{
    case list(departmentNumber:Int,username:String)
    case repositoryList(userId:Int)
    case boardFetch()
    case commentFetch(boardId:Int)
    case login(email:String,password:String)
}


extension NetworkProtocol: URLRequestConvertible {
    private static let serverURLString : String = "https://gitflow.org/api/"
    static let serverURL:URL = URL(string: serverURLString)!
    func asURLRequest() throws -> URLRequest {
        var urlRequest:URLRequest = try URLRequest(url: self.url, method: self.method(), headers: self.headers)
        if let p = self.parameters{
            urlRequest = try encoding().encode(urlRequest, with: p)
        }
        return urlRequest
    }
    
    private var headers: [String: String]? {
        return ["Content-Type":"application/json", "Accept":"application/json"]
    }
    
    private func method() -> HTTPMethod {
        switch self {
        case .list,.boardFetch,.commentFetch,.repositoryList:
            return .get
        case .login:
            return .post
        }
    }
    
    private var baseURL:String {
        switch self {
        case .list,.repositoryList,.boardFetch,.commentFetch,.login:
            return NetworkProtocol.serverURLString
       
        }
    }
    private var url: String {
        switch self {
        case .list(let departmentNumber,let username):
         
            return self.baseURL + "users/\(departmentNumber)/\(username)"
        case .repositoryList(let userId):
            return self.baseURL + "user/\(userId)/repos"
        case .boardFetch:
            return self.baseURL + "questions"
        case .commentFetch(let boardId):
            return self.baseURL + "question/\(boardId)/comments"
        case .login:
            return self.baseURL + "login"
        }
    }
    private var parameters: Parameters? {
        switch self {
        case .list,.repositoryList,.boardFetch,.commentFetch:
            let parameter:Parameters = [:]
            return parameter
        case .login(let email, let password):
            let parameter:Parameters = [
                "login" : email,
                "password" : password
            ]
            return parameter
        }
    }
    private func encoding() -> ParameterEncoding {
        switch self {
        case .list,.repositoryList,.boardFetch,.commentFetch:
            return URLEncoding.default
        case .login:
            return JSONEncoding.default
        }
    }
}
