//
//  MineViewController.swift
//  FingerprintAuthenticationSample
//
//  Created by EBIZM1 on 2018/11/26.
//  Copyright © 2018 ZhangXiQian. All rights reserved.
//

import UIKit

class MineViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的"
        TouchIDHelper.sharedInstance.showTouchID(true, self)
       
        
    }

    @IBAction func FingerprintAction(_ sender: Any) {
        TouchIDHelper.sharedInstance.showTouchID(false, self)
    }

}
