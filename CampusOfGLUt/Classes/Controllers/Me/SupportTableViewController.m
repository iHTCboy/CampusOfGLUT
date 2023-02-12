
//
//  SupportTableViewController.m
//  CampusOfGLUT
//
//  Created by HTC on 15/5/8.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "SupportTableViewController.h"
#import "InformationHandleTool.h"

@interface SupportTableViewController ()

@property (nonatomic,strong) NSArray * supportArray;
@property (nonatomic,strong) NSArray * supportURLArray;

@end

@implementation SupportTableViewController

- (NSArray *)supportArray{
    
    if (_supportArray == nil) {
        
        _supportArray = @[@"AFNetworking",@"SDWebImage",@"FMDB",@"TFHpple",@"JGProgressHUD",@"ODRefreshControl",@"CRToast",@"RDVTabBarController",@"MWPhotoBrowser",@"MBProgressHUD",@"TOWebViewController",@"KxMenu",@"XHTwitterPaggingView",@"DXAlertView"];
    }
    
    return _supportArray;
}


- (NSArray *)supportURLArray{
    
    if (_supportURLArray == nil) {
        
        _supportURLArray = @[@"https://github.com/AFNetworking/AFNetworking",@"https://github.com/rs/SDWebImage",@"https://github.com/ccgus/fmdb",@"https://github.com/topfunky/hpple",@"https://github.com/JonasGessner/JGProgressHUD",@"https://github.com/jdg/MBProgressHUD",@"https://github.com/Sephiroth87/ODRefreshControl",@"https://github.com/cruffenach/CRToast",@"https://github.com/robbdimitrov/RDVTabBarController",@"https://github.com/mwaterfall/MWPhotoBrowser",@"https://github.com/TimOliver/TOWebViewController",@"https://github.com/kolyvan/kxmenu",@"https://github.com/duowan/TwitterPaggingViewer",@"https://github.com/xiekw2010/DXAlertView"];
    }
    
    return _supportURLArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"感谢开源";
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.supportArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * studyCellID = @"contentCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:studyCellID];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:studyCellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.supportArray[indexPath.row];
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
        cell.textLabel.font = [UIFont systemFontOfSize:23.0f];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [[InformationHandleTool sharedInfoTool] inSafariOpenWithURL:self.supportURLArray[indexPath.row]];
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
