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
    
    
    //Trends_RootViewController *trends = [[Trends_RootViewController alloc] init];
    BaseNavigationController *nav_trends = [[BaseNavigationController alloc]
                                                   initWithRootViewController:twitterPaggingViewer];
    
    Study_RootViewController *study = [[Study_RootViewController alloc] init];
    BaseNavigationController *nav_study = [[BaseNavigationController alloc]
                                                    initWithRootViewController:study];
    
    Life_RootViewController *life = [[Life_RootViewController alloc] init];
    BaseNavigationController *nav_life = [[BaseNavigationController alloc]
                                                   initWithRootViewController:life];
    
    Me_ViewController *me = [[Me_ViewController alloc] init];
    BaseNavigationController *nav_me = [[BaseNavigationController alloc]
                                                   initWithRootViewController:me];
    
    [self setViewControllers:@[nav_trends, nav_study,
                                           nav_life,nav_me]];
    
    [self customizeTabBarForController];
    
    self.delegate = self;
}

- (void)customizeTabBarForController
{
    UIImage *backgroundImage = [UIImage imageNamed:@"tabbar_background"];
    NSArray *tabBarItemImages = @[@"trends", @"study", @"life", @"me"];
    NSArray *tabBarItemTitles = @[@"动态", @"学习", @"生活", @"我"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self tabBar] items])
    {
        [item setBackgroundSelectedImage:backgroundImage withUnselectedImage:backgroundImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",[tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",[tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setTitle:[tabBarItemTitles objectAtIndex:index]];
        [item setUnselectedTitleAttributes:[NSDictionary dictionaryWithObject:RGBColor(148, 148, 148) forKey:NSForegroundColorAttributeName]];
        [item setSelectedTitleAttributes:[NSDictionary dictionaryWithObject:kAppMainColor forKey:NSForegroundColorAttributeName]];
        index++;

    }

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
