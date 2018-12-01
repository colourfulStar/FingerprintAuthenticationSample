//
//  TabBarController.swift
//  FingerprintAuthenticationSample
//
//  Created by EBIZM1 on 2018/11/21.
//  Copyright © 2018 ZhangXiQian. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    let homeCtrl = ViewController()
    let mineCtrl = MineViewController(nibName:"MineViewController",bundle:nil)
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeNav = UINavigationController.init(rootViewController: homeCtrl)
        let mineNav = UINavigationController.init(rootViewController: mineCtrl)
        
        homeNav.tabBarItem = UITabBarItem.init(title: "首页", image: UIImage.init(), selectedImage: UIImage.init())
        mineNav.tabBarItem = UITabBarItem.init(title: "我的", image: UIImage.init(), selectedImage: UIImage.init())
        self.viewControllers = [homeNav,mineNav]
        
        self.tabBar.tintColor = UIColor.orange
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
        self.tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: -3)
        self.tabBar.layer.shadowOpacity = 0.1
        
    }

}
