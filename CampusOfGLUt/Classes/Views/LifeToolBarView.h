//
//  LifeToolBarView.h
//  CampusOfGLUT
//
//  Created by HTC on 15/3/27.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LifeFrameModel;

@protocol LifeToolBarViewDelegate <NSObject>

@optional
- (void)lifeToolBarClicked:(UIButton *)button lifeMode:(LifeFrameModel *)lifeFrameModel superviewCell:(UIView *)cell;

@end

@interface LifeToolBarView : UIImageView

@property (nonatomic,weak) id <LifeToolBarViewDelegate>delegate;

@property (nonatomic,strong) LifeFrameModel * lifeFrameModel;

@end
