//
//  TouchIDViewController.swift
//  FingerprintAuthenticationSample
//
//  Created by EBIZM1 on 2018/11/21.
//  Copyright © 2018 ZhangXiQian. All rights reserved.
//

import UIKit

class TouchIDViewController: UIViewController {
    
    @IBOutlet weak var touchIDSwitch: UISwitch!
    @IBOutlet weak var tipsLabel: UILabel!
    
    var autoCheck     = true    //是否被动验证指纹
    
    convenience init(_ autoCheck: Bool) {
        self.init(nibName: "TouchIDViewController", bundle: nil)
        self.autoCheck = autoCheck
        
        self.hidesBottomBarWhenPushed = true
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "指纹"
        
        if autoCheck {
            self.tipsLabel.isHidden = true
            self.touchIDSwitch.isHidden = true
        }else{
            self.tipsLabel.isHidden = false
            self.touchIDSwitch.isHidden = false
            self.touchIDSwitch.setOn(TouchIDHelper.sharedInstance.isOpen(), animated: true)
        }
    }
    
    
    //MARK:Action
    @IBAction func touchIDAction(_ sender: Any) {
        self.checkTouchID()
    }
    
    @IBAction func authAction(_ sender: Any) {
        self.checkTouchID()
    }
    
    
    //MARK:Alert
    func touchIDNotSetAlert() {
        let alert = UIAlertController.init(title: "\n\n您尚未设置指纹", message: "请在“触控ID与密码”中添加指纹", preferredStyle: .alert)
        let imgv = UIImageView(frame: CGRect(x: 120, y: 20, width: 30, height: 30))
        imgv.image = UIImage(named:"img_fingerImage")
        alert.view.addSubview(imgv)
        let confirmAction = UIAlertAction.init(title: "去添加", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.touchIDSwitch.setOn(false, animated: true)
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        })
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            TouchIDHelper.sharedInstance.clearState()
            self.touchIDSwitch.setOn(false, animated: true)
            if self.autoCheck {
                self.dismiss(animated: true, completion: nil)
            }
        })
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func touchIDFailAlert() {
        let title = TouchIDHelper.sharedInstance.isOpen() ? (self.autoCheck ? "校验失败" : "关闭指纹认证失败") : "开启指纹认证失败"
        let alert = UIAlertController.init(title: "\n\n\(title)", message: "", preferredStyle: .alert)
        let imgv = UIImageView(frame: CGRect(x: 120, y: 20, width: 30, height: 30))
        imgv.image = UIImage(named: "img_fingerImage")
        alert.view.addSubview(imgv)
        let confirmAction = UIAlertAction.init(title: "重新登录", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            //指纹校验失败，退出登录
            if self.autoCheck {
                if TouchIDHelper.sharedInstance.isOpen() {
                    self.logout()
                }
            }
        })
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func touchIDLockOutAlert() {
        let title = "连续多次指纹校验失败，请稍后再试"
        let alert = UIAlertController.init(title: "\n\n\(title)", message: "", preferredStyle: .alert)
        let imgv = UIImageView(frame: CGRect(x: 120, y: 20, width: 30, height: 30))
        imgv.image = UIImage(named: "img_fingerImage")
        alert.view.addSubview(imgv)
        self.touchIDSwitch.setOn(TouchIDHelper.sharedInstance.isOpen(), animated: true)
        let buttonConfirm = (self.autoCheck && TouchIDHelper.sharedInstance.isOpen()) ? "重新登录" : "知道了"
        let confirmAction = UIAlertAction.init(title: buttonConfirm, style: .default, handler: { (action) in
            if  self.autoCheck && TouchIDHelper.sharedInstance.isOpen() {
                self.logout()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:TouchID
    func checkTouchID() {
        let desc = self.autoCheck ? "请校验指纹" : (TouchIDHelper.sharedInstance.isOpen() ? "关闭指纹认证" : "开启指纹认证")
        ETouchID().eTouch_show(withDescribe:desc) { (state, error) in
            if state == ETouchIDState.notSupport {
                self.dismiss(animated: true, completion: nil)
                ALToastView.toast(in: self.view, withText: "当前设备不支持指纹")
                
            } else if state == ETouchIDState.success {
                if self.autoCheck {
                    self.touchIDSwitch.setOn(true, animated: true)
                    TouchIDHelper.sharedInstance.setState(TouchIDHelper.TouchIDState.open)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.touchIDSwitch.setOn(!TouchIDHelper.sharedInstance.isOpen(), animated: true)
                    TouchIDHelper.sharedInstance.setState(TouchIDHelper.sharedInstance.isOpen() ? TouchIDHelper.TouchIDState.support : TouchIDHelper.TouchIDState.open)
                }
                ALToastView.toast(in: self.view, withText: "成功")
                
            } else if state == ETouchIDState.inputPassword {
                //用户选择手动输入密码
            } else if state == ETouchIDState.touchIDNotSet {
                //用户未设置指纹，提醒跳转至系统设置界面
                self.touchIDNotSetAlert()
                
            } else if state == ETouchIDState.touchIDNotAvailable {
                //touch ID无效
            } else if state == ETouchIDState.touchIDLockout {
                self.touchIDLockOutAlert()
                
            } else if state == ETouchIDState.fail {
                //指纹认证尝试3次，失败
                self.touchIDFailAlert()
                
            } else if state == ETouchIDState.userCancel {
                self.touchIDSwitch.setOn(TouchIDHelper.sharedInstance.isOpen(), animated: true)
                if self.autoCheck {
                    if TouchIDHelper.sharedInstance.isSupport() {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.logout()
                    }
                }
                
            } else if state == ETouchIDState.systemCancel {
                //被系统取消
            } else {
                //其他问题 例如 手机没有密码，手机没设置指纹，来电，锁屏，home键 手动取消
                
            }
        }
    }
    
    
    func logout() {
        //logout, clear data and reset state
        TouchIDHelper.sharedInstance.setState(TouchIDHelper.TouchIDState.support)
        ALToastView.toast(in: self.view, withText: "登出")
        self.dismiss(animated: true, completion: nil)
    }

}
