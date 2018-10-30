//
//  Repository.swift
//  Gitflow
//
//  Created by mac on 2018. 9. 26..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import Foundation


class Repository: Codable{
    
    let id: Int
    let userId: Int
    let repoName: String
    let repoLanguage: String
    let repoUrl: String
    let userCommitCount: Int
    let allCommitCount: Int
    let userCodeLine: Int
    let totalCodeLine: Int
    init(id:Int?,userId:Int,repoName:String,repoLanguage:String,repoUrl:String,userCommitCount:Int,allCommitCount:Int,userCodeLine:Int,totalCodeLine:Int) {
        self.id = id!
        self.userId = userId
        self.repoName = repoName
        self.repoLanguage = repoLanguage
        self.repoUrl = repoUrl
        self.userCommitCount = userCommitCount
        self.allCommitCount = allCommitCount
        self.userCodeLine = userCodeLine
        self.totalCodeLine = totalCodeLine
    }
}
