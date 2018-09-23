//
//  FetchLifeCircleTool.h
//  CampusOfGLUT
//
//  Created by HTC on 15/2/28.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#import "LifeModel.h"

@interface FetchLifeCircleTool : NSObject

+ (instancetype)sharedFetchNewsTool;

/**
 *  取消全部操作
 */
- (void)cancelAllOperations;

/**
 *  通过ID搜索条目
 */
- (void)fetchTalkOfLifeCircleWithTableID:(NSString *)tableId ID:(NSString *)ID success:(void (^)(NSArray *fetchArray))success failure:(void (^)(NSError *error))failure;

/**
 *  获取最新条目
 */
- (void)fetchNewLifeCircleWithTableID:(NSString *)tableId success:(void (^)(NSArray *fetchArray))success failure:(void (^)(NSError *error))failure;


/**
 *  搜索某ID范围条目
 */
- (void)fetchTalkOfLifeCircleWithTableID:(NSString *)tableId endID:(NSInteger)eID range:(NSInteger)range  success:(void (^)(NSArray *fetchArray))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一条说说
 *
 *  @param tableId  表ID
 *  @param icon     头像
 *  @param name     昵称
 *  @param contents 说说内容
 *  @param images   图片
 *  @param imageURL 图片链接
 *  @param commets  评论
 *  @param comefrom 来自机型
 *  @param praises  点赞数
 *  @param reports  举报数
 *  @param success  成功回调
 *  @param failure  失败回调
 */
- (void)sendTextToLifeCircleWithTableID:(NSString *)tableId icon:(NSString *)icon name:(NSString *)name contents:(NSString *)contents images:(UIImage *)images imageURL:(NSString *)imageUrl  commets:(NSString *)commets comefrom:(NSString *)comefrom praises:(NSString *)praises reports:(NSString *)reports success:(void (^)(NSArray *fetchArray))success failure:(void (^)(NSError *error))failure;



- (void)sendImages:(UIImage *)image success:(void (^)(NSDictionary *dic))success failure:(void (^)(NSError *error))failure;
/**
 *  更新说说的点赞数
 *
 *  @param tableID 表ID
 *  @param ids     说说id
 *  @param praises 最新点赞数
 *  @param success  成功回调
 *  @param failure  失败回调
 */
- (void)updataPraisesWithTableID:(NSString *)tableId IDs:(NSString *)ids newPraises:(NSString *)praises success:(void (^)(NSArray *fetchArray))success failure:(void (^)(NSError *error))failure;


/**
 *  更新说说的举报数
 *
 *  @param tableID 表ID
 *  @param ids     说说id
 *  @param reports 最新举报数（大于5 不在发送）
 *  @param success  成功回调
 *  @param failure  失败回调
 */
- (void)updataReportsWithTableID:(NSString *)tableId IDs:(NSString *)ids newReports:(NSString *)reports success:(void (^)(NSArray *fetchArray))success failure:(void (^)(NSError *error))failure;


/**
 *  更新评论
 *
 *  @param tableId  表ID
 *  @param icon     头像
 *  @param name     昵称
 *  @param contents 评论内容
 *  @param comefrom 来自机型
 *  @param lifeModel  旧评论
 *  @param success  成功回调
 *  @param failure  失败回调
 */
- (void)sendCommentToLifeCircleWithTableID:(NSString *)tableId icon:(NSString *)icon name:(NSString *)name contents:(NSString *)contents comefrom:(NSString *)comefrom lifeModel:(LifeModel *)lifeModel success:(void (^)(NSArray *fetchArray))success failure:(void (^)(NSError *error))failure;

- (void)test;

@end
