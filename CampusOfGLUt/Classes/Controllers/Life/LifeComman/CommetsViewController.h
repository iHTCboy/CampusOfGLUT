//
//  CommetsViewController.h
//  CampusOfGLUT
//
//  Created by HTC on 15/3/29.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LifeFrameModel.h"
#import "LifeModel.h"

@interface CommetsViewController : UIViewController

@property (nonatomic, copy) NSString * tableID;
@property (nonatomic, strong) LifeFrameModel *lifeFrameModel;

@end
