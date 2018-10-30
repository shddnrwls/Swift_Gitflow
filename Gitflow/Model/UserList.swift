//
//  UserList.swift
//  Gitflow
//
//  Created by mac on 2018. 10. 27..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import Foundation
typealias UserLists = [UserList]

struct UserList: Codable {
    let id: Int
    let departmentId: Int
    let login: String
    let userLanguage: String
    let totalUserCommit: Int
    let totalUserCodeLine: Int
    let profileUrl: URL
    let departmentName: String
}
