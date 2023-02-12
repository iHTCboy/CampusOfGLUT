//
//  NewsModel.h
//  CampusOfGLUt
//
//  Created by HTC on 15/2/14.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

@property (nonatomic,copy) NSString * title;//标题
@property (nonatomic,copy) NSString * author;//作者
@property (nonatomic,copy) NSString * clickNum;//点击数
@property (nonatomic,copy) NSString * time;//时间
@property (nonatomic,copy) NSString * url;//链接
@property (nonatomic,copy) NSString * source;//来源
@property (nonatomic,copy) NSString * enter_men;//录入人
@property (nonatomic,strong) NSArray * images;//图片集
@property (nonatomic,copy) NSArray * contents;//内容集
@property (nonatomic,copy) NSString * contentHTML;//html格式内容
@property (nonatomic,copy) NSString * imagesHTML;//html图片

@end
