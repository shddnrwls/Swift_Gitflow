//
//  ViewController.swift
//  Gitflow
//
//  Created by mac on 2018. 9. 12..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    let viewModel = MainViewModel(client: GitflowClient())
    let url = "https://avatars3.githubusercontent.com/u/22629708?v=4"
    var userData:[User] = []
    @IBOutlet var collectionView: UICollectionView!
   
    @IBOutlet var loginUserImage: UIImageView!
    @IBOutlet var loginUserDepartment: UILabel!
    @IBOutlet var loginUserLanguage: UILabel!
    @IBOutlet var loginUserTotalCodeLine: UILabel!
    @IBOutlet var loginUserRank: UILabel!
    @IBOutlet var menuOulet: UIButton!
    @IBOutlet var menuItemOulet: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testApi(departmentId: 1)
//        NetworkManager.instance.list(departmentNumber: 1, username: "shddnrwls")
//        viewModel.fetchUserList()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func loginStatusButton(_ sender: UIBarButtonItem) {
        
        createAlert(title: "로그아웃", message: "로그아웃 하시겠습니까?")
    }
    
    func testApi(departmentId:Int){
        let loginUser:String = UserDefaults.standard.value(forKey: "User") as! String
        Alamofire.request(NetworkProtocol.list(departmentNumber: departmentId, username: loginUser)).responseJSON {(response) in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                let data = json["data"]
                let login = data["currentUser"]
                DispatchQueue.main.async {
                    self.loginUserRank.text = String(data["totalCodeLineRank"].stringValue)
                    self.loginUserLanguage.text = login["userLanguage"].stringValue
                    if login["departmentId"].intValue == 2{
                        self.loginUserDepartment.text = "소프트웨어공학"
                    }
                    self.loginUserTotalCodeLine.text = String(login["totalUserCodeLine"].intValue)
                  
                    if let imageUrl = URL(string: login["profileUrl"].stringValue) {
                            let data = try? Data(contentsOf: imageUrl)
                            if let data = data{
                                let image = UIImage(data: data)
                                DispatchQueue.main.async {
                                    self.loginUserImage.image = image
                                }
                            }
                        
                    }
                }
                data["gitUserList"].array?.forEach({ (user) in
                    let user = User(id: user["id"].intValue, departmentId: user["departmentId"].intValue, login: user["login"].stringValue, userLanguage: user["userLanguage"].stringValue, totalUserCommit: user["totalUserCommit"].intValue, totalUserCodeLine: user["totalUserCodeLine"].intValue, profileImage: user["profileUrl"].stringValue, departmentName: user["departmentName"].stringValue)
                    self.userData.append(user)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                })
                
                
            case .failure(let error):
                print(error)
            }
        }

    }
    func createAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { (action) in
            UserDefaults.standard.set(false, forKey: "LoginStatus")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Intro") as! IntroViewController
            self.present(vc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: UIAlertActionStyle.default, handler: { (action) in
            print("취소")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func menuAction(_ sender: UIButton) {
        menuItemOulet.forEach { (button) in
            UIView.animate(withDuration: 0.25, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
            
        }
    }
    @IBAction func menuItemsAction(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "All"{
            print("All")
            userData.removeAll()
            collectionView.reloadData()
            testApi(departmentId: 1)
            
        }else if sender.titleLabel?.text == "IT"{
            
            print("IT")
            userData.removeAll()
            collectionView.reloadData()
            testApi(departmentId: 6)
        }else if sender.titleLabel?.text == "소프트웨어공학과"{
            print("소프")
            userData.removeAll()
            collectionView.reloadData()
            testApi(departmentId: 2)
        }else if sender.titleLabel?.text == "컴퓨터공학과"{
            userData.removeAll()
            collectionView.reloadData()
            testApi(departmentId: 4)
        }else{
            userData.removeAll()
            collectionView.reloadData()
            testApi(departmentId: 5)
        }
    }
    
}
extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userData.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MainCollectionViewCell
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.black.cgColor
        
        cell.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        cell.layer.shadowRadius = 5.0
        
        cell.layer.shadowOpacity = 0.2
        
        cell.layer.masksToBounds = false
        
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.contentView.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        if userData.count != 0{
            cell.userNameLabel.text = userData[indexPath.row].login
            cell.totalCodeLabel.text = String(userData[indexPath.row].totalUserCodeLine)
        }
        
        
        
        if let imageURL = URL(string: userData[indexPath.row].profileUrl) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data{
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                }
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Repository") as! UserViewController
        vc.userid = userData[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

