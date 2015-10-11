//
//  NewsCacheTool.h
//  CampusOfGLUt
//
//  Created by HTC on 15/2/16.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NewsModel;

@interface NewsCacheTool : NSObject

+ (NSInteger)currentExecuteCounts;

+ (NSArray *)queryWithNumber:(NSInteger)number;
+ (NewsModel *)queryWithURL:(NSString *)url;



+ (void)insertOldItems:(NSArray *)items;
+ (void)insertNewItems:(NSArray *)items;



+ (NSInteger)updateNewItems:(NSArray *)items;

@end
