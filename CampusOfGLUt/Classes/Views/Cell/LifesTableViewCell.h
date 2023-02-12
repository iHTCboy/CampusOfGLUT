//
//  LifesTableViewCell.h
//  CampusOfGLUT
//
//  Created by HTC on 15/3/1.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LifeModel.h"
#import "LifeFrameModel.h"
#import "LifeTopView.h"
#import "LifeToolBarView.h"
@class LifeFrameModel;

@interface LifesTableViewCell : UITableViewCell
/** frame模型 */
@property (nonatomic, strong) LifeFrameModel *lifeFrameModel;
/** 顶部的view */
@property (nonatomic, weak) LifeTopView *topView;

/** 说说的工具条 */
@property (nonatomic, weak) LifeToolBarView *lifeToolbar;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
