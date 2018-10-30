//
//  Comment.swift
//  Gitflow
//
//  Created by mac on 2018. 9. 26..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import Foundation

class Comment:Codable{
    let id:Int
    let comment:String
    let createdAt:String
    init(id:Int,comment:String,createdAt:String) {
        self.id = id
        self.comment = comment
        self.createdAt = createdAt
    }
}
