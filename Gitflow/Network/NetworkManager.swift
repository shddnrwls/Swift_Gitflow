//
//  NetworkManager.swift
//  Gitflow
//
//  Created by mac on 2018. 9. 23..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import RxAlamofire
import RxSwift


protocol NetworkHttpProtocol {
    func list(departmentNumber:Int,username:String) -> [User]
    func login(email:String,password:String) -> Observable<Bool>
}



class NetworkManager {
    static let instance:NetworkManager = NetworkManager()
    
    private init(){
    }
}

extension NetworkManager: NetworkHttpProtocol{
    static var userData:[User] = []
    
    func login(email:String,password:String) -> Observable<Bool> {
        return RxAlamofire.request(NetworkProtocol.login(email: email, password: password)).responseAsJSON().flatMap({ (result,json) -> Observable<Bool> in
            if result == .success {
                return Observable.just(true)
            }
            return Observable.just(false)
            
        })
    }
    
    func list(departmentNumber: Int, username: String)  -> [User]{
        
        Alamofire.request(NetworkProtocol.list(departmentNumber: departmentNumber, username: username)).responseJSON   {(response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let data = json["data"]
                data["gitUserList"].array?.forEach({ (user) in
                    let user = User(id: user["id"].intValue, departmentId: user["departmentId"].intValue, login: user["login"].stringValue, userLanguage: user["userLanguage"].stringValue, totalUserCommit: user["totalUserCommit"].intValue, totalUserCodeLine: user["totalUserCodeLine"].intValue, profileImage: user["profileUrl"].stringValue, departmentName: user["departmentName"].stringValue)
                    NetworkManager.userData.append(user)
                })
            case .failure(let error):
                print(error)
            }
        }
        print(NetworkManager.userData.count)
        return NetworkManager.userData
    }
}
fileprivate let backQueue:DispatchQueue = DispatchQueue(label: "Gitflow.backqueue", qos: .background, attributes: .concurrent)
fileprivate let backQueueScheduler:ConcurrentDispatchQueueScheduler = ConcurrentDispatchQueueScheduler(queue: backQueue)
extension Reactive where Base: DataRequest {
    public func responseBgJSON() -> Observable<DataResponse<Any>> {
        return Observable.create { observer in
            let request = self.base
            
            request.responseJSON(queue: DispatchQueue.global(qos: .background)) { response in
                if let error = response.result.error {
                    observer.on(.error(error))
                } else {
                    observer.on(.next(response))
                    observer.on(.completed)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
extension ObservableType where Self.E == Alamofire.DataRequest {
    
    func responseAsJSON() -> Observable<(ResultCode, JSON)> {
        return self.flatMap { $0.rx.responseBgJSON() }
            .observeOn(backQueueScheduler).flatMap({ (response) -> Observable<(ResultCode, JSON)> in
               
                if let data = response.data {
                    let json = try JSON(data: data)
                    if let resultCode = json["code"].int {
                        //TODO: 수정하기
                        
                        let result = ResultCode(rawValue: resultCode) ?? .unauthorized
                        return Observable.just((result, json))
                    }
                }
                assert(true)
                return Observable.error(RxError.unknown)
            })
    }
}


    

