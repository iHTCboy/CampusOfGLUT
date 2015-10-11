//
//  FetchNewsDataTool.h
//  CampusOfGLUt
//
//  Created by HTC on 15/2/14.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NewsModel;

typedef void (^fetchNews_block)(NSArray *);

@interface FetchNewsTool: NSObject

@property (nonatomic, copy) fetchNews_block fetchNewsBlock;

+ (instancetype)sharedFetchNewsTool;

- (void)cancelAllOperations;


- (void)getNewsListDataWithClassName:(NSString *)name page:(int)page success:(void (^)(NSArray *fetchNewsArray))success failure:(void (^)(NSError *error))failure;

- (void)getFocusImagesSuccess:(void (^)(NSArray *fetchImagesArray))success failure:(void (^)(NSError *error))failure;

- (void)getContentsWithURL:(NSString *)url success:(void (^)(NewsModel *newsContentsModel))success failure:(void (^)(NSError *error))failure;

@end
