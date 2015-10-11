//
//  QQSDKTool.h
//  CampusOfGLUT
//
//  Created by HTC on 15/2/27.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface QQSDKTool : NSObject<QQApiInterfaceDelegate>

+ (void)shareToWeiboWithImage:(UIImage *)image title:(NSString *)title description:(NSString *)description;
@end
