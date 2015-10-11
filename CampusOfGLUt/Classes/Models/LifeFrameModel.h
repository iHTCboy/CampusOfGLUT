//
//  LifeFrameModel.h
//  CampusOfGLUT
//
//  Created by HTC on 15/3/1.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

// 昵称的字体
#define LifeNameFont [UIFont boldSystemFontOfSize:17]
//时间的字体
#define LifeTimeFont [UIFont systemFontOfSize:13]
// 正文的字体
#define LifeTextFont [UIFont systemFontOfSize:18]
// 来源机型的字体
#define ComeFromFont [UIFont systemFontOfSize:13]

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class LifeModel;

@interface LifeFrameModel : NSObject

/** 顶部的view */
@property (nonatomic, assign, readonly) CGRect topViewF;
/** 头像的frame */
@property (nonatomic, assign, readonly) CGRect iconF;
/** 昵称的fram   */
@property (nonatomic, assign, readonly) CGRect nameF;
/**
 *  时间的frame
 */
@property (nonatomic, assign, readonly) CGRect timeF;
/**
 *  正文的frame
 */
@property (nonatomic, assign, readonly) CGRect textF;
/**
 *  配图的frame
 */
@property (nonatomic, assign, readonly) CGRect pictureF;

/** 来源机型frame  */
@property (nonatomic, assign, readonly) CGRect comefromF;

/** 说说的工具条 */
@property (nonatomic, assign, readonly) CGRect lifeToolbarF;


/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@property (nonatomic, strong) LifeModel *lifeModel;

@end
