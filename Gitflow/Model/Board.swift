//
//  Board.swift
//  Gitflow
//
//  Created by mac on 2018. 9. 26..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import Foundation

class Board:Codable{
    let id:Int
    let content:String
    let createdAt:String
    init(id:Int,content:String,createdAt:String) {
        self.id = id
        self.content = content
        self.createdAt = createdAt
    }
}
