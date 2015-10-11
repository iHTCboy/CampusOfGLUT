//
//  JWTableViewController.m
//  CampusOfGLUT
//
//  Created by HTC on 15/4/30.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "JWTableViewController.h"
#import "HUDUtil.h"
#import "JwWebViewController.h"

@interface JWTableViewController ()<HUDAlertViewDelegate>

@end

@implementation JWTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavi];
    
    NSString * jwListPath;
    if(self.isStudent){
        self.title = @"学生教务系统";
       jwListPath = [[NSBundle mainBundle] pathForResource:@"jwsInfoList.plist" ofType:nil];
    }else{
        self.title = @"教师教务系统";
       jwListPath = [[NSBundle mainBundle] pathForResource:@"jwtInfoList.plist" ofType:nil];
    }
    self.contentArray = [[NSArray alloc] initWithContentsOfFile:jwListPath];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    //不能滑动返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)viewDie{
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    self.navigationItem.leftBarButtonItem = nil;
}

- (void)initNavi{

    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationbar_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backTips)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backTips{
    
    HUDUtil *hud = [HUDUtil sharedHUDUtil];
    hud.delegate = self;
    [hud showAlertViewWithTitle:@"确定退出教务系统?" mesg:nil cancelTitle:@"取消" confirmTitle:@"确定" tag:1];
}

- (void)hudAlertView:(BOOL)isAlertView clickedAtIndex:(NSInteger)buttonIndex tag:(NSInteger)tag{
    switch (buttonIndex) {
        case 1:
            [self viewDie];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"cellID";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSInteger rowNow = [indexPath row];
    cell.textLabel.text =self.contentArray[rowNow][0];
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
        cell.textLabel.font = [UIFont systemFontOfSize:23.0f];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger rowNow = indexPath.row;

        //当左边栏List被点击时，通知代理URL
        NSURL * jwURL = [NSURL URLWithString:self.contentArray[rowNow][1]];
        NSString * jwTitle = self.contentArray[rowNow][0];
    
       NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        //判断，拼接我的课表的URL
        if (rowNow == 2 && self.isStudent)
        {
            /**
             *  http://202.193.80.58:81/academic/student/currcourse/currcourse.jsdo?groupId=&moduleId=2000
             
             http://202.193.80.58:81/academic/manager/coursearrange/showTimetable.do?id=244189&yearid=35&termid=1&timetableType=STUDENT&sectionType=BASE
             
             http://202.193.80.58:81/academic/manager/coursearrange/showTimetable.do?id=244189&yearid=35&termid=1&timetableType=STUDENT&sectionType=COMBINE
             */
            
            //获取我的课表的URL信息
            NSURL * url =[NSURL URLWithString:@"http://202.193.80.58:81/academic/student/currcourse/currcourse.jsdo?groupId=&moduleId=2000"];
            
            NSData * data = [NSData dataWithContentsOfURL:url];
            //gbk转UTF-8
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString * urlString = [[NSString alloc]initWithData:data encoding:gbkEncoding];
            
            NSString * middel = (NSString *) [[[[urlString componentsSeparatedByString:@"?id="] objectAtIndex:1] componentsSeparatedByString:@"=S"] objectAtIndex:0];
            
            
            NSString * clessURL = [[NSString alloc]initWithFormat:@"%@%@%@",@"http://202.193.80.58:81/academic/manager/coursearrange/showTimetable.do?id=",middel,@"=STUDENT&sectionType=COMBINE"];
            
            jwURL = [NSURL URLWithString:clessURL];
            
            [defaults setBool:YES forKey:@"ismyClass"];
            [defaults setValue:clessURL forKeyPath:@"myClass"];
            [defaults synchronize];
            
        }
    
    [self viewDie];
    JwWebViewController *webVC = [[JwWebViewController alloc] init];
    webVC.jwURL = jwURL;
    webVC.title = jwTitle;
    [self.navigationController pushViewController:webVC animated:YES];
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return 44;
    }else{
        return 60;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
