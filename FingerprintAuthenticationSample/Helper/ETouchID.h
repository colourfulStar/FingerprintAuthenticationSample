//
//  ETouchID.h
//  project
//
//  Created by EBIZHZ1 on 2018/10/25.
//  Copyright © 2018年 EBIZHZ1. All rights reserved.
//


#import <LocalAuthentication/LocalAuthentication.h>

/**
 *  TouchID 状态
 */
typedef NS_ENUM(NSUInteger, ETouchIDState){
    
    /**
     *  当前设备不支持TouchID
     */
    ETouchIDStateNotSupport = 0,
    /**
     *  TouchID 验证成功
     */
    ETouchIDStateSuccess = 1,
    
    /**
     *  TouchID 验证失败
     */
    ETouchIDStateFail = 2,
    /**
     *  TouchID 被用户手动取消
     */
    ETouchIDStateUserCancel = 3,
    /**
     *  用户不使用TouchID,选择手动输入密码
     */
    ETouchIDStateInputPassword = 4,
    /**
     *  TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)
     */
    ETouchIDStateSystemCancel = 5,
    /**
     *  TouchID 无法启动,因为用户没有设置密码
     */
    ETouchIDStatePasswordNotSet = 6,
    /**
     *  TouchID 无法启动,因为用户没有设置TouchID
     */
    ETouchIDStateTouchIDNotSet = 7,
    /**
     *  TouchID 无效
     */
    ETouchIDStateTouchIDNotAvailable = 8,
    /**
     *  TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)
     */
    ETouchIDStateTouchIDLockout = 9,
    /**
     *  当前软件被挂起并取消了授权 (如App进入了后台等)
     */
    ETouchIDStateAppCancel = 10,
    /**
     *  当前软件被挂起并取消了授权 (LAContext对象无效)
     */
    ETouchIDStateInvalidContext = 11,
    /**
     *  系统版本不支持TouchID (必须高于iOS 8.0才能使用)
     */
    ETouchIDStateVersionNotSupport = 12
};



@interface ETouchID : LAContext

typedef void (^StateBlock)(ETouchIDState state,NSError *error);


/**
 启动TouchID进行验证
 
 @param desc Touch显示的描述
 @param block 回调状态的block
 */

-(void)ETouch_showTouchIDWithDescribe:(NSString *)desc BlockState:(StateBlock)block;


@end
