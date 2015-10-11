//
//  LifeModel.h
//  CampusOfGLUT
//
//  Created by HTC on 15/3/1.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LifeModel : NSObject
/**
 *  _id
*/
@property (nonatomic,copy) NSString *ID;
/**
 *  头像(字符串或链接）
 */
@property (nonatomic, copy) NSString *icon;
/**
 *  昵称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  时间
 */
@property (nonatomic, copy) NSString *createtime;
/**
 *  原始时间
 */
@property (nonatomic, copy) NSString *time;
/**
 *  内容
 */
@property (nonatomic, copy) NSString *contents;
/**
 *  配图（链接数组）
 */
@property (nonatomic, copy) NSString *images;
/**
 *  来自设备
 */
@property (nonatomic, copy) NSString * comefrom;
/**
 *  位置
 */
@property (nonatomic, copy) NSString *locations;
/**
 *  评论
 */
@property (nonatomic, copy) NSString *commets;
/**
 *  点赞数
 */
@property (nonatomic, copy) NSString *praises;
/**
 *  举报数（超过30次，不在显示）
 */
@property (nonatomic, copy) NSString *reports;

/** 是否点赞（只是当前有效）*/
@property (nonatomic, assign) BOOL isLicked;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)lifeModelWithDict:(NSDictionary *)dict;

@end
