//
//  CRToastTool.h
//  CampusOfGLUT
//
//  Created by HTC on 15/3/2.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CRToastTool : NSObject

+ (void)dismissAllNotifications;

+ (void)showNotificationWithTitle:(NSString *)title backgroundColor:(UIColor *)color completionBlock:(void (^)(void))completion;

+ (void)showNotificationWithTitle:(NSString *)title backgroundColor:(UIColor *)color timeInterval:(NSNumber*)timeInterval completionBlock:(void (^)(void))completion;
@end
