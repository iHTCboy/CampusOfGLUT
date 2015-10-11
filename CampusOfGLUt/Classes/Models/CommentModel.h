//
//  CommentModel.h
//  CampusOfGLUT
//
//  Created by HTC on 15/3/29.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

/** id (用于表示几楼）*/
@property (nonatomic, copy) NSString *ID;
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
@property (nonatomic, copy) NSString *time;
/**
 *  内容
 */
@property (nonatomic, copy) NSString *contents;
/**
 *  来自设备
 */
@property (nonatomic, copy) NSString * comefrom;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)commentModelWithDict:(NSDictionary *)dict;

@end
