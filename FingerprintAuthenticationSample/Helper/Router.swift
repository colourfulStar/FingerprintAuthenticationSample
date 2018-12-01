//
//  Router.swift
//  FingerprintAuthenticationSample
//
//  Created by EBIZM1 on 2018/11/23.
//  Copyright © 2018 ZhangXiQian. All rights reserved.
//

import UIKit

class Router: NSObject {
    
    internal override init() {}
    
    //创建单例
    class var sharedInstance : Router {
        struct Static {
            static let sharedInstance : Router = Router()
        }
        return Static.sharedInstance
    }
    
    //MARK:***********************获取当前控制器*********************************
    func getRootVC() -> UINavigationController {
        let temp = UIApplication.shared.delegate?.window!?.rootViewController
        var NAV : UINavigationController!
        if temp != nil && temp!.isKind(of: UITabBarController.classForCoder()) {
            let tabbar = temp as! UITabBarController
            NAV = tabbar.selectedViewController as? UINavigationController
        }
        return NAV
    }

}
