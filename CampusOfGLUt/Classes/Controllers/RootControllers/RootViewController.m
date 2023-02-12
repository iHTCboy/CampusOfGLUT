//
//  RootViewController.m
//  CampusOfGLUt
//
//  Created by HTC on 15/2/11.
//  Copyright (c) 2015年 HTC. All rights reserved.
//


#import "RootViewController.h"
#import "BaseNavigationController.h"
#import "Trends_RootViewController.h"
#import "NewsCenter_RootViewController.h"
#import "Announcements_RootViewController.h"
#import "XSHDViewController.h"
#import "XYKXViewController.h"
#import "MTGGViewController.h"
#import "RMJZViewController.h"
#import "Study_RootViewController.h"
#import "Life_RootViewController.h"
#import "Me_ViewController.h"
#import "RDVTabBarItem.h"
#import "XHTwitterPaggingViewer.h"


#import "Me_ViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupViewControllers];
}



#pragma mark - Methods

- (void)setupViewControllers {
    
    XHTwitterPaggingViewer * twitterPaggingViewer = [[XHTwitterPaggingViewer alloc] init];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    Trends_RootViewController *trends = [[Trends_RootViewController alloc] init];
    trends.title = @"科教动态";
    [viewControllers addObject:trends];
    
    NewsCenter_RootViewController *newsCenter = [[NewsCenter_RootViewController alloc] init];
    newsCenter.title = @"新闻中心";
    [viewControllers addObject:newsCenter];

    Announcements_RootViewController *announcements = [[Announcements_RootViewController alloc] init];
    announcements.title = @"通知公告";
    [viewControllers addObject:announcements];
    
    twitterPaggingViewer.viewControllers = viewControllers;
    twitterPaggingViewer.didChangedPageCompleted = ^(NSInteger cuurentPage, NSString *title) {
       // NSLog(@"cuurentPage : %ld on title : %@", (long)cuurentPage, title);
    };
    UINavigationController *nav_trends = [[UINavigationController alloc]
                                                   initWithRootViewController:twitterPaggingViewer];
    

    
    XHTwitterPaggingViewer * lifePaggingViewer = [[XHTwitterPaggingViewer alloc] init];
    NSMutableArray *lifeControllers = [[NSMutableArray alloc] init];
    
    XSHDViewController *xshd = [[XSHDViewController alloc] init];
    xshd.title = @"学术活动";
    [lifeControllers addObject:xshd];
    
    XYKXViewController *xykx = [[XYKXViewController alloc] init];
    xykx.title = @"校园快讯";
    [lifeControllers addObject:xykx];

    MTGGViewController *mtgg = [[MTGGViewController alloc] init];
    mtgg.title = @"媒体桂工";
    [lifeControllers addObject:mtgg];
    
    RMJZViewController *rmjz = [[RMJZViewController alloc] init];
    rmjz.title = @"融媒矩阵";
    [lifeControllers addObject:rmjz];
    
    lifePaggingViewer.viewControllers = lifeControllers;
    lifePaggingViewer.didChangedPageCompleted = ^(NSInteger cuurentPage, NSString *title) {
       // NSLog(@"cuurentPage : %ld on title : %@", (long)cuurentPage, title);
    };
    UINavigationController *nav_life = [[UINavigationController alloc]
                                                   initWithRootViewController:lifePaggingViewer];
    
    
    Study_RootViewController *study = [[Study_RootViewController alloc] init];
    UINavigationController *nav_study = [[UINavigationController alloc]
                                                    initWithRootViewController:study];
    
//    Life_RootViewController *life = [[Life_RootViewController alloc] init];
//    UINavigationController *nav_life = [[UINavigationController alloc]
//                                                   initWithRootViewController:life];
    
    Me_ViewController *me = [[Me_ViewController alloc] init];
    UINavigationController *nav_me = [[UINavigationController alloc]
                                                   initWithRootViewController:me];
    
    [self setViewControllers:@[nav_trends, nav_life, nav_study, nav_me]];
    self.tabBar.tintColor = kAppMainColor;
    self.hidesBottomBarWhenPushed = YES;
    
    //UIImage *backgroundImage = [UIImage imageNamed:@"tabbar_background"];
    NSArray *tabBarItemImages = @[@"trends", @"life", @"study", @"me"];
    NSArray *tabBarItemTitles = @[@"动态", @"生活", @"学习", @"我"];
//    NSArray *tabBarItemImages = @[@"trends", @"study", @"me"];
//    NSArray *tabBarItemTitles = @[@"动态", @"学习", @"我"];
    
    NSInteger index = 0;
    for (UIViewController *vc in self.viewControllers)
    {
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",[tabBarItemImages objectAtIndex:index]]];
        //UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",[tabBarItemImages objectAtIndex:index]]];
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:[tabBarItemTitles objectAtIndex:index] image:selectedimage tag:index];
        index++;
    
    }
    
}



- (void)customizeTabBarForController
{

//    let words = WordsViewController()
//    words.tabBarItem = UITabBarItem.init(title: "iEnglish", image: #imageLiteral(resourceName: "tabbar_iEnglish"), tag: 0)
//
//    let category = CategoryViewController()
//    category.tabBarItem = UITabBarItem.init(title: "Category", image: #imageLiteral(resourceName: "tabbar_categate"), tag: 1)
//
//    let setting = SettingController()
//    setting.tabBarItem = UITabBarItem.init(title: "Setting", image: #imageLiteral(resourceName: "tabbar_setting"), tag: 2)
//
//    viewControllers = [TCNavigationController(rootViewController: words), TCNavigationController(rootViewController: category), TCNavigationController(rootViewController: setting)]
//    tabBar.tintColor = kColorAppMain

}

//- (BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    if (tabBarController.selectedViewController == viewController) {
//        if ([viewController isKindOfClass:[UINavigationController class]]) {
//            UINavigationController *nav = (UINavigationController *)viewController;
//            if (nav.topViewController == nav.viewControllers[0]) {
//                UIViewController *rootVC = (UIViewController *)nav.topViewController;
//#pragma clang diagnostic ignored "-Warc-performSelector"
//                [rootVC performSelector:@selector(tabBarItemClicked)];
//            }
//        }
//    }
//    return YES;
//}

@end
