//
//  UIAOViewController.swift
//  Yixiang
//
//  Created by 刘洪彬 on 2019/10/30.
//  Copyright © 2019 artwebs. All rights reserved.
//

import UIKit

class UIAOViewController: UIViewController {
    var views:Dictionary<String,UIView> = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppDefault.DefaultLightGray
        self.navigationController?.isNavigationBarHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
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

}
