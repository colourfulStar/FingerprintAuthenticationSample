//
//  ETouchID.m
//  project
//
//  Created by EBIZHZ1 on 2018/10/25.
//  Copyright © 2018年 EBIZHZ1. All rights reserved.
//

#import "ETouchID.h"

@implementation ETouchID

+ (instancetype)instance {
    static ETouchID *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ETouchID alloc] init];
    });
    return instance;
}

-(void)ETouch_showTouchIDWithDescribe:(NSString *)desc BlockState:(StateBlock)block{
    
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"系统版本不支持TouchID (必须高于iOS 8.0才能使用)");
            block(ETouchIDStateVersionNotSupport,nil);
        });
        
        return;
    }
    
    LAContext *context = [[LAContext alloc]init];
    
    //取消按钮
    context.localizedFallbackTitle = @"";
    
    NSError *error = nil;
    
    if (@available(iOS 9.0, *)) {
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            //开始验证
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:desc == nil ? @"开启/关闭指纹检验":desc reply:^(BOOL success, NSError * _Nullable error) {
                
                if (success) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"TouchID 验证成功");
                        block(ETouchIDStateSuccess,error);
                    });
                }else if(error){
                    switch (error.code) {
                        case LAErrorAuthenticationFailed:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"TouchID 验证失败");
                                block(ETouchIDStateFail,error);
                            });
                            break;
                        }
                        case LAErrorUserCancel:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"TouchID 被用户手动取消");
                                block(ETouchIDStateUserCancel,error);
                            });
                        }
                            break;
                        case LAErrorUserFallback:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"用户不使用TouchID,选择手动输入密码");
                                block(ETouchIDStateInputPassword,error);
                            });
                        }
                            break;
                        case LAErrorSystemCancel:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)");
                                block(ETouchIDStateSystemCancel,error);
                            });
                        }
                            break;
                        case LAErrorPasscodeNotSet:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"TouchID 无法启动,因为用户没有设置密码");
                                block(ETouchIDStatePasswordNotSet,error);
                            });
                        }
                            break;
                        case LAErrorBiometryNotEnrolled:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"TouchID 无法启动,因为用户没有设置TouchID");
                                block(ETouchIDStateTouchIDNotSet,error);
                            });
                        }
                            break;
                        case LAErrorBiometryNotAvailable:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"TouchID 无效");
                                block(ETouchIDStateTouchIDNotAvailable,error);
                            });
                        }
                            break;
                        case LAErrorBiometryLockout:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)");
                                block(ETouchIDStateTouchIDLockout,error);
                            });
                        }
                            break;
                        case LAErrorAppCancel:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                                block(ETouchIDStateAppCancel,error);
                            });
                        }
                            break;
                        case LAErrorInvalidContext:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                                block(ETouchIDStateInvalidContext,error);
                            });
                        }
                            break;
                        default:
                            break;
                    }
                }
            }];
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //不支持指纹识别，LOG出错误详情
                switch (error.code) {
                    case LAErrorAuthenticationFailed:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 验证失败");
                            block(ETouchIDStateFail,error);
                        });
                        break;
                    }
                    case LAErrorUserCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 被用户手动取消");
                            block(ETouchIDStateUserCancel,error);
                        });
                    }
                        break;
                    case LAErrorUserFallback:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"用户不使用TouchID,选择手动输入密码");
                            block(ETouchIDStateInputPassword,error);
                        });
                    }
                        break;
                    case LAErrorSystemCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)");
                            block(ETouchIDStateSystemCancel,error);
                        });
                    }
                        break;
                    case LAErrorPasscodeNotSet:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 无法启动,因为用户没有设置密码");
                            block(ETouchIDStatePasswordNotSet,error);
                        });
                    }
                        break;
                    case LAErrorBiometryNotEnrolled:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 无法启动,因为用户没有设置TouchID");
                            block(ETouchIDStateTouchIDNotSet,error);
                        });
                    }
                        break;
                    case LAErrorBiometryNotAvailable:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 无效");
                            block(ETouchIDStateTouchIDNotAvailable,error);
                        });
                    }
                        break;
                    case LAErrorBiometryLockout:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)");
                            block(ETouchIDStateTouchIDLockout,error);
                        });
                    }
                        break;
                    case LAErrorAppCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                            block(ETouchIDStateAppCancel,error);
                        });
                    }
                        break;
                    case LAErrorInvalidContext:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                            block(ETouchIDStateInvalidContext,error);
                        });
                    }
                        
                    default:
                    {
                        NSLog(@"TouchID 未知的错误");
                        block(ETouchIDStateNotSupport,error);
                        break;
                    }
                }
            });
        }
    }
}


@end
