//
//  Utility.h
//  CampusOfGLUT
//
//  Created by HTC on 15/3/15.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "sys/utsname.h"
#import <CommonCrypto/CommonHMAC.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import <arpa/inet.h>
#import <CoreLocation/CoreLocation.h>




//主色   RGB(66,156,249)

#define kMianColor RGBCOLOR(66,156,249)

//常用定义
#define PI 3.1415926


//appStore地址
#define kAppUrl  @"http://itunes.apple.com/app/id923676989"
#define kAppReviewURL   @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=923676989"

//版本号
#define kVersion_Coding [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define kVersionBuild_Coding [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

//常用变量
#define DebugLog(s, ...) NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#define kTipAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]

#define kKeyWindow [UIApplication sharedApplication].keyWindow

#define kHigher_iOS_6_1 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
#define kHigher_iOS_6_1_DIS(_X_) ([[NSNumber numberWithBool:kHigher_iOS_6_1] intValue] * _X_)
#define kNotHigher_iOS_6_1_DIS(_X_) (-([[NSNumber numberWithBool:kHigher_iOS_6_1] intValue]-1) * _X_)

#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define kScreen_Bounds [UIScreen mainScreen].bounds
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kPaddingLeftWidth 15.0
#define kMySegmentControl_Height 44.0
#define kMySegmentControlIcon_Height 70.0

#define  kBackButtonFontSize 16
#define  kNavTitleFontSize 19
#define  kBadgeTipStr @"badgeTip"

#define kDefaultLastId [NSNumber numberWithInteger:99999999]

#define kColor999 [UIColor colorWithHexString:@"0x999999"]
#define kColorTableBG [UIColor colorWithHexString:@"0xfafafa"]
#define kColorTableSectionBg [UIColor colorWithHexString:@"0xe5e5e5"]

#define kImage999 [UIImage imageWithColor:kColor999]

#define kPlaceholderMonkeyRoundWidth(_width_) [UIImage imageNamed:[NSString stringWithFormat:@"placeholder_monkey_round_%.0f", _width_]]
#define kPlaceholderMonkeyRoundView(_view_) [UIImage imageNamed:[NSString stringWithFormat:@"placeholder_monkey_round_%.0f", CGRectGetWidth(_view_.frame)]]

#define kPlaceholderCodingSquareWidth(_width_) [UIImage imageNamed:[NSString stringWithFormat:@"placeholder_coding_square_%.0f", _width_]]
#define kPlaceholderCodingSquareView(_view_) [UIImage imageNamed:[NSString stringWithFormat:@"placeholder_coding_square_%.0f", CGRectGetWidth(_view_.frame)]]

#define kUnReadKey_messages @"messages"
#define kUnReadKey_notifications @"notifications"
#define kUnReadKey_project_update_count @"project_update_count"
#define kUnReadKey_notification_AT @"notification_at"
#define kUnReadKey_notification_Comment @"notification_comment"
#define kUnReadKey_notification_System @"notification_system"

//链接颜色
#define kLinkAttributes     @{(__bridge NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:NO],(NSString *)kCTForegroundColorAttributeName : (__bridge id)[UIColor colorWithHexString:@"0x3bbd79"].CGColor}
#define kLinkAttributesActive       @{(NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:NO],(NSString *)kCTForegroundColorAttributeName : (__bridge id)[[UIColor colorWithHexString:@"0x1b9d59"] CGColor]}

//Debug
#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define debugLog(...)
#define debugMethod()
#endif



//-------------------字符串与路径-------------------------
#define EMPTY_STRING        @""
#define SAFE_STRING(str) ([(str) length] ? (str) : @"")
#define SAFE_NUMBERSTR(str) ([(str) length] ? (str) : @"0")
#define STR(key)            NSLocalizedString(key, nil)

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
//-------------------字符串与路径-------------------------



//-------------------获取UI大小-------------------------
#define UI_NAVIGATION_BAR_HEIGHT    44
#define UI_TAB_BAR_HEIGHT           49
#define UI_STATUS_BAR_HEIGHT        20
#define UI_SCREEN_WIDTH             ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT            ([[UIScreen mainScreen] bounds].size.height)
#define MAINSTORYBOARD              [UIStoryboard storyboardWithName:@"Main" bundle:nil]

//-------------------获取UI大小-------------------------


//----------------------系统----------------------------

//获取系统版本
//e.g. @"4.0"
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//系统版本// e.g. @"4.0"
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

//设备名称e.g. "My iPhone"
#define DeviceName [UIDevice currentDevice].name;

//设备型号 e.g. @"iPhone", @"iPod touch" 无法得到是第几代设备
#define DeviceModel [UIDevice currentDevice].model;

//系统名称，e.g. @"iOS"
#define DevieceSystemName [UIDevice currentDevice].systemName;

