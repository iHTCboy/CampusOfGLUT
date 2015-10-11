//
//  ContentTableViewController.m
//  CampusOfGLUt
//
//  Created by HTC on 15/2/13.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "ContentTableViewController.h"
#import "BaseWebViewController.h"
#import "TOWebViewController.h"
#import "JwLoginVCViewController.h"

@interface ContentTableViewController ()

@end

@implementation ContentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString * studyCellID = @"contentCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:studyCellID];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:studyCellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary  * dic = self.contentArray[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"title"];
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
       cell.textLabel.font = [UIFont systemFontOfSize:23.0f];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    NSDictionary  * dic = self.contentArray[indexPath.row];
    NSString *url = [dic objectForKey:@"content"];
    if ([url hasPrefix:@"http"])
    {
        [self openTOWebViewWithURL:url];
    }
    else if([url hasPrefix:@"jw"]){
        JwLoginVCViewController * jw = [[JwLoginVCViewController alloc]init];
        if([url hasPrefix:@"jws"]){
            jw.isStudent = YES;
        }else{
            jw.isStudent = NO;
        }
       [self.navigationController pushViewController:jw animated:YES];
        
    }else{
        BaseWebViewController * webVc = [[BaseWebViewController alloc]init];
        webVc.title = [dic objectForKey:@"title"];
        webVc.contentStr = url;
        [self.navigationController pushViewController:webVc animated:YES];
    }
}

- (void)openTOWebViewWithURL:(NSString *)url
{
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    
    [self.navigationController pushViewController:webViewController animated:YES];
    
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

@end
