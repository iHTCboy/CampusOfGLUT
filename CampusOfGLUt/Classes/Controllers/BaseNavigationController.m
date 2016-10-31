//
//  BaseNavigationController.m
//  CampusOfGLUt
//
//  Created by HTC on 15/2/11.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "BaseNavigationController.h"

#import "BaiduMobStat.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self customizeInterface];
}

- (void)customizeInterface {
    //设置Nav的背景色和title色
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];

    [navigationBarAppearance setBarTintColor:kAppMainColor];
   // [navigationBarAppearance setTintColor:[UIColor whiteColor]];//返回按钮的箭头颜色
    //        [[UITextField appearance] setTintColor:[UIColor redColor]];//设置UITextField的光标颜色
    //        [[UITextView appearance] setTintColor:[UIColor redColor]];//设置UITextView的光标颜色
    NSDictionary *textAttributes = nil;
    textAttributes = @{
                       NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                       NSForegroundColorAttributeName: [UIColor whiteColor],
                       };
    
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
   
    
    navigationBarAppearance.translucent = NO;
    
    //状态栏为白色
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];

    UINavigationBar * navigationBar = [UINavigationBar appearance];
    //返回按钮的箭头颜色
    [navigationBar setTintColor:[UIColor whiteColor]];
    //设置返回样式图片
    UIImage *image = [UIImage imageNamed:@"navigationbar_back"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navigationBar.backIndicatorImage = image;
    navigationBar.backIndicatorTransitionMaskImage = image;
    

    
    UIBarButtonItem *buttonItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    UIOffset offset;
    offset.horizontal = - 500;
    offset.vertical =  - 500;
    [buttonItem setBackButtonTitlePositionAdjustment:offset forBarMetrics:UIBarMetricsDefault];
}

// 进入页面，建议在此处添加
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString* cName = [NSString stringWithFormat:@"%@",  self.title, nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
}

// 退出页面，建议在此处添加
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSString* cName = [NSString stringWithFormat:@"%@", self.title, nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}

@end
