//
//  LifeTopView.h
//  CampusOfGLUT
//
//  Created by HTC on 15/3/27.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LifeFrameModel;
@class LifeModel;

@protocol LifeTopViewDelegate <NSObject>

@optional
- (void)lifeTopViewClickedImageView:(LifeModel *)lifeModel;
@end

@interface LifeTopView : UIImageView

@property (nonatomic,strong) LifeFrameModel * lifeFrameModel;

@property (nonatomic, weak) id<LifeTopViewDelegate>delegate;
@end
