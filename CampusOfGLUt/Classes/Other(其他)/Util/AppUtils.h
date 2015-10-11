//
//  AppUtils.h
//  CampusOfGLUt
//
//  Created by HTC on 15/2/12.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#ifndef CampusOfGLUT_AppUtils_h
#define CampusOfGLUT_AppUtils_h

#define kAD_HIGHT 160

//RGBColor(66,156,249)
//RGBColor(16,105,201)
#define kAppMainColor RGBColor(66,156,249)
#define RGBColor(a,b,c) [UIColor colorWithRed:(a)/255.0 green:(b)/255.0 blue:(c)/255.0 alpha:1]

#define kScreenBounds [[UIScreen mainScreen] bounds]
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHight  [[UIScreen mainScreen] bounds].size.height


#ifdef DEBUG // 调试状态, 打开LOG功能
#define TCLog(...) NSLog(__VA_ARGS__)
#else // 发布状态, 关闭LOG功能
#define TCLog(...)
#endif


// 随机色
#define TCRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
// 是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)


//com.sina.weibo.SNWeiboSDKDemo
#define kWeiboKey       @"911173567"
#define kRedirectURI    @"http://www.sina.com"

//WXsdk
#define kWXKey          @"wx426d27e5c19f4421"

//QQsdk
#define QQKey           @"1104292447"



#endif
