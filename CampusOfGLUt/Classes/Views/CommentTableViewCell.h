//
//  CommentTableViewCell.h
//  CampusOfGLUT
//
//  Created by HTC on 15/3/29.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentFrameModel.h"
#import "CommentView.h"
#import "CommentModel.h"

@interface CommentTableViewCell : UITableViewCell

/** frame模型 */
@property (nonatomic, strong) CommentFrameModel *commentFrameModel;
/** 顶部的view */
@property (nonatomic, weak) CommentView *topView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
