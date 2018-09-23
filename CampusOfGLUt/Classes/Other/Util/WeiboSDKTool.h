//
//  WeiboSDKTool.h
//  CampusOfGLUT
//
//  Created by HTC on 15/2/21.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

@interface WeiboSDKTool : NSObject<WeiboSDKDelegate>

+ (void)shareToWeiboWithContent:(NSString *)text image:(UIImage *)image media:(NSDictionary *)dic;

@end