//判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//判断是否为iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断是否为ipod
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

//判断是否为iPhone5
#define IS_IPHONE_5_SCREEN [[UIScreen mainScreen] bounds].size.height >= 568.0f && [[UIScreen ma

//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//判断是否 Retina屏、设备是否%fhone 5、是否是iPad
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
#define IOS7_SDK_AVAILABLE 1
#endif

/*
 Usage sample:
 
 if (SYSTEM_VERSION_LESS_THAN(@"4.0")) {
 ...
 }
 
 if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"3.1.1")) {
 ...
 }
 
 */

//----------------------系统----------------------------


//----------------------图片----------------------------

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]

//建议使用前两种宏定义,性能高于后者
//----------------------图片----------------------------


//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//清除背景色
#define CLEARCOLOR [UIColor clearColor]

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//橙色
#define LZORANGECOLOR [UIColor colorWithRed:(236)/255.0f green:(125)/255.0f blue:(68)/255.0f alpha:1]
//----------------------颜色类--------------------------


@interface Utility : NSObject

#pragma mark - 文件路径相关
+(NSString *)documentPath:(NSString *)filename;
+(NSString *)documentPath;

#pragma mark - 设备判断
+(BOOL)isIphone5;

#pragma mark - 判断手机型号
+ (NSString *)deviceModelName;

#pragma mark - 时间相关
+ (NSDateFormatter *)getDateFormatter;
+ (NSDateFormatter *)getFullDateFormatter;
+(NSString *)dateStringFromMstime:(long long)msTime;
+(NSString *)updateDateStringFromMstime:(long long)msTime;
+(NSString *)timeStringFromMstime:(long long)msTime;
+(long long)getMsTimeFromDate:(NSDate *)datetime;
+ (NSString *)stringFromMstimeInterval:(NSString *)msInterVal;
+ (NSString *)intervalSinceTime:(NSDate *)theBeforeDate andTime:(NSDate *)theLaterDate;
+(NSString *)getWeekFromDate:(NSDate *)tDate;
+(NSDate *)getCurrentLocalDate;
+(NSString *)getCurrentDate;
+ (NSString*)getCurrentTimeString;
+(NSString *)calculateAgeByBirthday:(NSString *)birthday;

+ (NSString*)getTimeStr:(long) createdAt;
+(NSDateComponents*) getComponent:(long long)time;
+(NSString*) getTimeStrStyle1:(long long)time;
+(NSString*) getTimeStrStyle2:(long long)time;


#pragma mark - 网络相关
//导入SystemConfiguration.framework,并#import<SystemConfiguration/SCNetworkReachability.h
+(BOOL) connectedToNetwork;
+(BOOL) hostAvailable: (NSString *) theHost;


#pragma mark - 信息验证
+(BOOL)isValidateEmail:(NSString *)email;
+(BOOL)validateEmail:(NSString*)email;
+(BOOL)isValidateString:(NSString *)myString;
+(BOOL)isValidateMobile:(NSString *)mobile;

#pragma mark - 图片操作相关
//图片分割
+(NSArray*)SeparateImage:(UIImage*)image ByX:(int)x andY:(int)y cacheQuality:(float)quality;
+(BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath;
+(BOOL)writeImagetoFilePath:(NSString *)filePath andImageName:(NSString *)imageName andImage:(UIImage *)image;
+(BOOL)writeFileToPath:(NSString *)filePath andFileName:(NSString *)fileName andFileData:(NSData *)fileData;

+(BOOL)deleteFileAtPath:(NSString *)filePath;


//占位图片
+ (UIImage *)placeHolderImage80x80;

//首页广告图片路径
+ (NSString *)mainPageAdImagePath;

#pragma mark - Label内容自适应
+(CGRect)autoSizeLabelFrameWithMaxWidth:(float)maxWidth andMaxHeight:(float)maxHeight andContentString:(NSString *)contentString andLabelObj:(UILabel *)label;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
+(CGSize)getTextWidthWithWraperMaxWidth:(float)maxWidth andMaxHeight:(float)maxHeight andContentString:(NSString *)contentString andWraperFont:(UIFont *)font andWraperLineBreakMode:(NSLineBreakMode)lineBreakMode;
#else
+(CGSize)getTextWidthWithWraperMaxWidth:(float)maxWidth andMaxHeight:(float)maxHeight andContentString:(NSString *)contentString andWraperFont:(UIFont *)font andWraperLineBreakMode:(UILineBreakMode)lineBreakMode;
#endif

#pragma mark - 颜色相关
+ (UIColor *) colorWithHexString: (NSString *)color;

#pragma mark - GPS相关
+(BOOL)isLocationInGuilin:(CLLocationCoordinate2D)coordinate;

@end
