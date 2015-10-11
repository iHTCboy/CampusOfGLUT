//
//  NewsModel.h
//  CampusOfGLUt
//
//  Created by HTC on 15/2/14.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * author;
@property (nonatomic,copy) NSString * clickNum;
@property (nonatomic,copy) NSString * time;
@property (nonatomic,copy) NSString * url;
@property (nonatomic,copy) NSString * source;
@property (nonatomic,copy) NSString * enter_men;
@property (nonatomic,strong) NSArray * images;
@property (nonatomic,copy) NSArray * contents;
@property (nonatomic,copy) NSString * contentHTML;
@property (nonatomic,copy) NSString * imagesHTML;

@end
