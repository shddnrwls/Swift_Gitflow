//
//  MainViewModel.swift
//  Gitflow
//
//  Created by mac on 2018. 9. 21..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import Foundation
struct CellViewModel {
    let userName:String
    let totalCodeLine:String
}

class MainViewModel{
    private let client: APIClient
    private var userLists: UserLists = [] {
        didSet{
            fetchUserList()
        }
    }
    var cellViewModels: [CellViewModel] = []
    
    var isLoding: Bool = false {
        didSet{
            showLoading?()
        }
    }
    var showLoading: (() -> Void)?
    var reloadData: (() -> Void)?
    var showError: ((Error) -> Void)?
    init(client: APIClient) {
        self.client = client
    }
    
    func fetchUserList(){
        if let client = client as? GitflowClient{
            self.isLoding = true
            let endpoint  = GitflowEndpoint.userlists(id: "1", loginId: "shddnrwls")
            client.fetch(with: endpoint) { (either) in
                switch either {
                case .success(let userLists):
                    self.userLists = userLists
                case .error(let error):
                    self.showError?(error)
                }
            }
        }
    }
    private func fetchUserLists() {
        let group = DispatchGroup()
        
        self.userLists.forEach { (user) in
            print(user)
        }
    }
}
