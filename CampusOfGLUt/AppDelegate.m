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


static NSString *const customStyle = @"customStyle";

@interface AppDelegate ()

@end

@implementation AppDelegate

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


#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //设置网络
    [self setNetwrkingTips];
    
    //向微博注册
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kWeiboKey];
    
    
    //向微信注册
    [WXApi registerApp:kWXKey withDescription:@"CampusOfGLUT"];
    
    //向腾讯注册
    [[TencentOAuth alloc] initWithAppId:QQKey andDelegate:nil]; //注册

   // TencentOAuth * _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQKey andDelegate:self]; //注册
    
//    NSArray *_permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_ADD_TOPIC, kOPEN_PERMISSION_ADD_SHARE, nil];
//    [_tencentOAuth authorize:_permissions inSafari:NO]; //授权

    RootViewController *rootVC = [[RootViewController alloc] init];
    rootVC.tabBar.translucent = YES;
    
    [self.window setRootViewController:rootVC];

    [self.window makeKeyAndVisible];
    return YES;

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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



@end
