//
//  UserViewController.swift
//  Gitflow
//
//  Created by mac on 2018. 9. 12..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class UserViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var userid: Int = 0
    
    var repoData:[Repository] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userid)
        fetchRepository(userId: userid)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    
    func fetchRepository(userId:Int){
        Alamofire.request(NetworkProtocol.repositoryList(userId: userId)).responseJSON {(response) in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                let data = json["data"]
                data["repoList"].array?.forEach({ (repo) in
                    let repo = Repository(id: repo["id"].intValue, userId: repo["userId"].intValue, repoName: repo["repoName"].stringValue, repoLanguage: repo["repoLanguage"].stringValue, repoUrl: repo["repoUrl"].stringValue, userCommitCount: repo["userCommitCount"].intValue, allCommitCount: repo["allCommitCount"].intValue, userCodeLine: repo["userCodeLine"].intValue, totalCodeLine: repo["totalCodeLine"].intValue)
                    self.repoData.append(repo)
                    print(self.repoData.count)
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
extension UserViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repoData.count
    }
  

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! RepositoryTableViewCell
        cell.codeLineLabel.text = String(repoData[indexPath.row].totalCodeLine)
        cell.repositoryNameLabel.text = repoData[indexPath.row].repoName
        cell.languageLable.text = repoData[indexPath.row].repoLanguage
        cell.totalCommitLabel.text = "\(repoData[indexPath.row].userCommitCount)/\(repoData[indexPath.row].allCommitCount)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "webView") as! RepositoryViewController
         vc.url = URL(string: repoData[indexPath.row].repoUrl)
         self.navigationController?.pushViewController(vc, animated: true)
    }

}
