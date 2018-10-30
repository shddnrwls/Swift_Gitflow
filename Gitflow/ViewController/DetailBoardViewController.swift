//
//  DetailBoardViewController.swift
//  Gitflow
//
//  Created by mac on 2018. 9. 26..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailBoardViewController: UIViewController {

    @IBOutlet var boardCreatedAt: UILabel!
    @IBOutlet var boardContent: UITextView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var commentTextField: UITextField!
    var boardId:Int = 0
    var content:String = ""
    var createdAt:String = ""
    var commentData:[Comment] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardCreatedAt.text = createdAt
        boardContent.text = content
        fetchComment(id: boardId)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func fetchComment(id:Int){
        Alamofire.request(NetworkProtocol.commentFetch(boardId: id)).responseJSON {(response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let data = json["data"]
                data.array?.forEach({ (comment) in
                    let comment = Comment(id: comment["id"].intValue, comment: comment["comment"].stringValue, createdAt: comment["createdAt"].stringValue)
                    self.commentData.append(comment)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            case .failure(let error):
                print(error)
            }
        }
        
    }
    @IBAction func sendComment(_ sender: UIButton) {
        
        questionTest()
        commentTextField.text = ""
    }
    func questionTest(){
        Alamofire.request(
            "https://gitflow.org/api/question/comment",
            method: .post,
            parameters: ["comment":commentTextField.text,
                         "questionId":boardId],
            encoding: JSONEncoding.default,
            headers: ["Content-Type":"application/json", "Accept":"application/json"]
            )
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                if let JSON = response.result.value {
                    print(JSON)
                }
        }
        commentData.removeAll()
        fetchComment(id: boardId)
        
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

extension DetailBoardViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CommentTableViewCell
        cell.contentTextView.text = commentData[indexPath.row].comment
        cell.createdAtLabel.text = commentData[indexPath.row].createdAt
        return cell
    }
}
