//
//  User.swift
//  Gitflow
//
//  Created by mac on 2018. 9. 21..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import Foundation

class User: Codable{
    let id: Int
    let departmentId: Int
    let login: String
    let userLanguage: String
    let totalUserCommit: Int
    let totalUserCodeLine: Int
    let profileUrl: String
    let departmentName: String
    
    init(id:Int?,departmentId:Int,login:String,userLanguage:String,totalUserCommit:Int,totalUserCodeLine:Int,profileImage:String,departmentName:String){
        self.id = id!
        self.departmentId = departmentId
        self.login = login
        self.userLanguage = userLanguage
        self.totalUserCommit = totalUserCommit
        self.totalUserCodeLine = totalUserCodeLine
        self.profileUrl = profileImage
        self.departmentName =  departmentName
        
    }
}

class Users: Codable {
    let users: [User]
    
    init(users: [User]) {
        self.users = users
    }
}
