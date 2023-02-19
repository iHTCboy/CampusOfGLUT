//
//  SetingViewController.m
//  CampusOfGLUT
//
//  Created by HTC on 15/4/5.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "SetingViewController.h"
#import "InformationHandleTool.h"
#import "TOWebViewController.h"
#import "SupportTableViewController.h"
#import "RDVTabBarController.h"
#import <StoreKit/StoreKit.h>
#import "CampusOfGLUT-Swift.h"

@class ITAdvancelDetailViewController;

@interface SetingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * mainTableView;

@property (nonatomic, strong) NSArray * contentArray;
@property (nonatomic, strong) NSArray * subTitleArray;


@end

@implementation SetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于应用";
    
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.000];
    }
    
    [self initTableView];
    
    self.contentArray = @[@"桂林理工大学",@"觉得不错？",@"应用内评分",@"意见反馈",@"作者微博",@"作者博客",@"推荐应用",@"项目源码",@"感谢开源",@"用户条款"];
    self.subTitleArray = @[@"官网",@"AppStore评分",@"马上评分",@"建议问题",@"关注动态",@"技术心得",@"Apps",@"GitHub",@"开源组件",@"隐私协议"];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)initTableView
{
    UITableView * mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -64) style:UITableViewStylePlain];
    self.mainTableView = mainTable;
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
    
    if (@available(iOS 13.0, *)) {
        mainTable.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
    }
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * setingCellID = @"setingCELl";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:setingCellID];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:setingCellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (@available(iOS 13.0, *)) {
        cell.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:18.0f];
    cell.textLabel.text = self.contentArray[indexPath.row];
    cell.detailTextLabel.text = self.subTitleArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
             [[InformationHandleTool sharedInfoTool] inSafariOpenWithURL:@"https://www.glut.edu.cn"];
            break;
        case 1:
            [[InformationHandleTool sharedInfoTool] inAppStoreWithID:@"968615456"];
            break;
        case 2:
        {
            if (@available(iOS 10.3, *)) {
                [SKStoreReviewController requestReview];
            }else{
                [[InformationHandleTool sharedInfoTool] inAppStoreWithID:@"968615456"];
            }
            break;
        }
        case 3:
        {
            if (![MFMailComposeViewController canSendMail]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前设备不支持发送邮件~" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            [[InformationHandleTool sharedInfoTool] sendEmailWithSubject:@"使用桂工校园通的建议反馈" MessageBody:[NSString stringWithFormat:@"我现在使用桂工校园通v%@,使用设备：%@,iOSv%@\n我的反馈和建议：\n1、\n2、\n3、",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[UIDevice currentDevice] model],[[UIDevice currentDevice] systemVersion]] isHTML:NO toRecipients:@[@"iHTCdevelop@gmail.com"] ccRecipients:nil bccRecipients:nil  Image:nil imageQuality:0 Controller:self];
            break;
        }
        case 4:
            [[InformationHandleTool sharedInfoTool] inSafariOpenWithURL:@"http://weibo.com/iHTCapp"];
            break;
        case 5:
            [[InformationHandleTool sharedInfoTool] inSafariOpenWithURL:@"https://www.iHTCboy.com"];
            break;
        case 6: {
            ITAdvancelDetailViewController * apps = [[ITAdvancelDetailViewController alloc]init];
            [self.navigationController pushViewController:apps animated:YES];
            break;
        }
        case 7:{
            [[InformationHandleTool sharedInfoTool] inSafariOpenWithURL:@"https://github.com/iHTCboy/CampusOfGLUT"];
            break;
        }
        case 8:{
            [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
            SupportTableViewController * vc = [[SupportTableViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 9:{
            [[InformationHandleTool sharedInfoTool] inSafariOpenWithURL:@"https://raw.githubusercontent.com/iHTCboy/CampusOfGLUT/master/LICENSE"];
            break;
        }
        default:
            break;
    }
}


- (void)openToWebViewWithURL:(NSString *)url
{
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    [self.navigationController pushViewController:webViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
