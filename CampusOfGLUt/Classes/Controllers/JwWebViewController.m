//
//  JwWebViewController.m
//  CampusOfGLUT
//
//  Created by HTC on 15/4/30.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "JwWebViewController.h"

@interface JwWebViewController ()

@end

@implementation JwWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self initNavi];
    [self initWebView];
}

- (void)initWebView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView * jwWeb = [[UIWebView alloc ]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    
    jwWeb.backgroundColor = [UIColor whiteColor];
    jwWeb.scalesPageToFit = YES;
    
    [self.view addSubview:jwWeb];
    
    
    NSURLRequest *jwRequest = [NSURLRequest requestWithURL:self.jwURL];
    
    [jwWeb loadRequest:jwRequest];
    
    [jwWeb reload];

}

- (void)initNavi{
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationbar_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backTips)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backTips{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
