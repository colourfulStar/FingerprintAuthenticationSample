//
//  Storage.swift
//  FingerprintAuthenticationSample
//
//  Created by EBIZM1 on 2018/11/22.
//  Copyright © 2018 ZhangXiQian. All rights reserved.
//

import UIKit

class Storage: NSObject {
    
    private override init() {    }
    
    
    enum StorageEnum: String {
        case TOUCHSTATE = "touch_state"
        case TOUCHTIME  = "touch_time"
    }
    
    
    //创建单例
    class var sharedInstance : Storage  {
        struct Static {
            static let sharedInstance : Storage = Storage()
        }
        return Static.sharedInstance
    }
    
    
    //touchID 状态
    func getTouchState() -> String {
        let state = UserDefaults.standard.object(forKey: StorageEnum.TOUCHSTATE.rawValue)
        return state == nil ? "" : state as! String
    }
    
    func setTouchState(_ state: String) {
        UserDefaults.standard.setValue(state ,forKey: StorageEnum.TOUCHSTATE.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    //使用touchID的时间戳
    func getTouchTime() -> Double {
        let time = UserDefaults.standard.object(forKey: StorageEnum.TOUCHTIME.rawValue)
        return time == nil ? 0 : time as! Double
    }
    
    func setTouchTime(_ time: Double) {
        UserDefaults.standard.setValue(time ,forKey: StorageEnum.TOUCHTIME.rawValue)
        UserDefaults.standard.synchronize()
    }

}
