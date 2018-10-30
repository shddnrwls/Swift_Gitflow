//
//  LoginViewModel.swift
//  Gitflow
//
//  Created by mac on 2018. 9. 21..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import Foundation
import RxSwift
enum LoginStatus {
    case loginEnded
}

class LoginViewModel{
    var alertObserver:PublishSubject<String> = PublishSubject<String>()
    var statusObserver:PublishSubject<LoginStatus> = PublishSubject<LoginStatus>()
    func login(email :String, password:String) {
        _ = NetworkManager.instance.login(email: email, password: password).take(1)
            .subscribe(onNext: { [weak self] isSuccess in
                if isSuccess {
                    self?.statusObserver.onNext(.loginEnded)
                }else{
                    self?.alertObserver.onNext("로그인 실패")
                }
                
                },onError: { [weak self] (error) in
                    print(error.localizedDescription)
                    print("")
                    self?.alertObserver.onNext("로그인 실패")
            })
    }
}
