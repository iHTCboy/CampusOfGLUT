//
//  AppDelegate.m
//  CampusOfGLUt
//
//  Created by HTC on 15/2/11.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "AppDelegate.h"
#import "AppUtils.h"
#import "RootViewController.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "JDStatusBarNotification.h"
#import "QQSDKTool.h"
#import "WeiboSDKTool.h"
#import "WeixinSDKTool.h"
#import "HUDUtil.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "BaiduMobStat.h"
#import "Utility.h"

static NSString *const customStyle = @"customStyle";

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //设置网络
    [self setNetwrkingTips];
    
    //向微博注册
    [WeiboSDK registerApp:kWeiboKey];
    #if DEBUG
    [WeiboSDK enableDebugMode:YES];
    #endif
    
    //向微信注册
    [WXApi registerApp:kWXKey enableMTA:YES];
    
    //向腾讯注册
    __unused id qq = [[TencentOAuth alloc] initWithAppId:QQKey andDelegate:nil]; //注册
    
    //百度统计
    [self startBaiduMobStat];
    

    RootViewController *rootVC = [[RootViewController alloc] init];
    rootVC.tabBar.translucent = YES;
    
    [self.window setRootViewController:rootVC];
    [self.window makeKeyAndVisible];
    return YES;
}

/**
 *  初始化百度统计SDK
 */
- (void)startBaiduMobStat {
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    // 此处(startWithAppId之前)可以设置初始化的可选参数，具体有哪些参数，可详见BaiduMobStat.h文件，例如：
    statTracker.shortAppVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //    statTracker.enableDebugOn = YES;
    [statTracker startWithAppId:@"057db5e816"]; // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
#if DEBUG
    NSLog(@"Debug Model");
#else
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    df.locale = [NSLocale currentLocale];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *currentDate = [df stringFromDate:[NSDate new]];
    
    // 自定义事件
    [statTracker logEvent:@"usermodelName" eventLabel:[Utility getCurrentDeviceModel]];
    [statTracker logEvent:@"systemVersion" eventLabel:[[UIDevice currentDevice] systemVersion]];
    [statTracker logEvent:@"Devices" eventLabel:[[UIDevice currentDevice] name]];
    [statTracker logEvent:@"DateAndDeviceName" eventLabel:[NSString stringWithFormat:@"%@ %@", currentDate, [[UIDevice currentDevice] name]]];
    [statTracker logEvent:@"DateSystemVersion" eventLabel:[NSString stringWithFormat:@"%@ %@", currentDate, [[UIDevice currentDevice] systemVersion]]];
#endif
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *string =[url absoluteString];
    if ([string hasPrefix:@"wb911173567"])
    {
        WeiboSDKTool *weibo = [[WeiboSDKTool alloc]init];
        return [WeiboSDK handleOpenURL:url delegate:weibo];
    }
    else if ([string hasPrefix:kWXKey])
    {
        WeixinSDKTool *wx = [[WeixinSDKTool alloc]init];
        return [WXApi handleOpenURL:url delegate:wx];
    }
    else if ([string hasPrefix:@"tencent1104292447"])
    {
        QQSDKTool * qq = [[QQSDKTool alloc]init];
        return [QQApiInterface handleOpenURL:url delegate:qq];
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *string =[url absoluteString];
    if ([string hasPrefix:@"wb911173567"])
    {
        WeiboSDKTool *weibo = [[WeiboSDKTool alloc]init];
        return [WeiboSDK handleOpenURL:url delegate:weibo];
    }
    else if ([string hasPrefix:kWXKey])
    {
        WeixinSDKTool *wx = [[WeixinSDKTool alloc]init];
        return [WXApi handleOpenURL:url delegate:wx];
    }
    else if ([string hasPrefix:@"tencent1104292447"])
    {
        QQSDKTool * qq = [[QQSDKTool alloc]init];
        return [QQApiInterface handleOpenURL:url delegate:qq];
    }
    return NO;
}

- (void)setNetwrkingTips
{
    //网络
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        HUDUtil *hud = [HUDUtil sharedHUDUtil];
        
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [hud showTextHUDWithText:@"正在使用WiFi网络" position:JGProgressHUDPositionBottomCenter marginInsets:UIEdgeInsetsMake(0, 0, 55, 0) delay:2.0 zoom:NO inView:[UIApplication sharedApplication].keyWindow];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSString * stae = [self getNetWorkStates];
                    [hud showTextHUDWithText:[NSString stringWithFormat:@"正在使用%@网络",stae] position:JGProgressHUDPositionBottomCenter marginInsets:UIEdgeInsetsMake(0, 0, 55, 0) delay:2.0 zoom:NO inView:[UIApplication sharedApplication].keyWindow];
                });
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
                //[hud showAlertViewWithTitle:@"提示" mesg:@"当前没有网络连接" cancelTitle:nil confirmTitle:@"确认" tag:0];
                //@"当前没有网络连接"
                break;
            default:
                //TPLog(@"未知网络");
                break;
        }
        
    }];
}

/**
 *  此方法存在一定的局限性，比如当状态栏被隐藏的时候，无法使用此方法
 */
- (NSString *)getNetWorkStates{
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                {
                    state = @"WIFI";
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}

@end

