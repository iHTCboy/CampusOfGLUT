//
//  Study_RootViewController.m
//  CampusOfGLUt
//
//  Created by HTC on 15/2/11.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "Study_RootViewController.h"
#import "ContentTableViewController.h"
#import "RDVTabBarController.h"
#import "InformationHandleTool.h"

@interface Study_RootViewController ()

@property (nonatomic, strong) NSArray * studyArray;

@property (nonatomic, strong) InformationHandleTool * infoTool;

@end

@implementation Study_RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"学习";
    
    if (self.rdv_tabBarController.tabBar.translucent) {
        UIEdgeInsets insets = UIEdgeInsetsMake(0,
                                               0,
                                               CGRectGetHeight(self.rdv_tabBarController.tabBar.frame),
                                               0);
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    
    NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"studyItem.plist" ofType:nil];
    self.studyArray = [[NSArray alloc]initWithContentsOfFile:plistPath];
    
     self.infoTool = [InformationHandleTool sharedInfoTool];
}


- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.studyArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * studyCellID = @"studyCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:studyCellID];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:studyCellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.studyArray[indexPath.row][0];
    
    if (![self.infoTool isDeviceOfiPhone]) {//iPad字体大些
        cell.textLabel.font = [UIFont systemFontOfSize:23.0f];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    ContentTableViewController * contentView = [[ContentTableViewController alloc]init];
    contentView.title = self.studyArray[indexPath.row][0];
    contentView.contentArray = self.studyArray[indexPath.row][1];
    
    [self.navigationController pushViewController:contentView animated:YES];
    

}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.infoTool isDeviceOfiPhone])
    {
        return 44;
    }else{
        return 60;
    }
}

@end
