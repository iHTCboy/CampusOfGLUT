//
//  Life_RootViewController.m
//  CampusOfGLUt
//
//  Created by HTC on 15/2/11.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "Life_RootViewController.h"
#import "RDVTabBarController.h"

#import "InformationHandleTool.h"


@interface Life_RootViewController ()

@property (nonatomic, strong) NSArray * lifeNames;

@property (nonatomic, strong) NSArray * lifeIamges;

@property (nonatomic, strong) NSArray * classNames;

@property (nonatomic, strong) InformationHandleTool * infoTool;
@end

@implementation Life_RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTabBarStyle];
    
    //self.title = @"校园话题";
    
    self.lifeNames = @[@"公告栏",@"说在桂工",@"学在桂工",@"吃在桂工",@"住在桂工",@"景在桂工",@"玩在桂工",@"找在桂工",@"淘在桂工",@"交在桂工",@"问在桂工"];
    
    self.lifeIamges = @[@"life_0",@"life_1",@"life_2",@"life_3",@"life_4",@"life_5",@"life_6",@"life_7",@"life_8",@"life_9",@"life_10"];
    
    NSArray *mapClassNames = @[@"BulletinBoardViewController",
                               @"TalkInGLUTViewController",
                               @"StudyInGLUTViewController",
                               @"EatInGLUTViewController",
                               @"LivingInGLUTViewController",
                               @"SceneryInGLUTViewController",
                               @"PlayInGLUTViewController",
                               @"LookingInGLUTViewController",
                               @"TaoBaoInGLUTViewController",
                               @"CommunicationInGLUTViewController",
                               @"AskInGLUTViewController"];
    
    self.classNames = [NSArray arrayWithObjects:mapClassNames, nil];
    
    self.infoTool = [InformationHandleTool sharedInfoTool];
}

- (void)setTabBarStyle
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0,0,50,0);
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.title = @"校园话题";
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.title = @"生活";
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lifeNames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * studyCellID = @"liefCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:studyCellID];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:studyCellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    

    cell.textLabel.text = self.lifeNames[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.lifeIamges[indexPath.row]];
    
    if (![self.infoTool isDeviceOfiPhone]) {//iPad字体大些
            cell.textLabel.font = [UIFont systemFontOfSize:23.0f];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    
    NSString *className = self.classNames[indexPath.section][indexPath.row];
    
    UIViewController *VC = [[NSClassFromString(className) alloc] init];
    VC.title = self.lifeNames[indexPath.row];
    [self.navigationController pushViewController:VC animated:YES];

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
