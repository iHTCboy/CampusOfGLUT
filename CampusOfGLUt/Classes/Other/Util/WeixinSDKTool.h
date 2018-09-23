//
//  WeixinSDKTool.h
//  CampusOfGLUT
//
//  Created by HTC on 15/2/21.
//  Copyright (c) 2015年 HTC. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"

@interface WeixinSDKTool : NSObject<WXApiDelegate>

typedef NS_ENUM(NSInteger, WXSceneType) {
    
    WXSceneTypeSession  = 0,        /**< 聊天界面    */
    WXSceneTypeTimeline = 1,        /**< 朋友圈      */
    WXSceneTypeFavorite = 2,        /**< 收藏       */
};

+ (void) sendImageContent:(UIImage *)image scene:(WXSceneType)scene;
@end
