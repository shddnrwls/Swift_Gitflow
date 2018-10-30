//
//  WriteViewController.swift
//  Gitflow
//
//  Created by mac on 2018. 9. 26..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WriteViewController: UIViewController {

    @IBOutlet var contentTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
  

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancleAction(_ sender: UIBarButtonItem) {
    }
    @IBAction func checkerAction(_ sender: UIBarButtonItem) {
        questionTest()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! UITabBarController
        self.present(vc, animated: true, completion: nil)
    }
    
    func questionTest(){
        Alamofire.request(
            "https://gitflow.org/api/question",
            method: .post,
            parameters: ["body":contentTextView.text],
            encoding: JSONEncoding.default,
            headers: ["Content-Type":"application/json", "Accept":"application/json"]
            )
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                print(response)
                if let JSON = response.result.value {
                    print(JSON)
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
