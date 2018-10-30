//
//  GitflowClient.swift
//  Gitflow
//
//  Created by mac on 2018. 10. 27..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import Foundation
class GitflowClient: APIClient {
    static let baseUrl = "https://gitflow.org/api/"
    
    
    func fetch(with endpoint: GitflowEndpoint, completion: @escaping (Either<UserLists>) -> Void){
        let request = endpoint.request
        get(with: request, completion: completion)
        
    }
}
