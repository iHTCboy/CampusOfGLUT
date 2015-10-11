//
//  CommentFrameModel.h
//  CampusOfGLUT
//
//  Created by HTC on 15/3/29.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

// 昵称的字体
#define NameFont [UIFont boldSystemFontOfSize:17]
//时间的字体
#define TimeFont [UIFont systemFontOfSize:13]
// 正文的字体
#define CommetsFont [UIFont systemFontOfSize:18]
// 来源机型的字体
#define ComeFromFont [UIFont systemFontOfSize:13]
// 楼层的字体
#define StoreyFont [UIFont systemFontOfSize:13]

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class CommentModel;

@interface CommentFrameModel : NSObject


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
@property (nonatomic, assign, readonly) CGRect commetsF;

/** 第几楼 */
@property (nonatomic, assign, readonly) CGRect storeyF;

/** 来源机型frame  */
@property (nonatomic, assign, readonly) CGRect comefromF;


/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@property (nonatomic, strong) CommentModel *commentModel;


@end
