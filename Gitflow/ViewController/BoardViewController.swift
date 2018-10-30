//
//  BoardViewController.swift
//  Gitflow
//
//  Created by mac on 2018. 9. 19..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class BoardViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var boardData:[Board] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBoard()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func writeClick(_ sender: UIBarButtonItem) {
       
    }
    func fetchBoard(){
        Alamofire.request(NetworkProtocol.boardFetch()).responseJSON {(response) in
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                let data = json["data"]
                data.array?.forEach({ (board) in
                    let board = Board(id: board["id"].intValue, content: board["content"].stringValue, createdAt: board["createdAt"].stringValue)
                    self.boardData.append(board)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            case .failure(let error):
                print(error)
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
extension BoardViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boardData.count    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BoardTableViewCell
        cell.contentTextView.text = boardData[indexPath.row].content
        cell.createTimeLabel.text = boardData[indexPath.row].createdAt
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailBoard") as! DetailBoardViewController
        vc.content = boardData[indexPath.row].content
        vc.createdAt = boardData[indexPath.row].createdAt
        vc.boardId = boardData[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
//        print("asd")
        
        
    }
}
