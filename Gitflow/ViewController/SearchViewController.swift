//
//  SearchViewController.swift
//  Gitflow
//
//  Created by mac on 2018. 10. 23..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var userData:[User] = []
    var searchUser:[User] = []
    var searching = false
    override func viewDidLoad() {
        super.viewDidLoad()
        testApi(departmentId: 1)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func testApi(departmentId:Int){
        let loginUser:String = UserDefaults.standard.value(forKey: "User") as! String
        Alamofire.request(NetworkProtocol.list(departmentNumber: departmentId, username: loginUser)).responseJSON {(response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let data = json["data"]
                print(json)
                data["gitUserList"].array?.forEach({ (user) in
                    let user = User(id: user["id"].intValue, departmentId: user["departmentId"].intValue, login: user["login"].stringValue, userLanguage: user["userLanguage"].stringValue, totalUserCommit: user["totalUserCommit"].intValue, totalUserCodeLine: user["totalUserCodeLine"].intValue, profileImage: user["profileUrl"].stringValue, departmentName: user["departmentName"].stringValue)
                    self.userData.append(user)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                })
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }

}


extension SearchViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchUser.count
        }else{
            return userData.count
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Repository") as! UserViewController
        vc.userid = userData[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
        
        if searching {
            cell.idLabel.text = searchUser[indexPath.row].login
            if let imageURL = URL(string: searchUser[indexPath.row].profileUrl) {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageURL)
                    if let data = data{
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            cell.profileImage.image = image
                        }
                    }
                }
            }
        }else {
            cell.idLabel.text = userData[indexPath.row].login
            cell.departmentNameLabel.text = userData[indexPath.row].departmentName
            if let imageURL = URL(string: userData[indexPath.row].profileUrl) {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageURL)
                    if let data = data{
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            cell.profileImage.image = image
                        }
                    }
                }
            }
            
            
        }
        return cell
    }
}
extension SearchViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            searching = false
            tableView.reloadData()
        }
        searchUser = userData.filter({$0.login.prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()
    }
    
    
}
