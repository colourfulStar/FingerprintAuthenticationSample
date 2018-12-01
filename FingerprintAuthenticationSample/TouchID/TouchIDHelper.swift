//
//  TouchIDHelper.swift
//  FingerprintAuthenticationSample
//
//  Created by EBIZM1 on 2018/11/22.
//  Copyright © 2018 ZhangXiQian. All rights reserved.
//

import UIKit

class TouchIDHelper: NSObject {
    
    //指纹认证情况的枚举
    enum TouchIDState: String {
        case unsupport = "0"
        case support = "1"
        case open = "2"
    }
    
    private override init() {
        super.init()
        if self.getState() == "" {
            //判断支持touch ID机型
            if UIScreen.main.bounds.height ==  568 || UIScreen.main.bounds.height == 667 || UIScreen.main.bounds.height == 736 {
                self.setState(TouchIDState.support)
            } else {
                self.setState(TouchIDState.unsupport)
            }
        }
    }
    
    class var sharedInstance: TouchIDHelper {
        struct Static {
            static let sharedInstance : TouchIDHelper = TouchIDHelper()
        }
        return Static.sharedInstance
    }
    
    
    //MARK:STATE
    func setState(_ state: TouchIDState) {
        if self.getState() != TouchIDState.unsupport.rawValue {
            Storage.sharedInstance.setTouchState(state.rawValue)
        }
    }
    
    func getState() -> String {
        return Storage.sharedInstance.getTouchState()
    }
    
    func clearState()  {
        self.setState(TouchIDState.support)
    }
    
    func isOpen() -> Bool {
        return self.getState() == TouchIDState.open.rawValue
    }
    
    func isSupport() -> Bool {
        return self.getState() == TouchIDState.support.rawValue
    }
    
    
    //MARK:是否需要提示用户进行指纹认证
    func isNeedTip() -> Bool {
        return true
        
//        //逻辑：第一次打开app，提示用户绑定指纹。当用户选择不绑定时，以后每个自然周都会提醒一次
//        let now = Double(TimeToken().getNowTimeToken())!
//        let monday = TimeToken().getMondayMoringTimeInterval()
//        let touchTime = Storage.sharedInstance.getTouchTime()
//        if monday < touchTime && touchTime < now {
//            return false
//        } else if self.isSupport() {
//            Storage.sharedInstance.setTouchTime(now)
//            return true
//        }
//        return false
    }
    
    func showTouchID(_ autoCheck: Bool, _ viewController: UIViewController) {
        if #available(iOS 9, *) {
            if TouchIDHelper.sharedInstance.getState() == TouchIDState.unsupport.rawValue {
                let alert = UIAlertController.init(title: "您的设备不支持touchID", message: "", preferredStyle: .alert)
                let confirmAction = UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(confirmAction)
                Router.sharedInstance.getRootVC().present(alert, animated: true, completion: nil)
                return;
            }
            
            if autoCheck == false {
               viewController.navigationController?.pushViewController(TouchIDViewController(false), animated: true)
                
                return
            }
            if self.getState() == TouchIDState.open.rawValue {
                viewController.navigationController?.present(TouchIDViewController(true), animated: true)
            } else if self.isNeedTip() {
                let alert = UIAlertController.init(title: "\n\n为保障您的账户安全，请开启指纹认证", message: "", preferredStyle: .alert)
                let imgv = UIImageView(frame: CGRect(x: 120, y: 20, width: 30, height: 30))
                imgv.image = UIImage(named: "img_fingerImage")
                alert.view.addSubview(imgv)
                let confirmAction = UIAlertAction.init(title: "去开启", style: .default, handler: { (action) in
                    viewController.navigationController?.present(TouchIDViewController(true), animated: true)
                    alert.dismiss(animated: true, completion: nil)
                    
                })
                let cancelAction = UIAlertAction.init(title: "暂不", style: .cancel, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(confirmAction)
                alert.addAction(cancelAction)
                Router.sharedInstance.getRootVC().present(alert, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController.init(title: "只支持iOS9以上（包括iOS9）的设备", message: "", preferredStyle: .alert)
            let confirmAction = UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(confirmAction)
            Router.sharedInstance.getRootVC().present(alert, animated: true, completion: nil)
        }
    }
}
