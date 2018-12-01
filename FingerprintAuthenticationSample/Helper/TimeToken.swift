//
//  TimeToken.swift
//  FingerprintAuthenticationSample
//
//  Created by EBIZM1 on 2018/11/23.
//  Copyright © 2018 ZhangXiQian. All rights reserved.
//

import UIKit

class TimeToken: NSObject {
    
    //获取当前时间戳
    func getNowTimeToken() -> String {
        let now = NSDate()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp : String = String(timeInterval)
        return timeStamp
    }
    
    //获取本周一凌晨的时间戳
    func getMondayMoringTimeInterval() -> Double {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let nowDate = dateFormatter.date(from: TimeToken().getdayTimeToken())
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "zh_CN")
        let comp = calendar.dateComponents([.year, .month, .day, .weekday], from: nowDate!)
        
        // 获取今天是周几
        let weekDay = comp.weekday
        // 获取几天是几号
        let day = comp.day
        
        // 计算当前日期和本周的星期一和星期天相差天数
        var firstDiff: Int
        if (weekDay == 1) {
            firstDiff = -6;
        } else {
            firstDiff = calendar.firstWeekday - weekDay! + 1
        }
        
        // 在当前日期(去掉时分秒)基础上加上差的天数
        var firstDayComp = calendar.dateComponents([.year, .month, .day], from: nowDate!)
        firstDayComp.day = day! + firstDiff
        let firstDayOfWeek = calendar.date(from: firstDayComp)
        let firstDay = dateFormatter.string(from: firstDayOfWeek!)
        
        let firstDate = dateFormatter.date(from: firstDay)
        let dateStamp:TimeInterval = firstDate!.timeIntervalSince1970
        return Double(dateStamp)
    }
    
    //获取当前时间
    func getdayTimeToken() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        let locale = Locale.init(identifier: Locale.preferredLanguages[0])
        dateformatter.locale = locale
        let locationString = dateformatter.string(from: Date())
        return locationString
    }

}
