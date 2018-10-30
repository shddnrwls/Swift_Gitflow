//
//  LoginViewController.swift
//  Gitflow
//
//  Created by mac on 2018. 9. 18..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RxSwift
class LoginViewController: UIViewController {

    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    
    var viewModel:LoginViewModel = LoginViewModel()
    private var disposeBag:DisposeBag = DisposeBag()
    override func viewDidLoad() {
       
        super.viewDidLoad()
        obseverLoginStatus()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        loginApi()
//        viewModel.login(email: userNameTextField.text!, password: passwordTextField.text!)
    }
    private func obseverLoginStatus(){
        viewModel.statusObserver.observeOn(MainScheduler.asyncInstance).subscribe( onNext: { (status) in
            switch status {
            case .loginEnded:
                print("Success")
                return
            }
        }).disposed(by: disposeBag)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        self.view.endEditing(true)
        
    }
    func createAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func loginApi(){
        
        let url = "https://gitflow.org/api/login"
        let params = [
            "login" : userNameTextField.text,
            "password" : passwordTextField.text
            ]
        Alamofire.request(
            url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: ["Content-Type":"application/json", "Accept":"application/json"]
            )
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                print(response)
                if let json = response.result.value {
                    let data = JSON(json)
                    let msg = data["msg"].string as! String
                    if msg == "Invalid UserName" {
                        self.createAlert(title: "로그인 실패", message: "아이디가 잘못입력되었습니다.")
                    }else if msg == "Invalid Password"{
                        self.createAlert(title: "로그인 실패", message: "비밀번호가 잘못입력되었습니다.")
                    }else {
                        UserDefaults.standard.set(self.userNameTextField.text, forKey: "User")
                        UserDefaults.standard.set(true, forKey: "LoginStatus")
                        print("성공")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! UITabBarController
                        self.present(vc, animated: true, completion: nil)
                    }
                }
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
