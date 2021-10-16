//
//  AppDelegate.m
//  YBEducation
//
//  Created by IOS1 on 2020/2/21.
//  Copyright © 2020 IOS1. All rights reserved.
//

#import "AppDelegate.h"
#import <Bugly/Bugly.h>
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import "WYLoginViewController.h"
#import "WYTabBarController.h"
#import <Bugly/Bugly.h>
#import "EBBannerView.h"
#import <TXLiteAVSDK_Smart/TXLiveBase.h>

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;    
    [Bugly startWithAppId:BuglyId];
    
    [self thirdPlant];
    
    [TXLiveBase setLicenceURL:LicenceURL key:LicenceKey];
    NSLog(@"[TXLiveBase getSDKVersionStr] = %@",[TXLiveBase getSDKVersionStr]);
    self.window = [[UIWindow alloc]initWithFrame:CGRectMake(0,0,_window_width, _window_height)];

    if ([Config getOwnID] && [[Config getOwnID] integerValue] > 0) {
        WYTabBarController *tabbar = [[WYTabBarController alloc] init];
        self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:tabbar];

    }else{
        WYLoginViewController *tabbar = [[WYLoginViewController alloc] init];
        self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:tabbar];
    }
    [self.window makeKeyAndVisible];
    [application setApplicationIconBadgeNumber:0]; //清除角标
    [[UIApplication sharedApplication] cancelAllLocalNotifications];//清除APP所有通知消息

    return YES;
}

-(void)thirdPlant{
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        [platformsRegister setupQQWithAppId:QQAppId appkey:QQAppKey enableUniversalLink:NO universalLink:@""];
        [platformsRegister setupWeChatWithAppId:WechatAppId appSecret:WechatAppSecret universalLink:WechatUniversalLink];
    }];
    
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shajincheng" object:nil];
}

#pragma mark --- 支付宝接入
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
            
        }];
    }else{
        [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {

        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:WYAlipayRsultttt object:resultDic];

        }];
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");

        }];
    }else if ([url.host isEqualToString:@"pay"]){
        return [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];

    }
    return YES;
}
//微信支付回调
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp *response = (PayResp *)resp;
        [[NSNotificationCenter defaultCenter] postNotificationName:WYWXApiPaySuccess object:response userInfo:nil];

//        switch (response.errCode)
//        {
//            case WXSuccess:
//                //服务器端查询支付通知或查询API返回的结果再提示成功
//                NSLog(@"支付成功");
//                [[NSNotificationCenter defaultCenter] postNotificationName:WYWXApiPaySuccess object:nil userInfo:nil];
//                break;
//            case WXErrCodeUserCancel:
//                //服务器端查询支付通知或查询API返回的结果再提示成功
//                //交易取消
//                [MBProgressHUD showError:@"已取消支付"];
//                break;
//            default:
//                NSLog(@"支付失败， retcode=%d",resp.errCode);
//                [MBProgressHUD showError:@"支付失败"];
//                break;
//        }
    }
}
// 应用处于后台，所有下载任务完成调用
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler
{
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"system_notificationUpdate" object:nil];
//极光推送 新加附加附加参数 type 消息类型  1表示开播通知，2表示系统消息
//    [EBBannerView showWithContent:minstr([[userInfo valueForKey:@"aps"] valueForKey:@"alert"])];
    if (application.applicationState == UIApplicationStateActive) {
        [[NSNotificationCenter defaultCenter] postNotificationName:WYReceiveNewPushMessage object:nil userInfo:nil];
        [[EBBannerView bannerWithBlock:^(EBBannerViewMaker *make) {
            make.content = minstr([[userInfo valueForKey:@"aps"] valueForKey:@"alert"]);
            make.object = [userInfo valueForKey:@"userinfo"];
        }] show];
    }
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
}
- (void)applicationDidEnterBackground:(UIApplication *)application{
//    NSArray *array = [[UIApplication sharedApplication] windows];
//    UIWindow* win=[array objectAtIndex:0];
//    [win setHidden:YES];
}
@end
