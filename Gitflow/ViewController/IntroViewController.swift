//
//  IntroViewController.swift
//  Gitflow
//
//  Created by mac on 2018. 9. 25..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "LoginStatus") == true {
            print("asd")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! UITabBarController
            self.navigationController?.pushViewController(vc, animated: false)
            
        }

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

}
