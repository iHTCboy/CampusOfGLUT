//
//  Utility.m
//  CampusOfGLUT
//
//  Created by HTC on 15/3/15.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "Utility.h"

@implementation Utility

#pragma mark - 文件路径相关
+(NSString *)documentPath:(NSString *)filename
{
    NSString *result=nil;
    NSArray *folders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsFolder = [folders objectAtIndex:0];
    result = [documentsFolder stringByAppendingPathComponent:filename];
    return result;
}


+(NSString *)documentPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsDirectory = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return documentsDirectory;
}

#pragma mark - 设备判断
+(BOOL)isIphone5{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone
        && [UIScreen mainScreen].bounds.size.height == 568)
    {
        return YES;
    }
    return NO;
}

#pragma mark - 判断手机型号
+ (NSString *)getCurrentDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    //free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,3"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPod Touch 6G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad mini3";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad mini3";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad mini3";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad mini4";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad mini4";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air2";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air2";
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPad Pro (9.7 inch)";
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPad Pro (9.7 inch)";
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro (12.9 inch)";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro (12.9 inch)";
    
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

+ (NSString *)getCurrentDeviceModelDetail
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    //free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

#pragma mark - 时间相关
static NSDateFormatter *s_format = nil;

+ (NSDateFormatter *)getDateFormatter
{
    if (s_format == nil) {
        s_format = [[NSDateFormatter alloc] init];
        [s_format setDateFormat:@"yyyy-MM-dd"];
    }
    
    return s_format;
}

static NSDateFormatter *s_fullFormat = nil;

+ (NSDateFormatter *)getFullDateFormatter
{
    if (s_fullFormat == nil) {
        s_fullFormat = [[NSDateFormatter alloc] init];
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [s_fullFormat setTimeZone:timeZone];
        [s_fullFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    return s_fullFormat;
}

+(NSString *)getCurrentDate
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+(NSDate *)getCurrentLocalDate{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}

/**
 生成当前时间字符串
 @returns 当前时间字符串
 */
+ (NSString*)getCurrentTimeString
{
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateformat stringFromDate:[NSDate date]];
}


//毫秒转日期
+(NSString *)dateStringFromMstime:(long long)msTime{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:msTime/1000.0];
    NSDateFormatter * df = [self getFullDateFormatter];
    return [df stringFromDate:date];
}

//更新时间
+(NSString *)updateDateStringFromMstime:(long long)msTime{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:msTime/1000.0];
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyy.MM.dd HH:mm"];
    return [dateformat stringFromDate:date];
}

//毫秒转时间
+(NSString *)timeStringFromMstime:(long long)msTime{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:msTime/1000.0];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDateFormatter *df=[[NSDateFormatter  alloc]init];
    [df setTimeZone:timeZone];
    [df setDateFormat:@"HH:mm"];
    return [df stringFromDate:date];
}

+(long long)getMsTimeFromDate:(NSDate *)datetime
{
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    long long totalMilliseconds = interval*1000;
    return totalMilliseconds;
}

+ (NSString *)stringFromMstimeInterval:(NSString *)msInterVal{
    
    
    NSTimeInterval subDate = [msInterVal integerValue]/1000;
    
    NSString *res = nil;
    
    if (subDate / 3600 <= 1) {
        res = [NSString stringWithFormat:@"%f", subDate / 60];
        res = [res substringToIndex:res.length - 7];
        if (subDate < 60) {
            res = [NSString stringWithFormat:NSLocalizedString(@"刚刚", @""), res];
        }
        else{
            res = [NSString stringWithFormat:NSLocalizedString(@"%@分钟前", @""), res];
        }
    }
    else if (subDate / 3600 > 1 && subDate / 86400 <= 1) {
        res = [NSString stringWithFormat:@"%f", subDate / 3600];
        res = [res substringToIndex:res.length - 7];
        res = [NSString stringWithFormat:NSLocalizedString(@"%@小时前", @""), res];
    }
    else if (subDate / 86400 > 1) {
        res = [NSString stringWithFormat:@"%f", subDate / 86400];
        res = [res substringToIndex:res.length - 7];
        res = [NSString stringWithFormat:NSLocalizedString(@"%@天前", @""), res];
    }
    
    return [res length] ? res : @" ";
}


#pragma mark - 计算theBeforeDate到theLaterDate的时间间隔
+ (NSString *)intervalSinceTime:(NSDate *)theBeforeDate andTime:(NSDate *)theLaterDate {
    
    if (theBeforeDate == nil || theLaterDate == nil) {
        return @"";
    }
    
    NSDateFormatter * dateFormatter_ymd = [[NSDateFormatter alloc]init];
    [dateFormatter_ymd setDateFormat:@"yyyy-MM-dd"];
    
    NSString * ymdOfBeforeDate = [dateFormatter_ymd stringFromDate:theBeforeDate];
    NSString * ymdOfLaterDate = [dateFormatter_ymd stringFromDate:theLaterDate];
    NSTimeInterval beforeDate = [theBeforeDate timeIntervalSince1970];
    NSTimeInterval laterDate = [theLaterDate timeIntervalSince1970];
    
    NSString *res = nil;
    
    if ([ymdOfBeforeDate isEqualToString:ymdOfLaterDate] && (laterDate>beforeDate)) {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"HH:mm"];
        res = [dateFormatter stringFromDate:theBeforeDate];
    }else{
        res = [self getWeekFromDate:theBeforeDate];//根据日期获取星期几
    }
    
    
    
    return [res length] ? res : @" ";
}


#pragma mark - 根据日期得到是星期几
+(NSString *)getWeekFromDate:(NSDate *)tDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:tDate];
    NSInteger week = [comps weekday];
    NSString * strWeek = @"";
    switch (week) {
        case 1:
            strWeek = @"星期日";
            break;
        case 2:
            strWeek = @"星期一";
            break;
        case 3:
            strWeek = @"星期二";
            break;
        case 4:
            strWeek = @"星期三";
            break;
        case 5:
            strWeek = @"星期四";
            break;
        case 6:
            strWeek = @"星期五";
            break;
        case 7:
            strWeek = @"星期六";
            break;
        default:
            break;
    }
    
    return strWeek;
}

+ (NSString*)getTimeStr:(long) createdAt
{
    // Calculate distance time string
    //
    NSString *timestamp;
    time_t now;
    time(&now);
    
    int distance = (int)difftime(now, createdAt);
    if (distance < 0) distance = 0;
    
    if (distance < 60) {
        timestamp = [NSString stringWithFormat:@"%d %s", distance, (distance == 1) ? "second ago" : "seconds ago"];
    }
    else if (distance < 60 * 60) {
        distance = distance / 60;
        timestamp = [NSString stringWithFormat:@"%d %s", distance, (distance == 1) ? "minute ago" : "minutes ago"];
    }
    else if (distance < 60 * 60 * 24) {
        distance = distance / 60 / 60;
        timestamp = [NSString stringWithFormat:@"%d %s", distance, (distance == 1) ? "hour ago" : "hours ago"];
    }
    else if (distance < 60 * 60 * 24 * 7) {
        distance = distance / 60 / 60 / 24;
        timestamp = [NSString stringWithFormat:@"%d %s", distance, (distance == 1) ? "day ago" : "days ago"];
    }
    else if (distance < 60 * 60 * 24 * 7 * 4) {
        distance = distance / 60 / 60 / 24 / 7;
        timestamp = [NSString stringWithFormat:@"%d %s", distance, (distance == 1) ? "week ago" : "weeks ago"];
    }
    else {
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdAt];
        timestamp = [dateFormatter stringFromDate:date];
    }
    return timestamp;
}

+(NSDateComponents*) getComponent:(long long)time
{
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth | NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    return component;
}



+(NSString*) getTimeStrStyle1:(long long)time
{
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth | NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    
    NSInteger year=[component year];
    NSInteger month=[component month];
    NSInteger day=[component day];
    
    NSDate * today=[NSDate date];
    component=[calendar components:unitFlags fromDate:today];
    
    NSInteger t_year=[component year];
    
    NSString*string=nil;
    
    long long now=[today timeIntervalSince1970];
    
    long distance=now-time;
    if(distance<60)
        string=@"刚刚";
    else if(distance<60*60)
        string=[NSString stringWithFormat:@"%ld 分钟前",distance/60];
    else if(distance<60*60*24)
        string=[NSString stringWithFormat:@"%ld 小时前",distance/60/60];
    else if(distance<60*60*24*7)
        string=[NSString stringWithFormat:@"%ld 天前",distance/60/60/24];
    else if(year==t_year)
        string=[NSString stringWithFormat:@"%ld月%ld日",month,day];
    else
        string=[NSString stringWithFormat:@"%ld年%ld月%ld日",year,month,day];
    
    return string;
    
}
+(NSString*) getTimeStrStyle2:(long long)time
{
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth | NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    
    NSInteger year=[component year];
    NSInteger month=[component month];
    NSInteger day=[component day];
    NSInteger hour=[component hour];
    NSInteger minute=[component minute];
    NSInteger week=[component weekOfMonth];
    NSInteger weekday=[component weekday];
    
    NSDate * today=[NSDate date];
    component=[calendar components:unitFlags fromDate:today];
    
    NSInteger t_year=[component year];
    NSInteger t_month=[component month];
    NSInteger t_day=[component day];
    NSInteger t_week=[component weekOfMonth];//weekOfYear
    
    NSString*string=nil;
    if(year==t_year&&month==t_month&&day==t_day)
    {
        if(hour<6&&hour>=0)
            string=[NSString stringWithFormat:@"凌晨 %ld:%02ld",hour,minute];
        else if(hour>=6&&hour<12)
            string=[NSString stringWithFormat:@"上午 %ld:%02ld",hour,minute];
        else if(hour>=12&&hour<18)
            string=[NSString stringWithFormat:@"下午 %ld:%02ld",hour,minute];
        else
            string=[NSString stringWithFormat:@"晚上 %ld:%02ld",hour,minute];
    }
    else if(year==t_year&&week==t_week)
    {
        NSString * daystr=nil;
        switch (weekday) {
            case 1:
                daystr=@"日";
                break;
            case 2:
                daystr=@"一";
                break;
            case 3:
                daystr=@"二";
                break;
            case 4:
                daystr=@"三";
                break;
            case 5:
                daystr=@"四";
                break;
            case 6:
                daystr=@"五";
                break;
            case 7:
                daystr=@"六";
                break;
            default:
                break;
        }
        string=[NSString stringWithFormat:@"周%@ %ld:%02ld",daystr,hour,minute];
    }
    else if(year==t_year)
        string=[NSString stringWithFormat:@"%ld-%ld %ld:%02ld",month,day,hour,minute];
    else
        string=[NSString stringWithFormat:@"%ld-%ld-%ld %ld:%02ld",year,month,day,hour,minute];
    
    return string;
}


#pragma mark - 网络相关
+ (BOOL)connectedToNetwork{
    
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    
    struct sockaddr_storage zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return NO;
    }
    //根据获得的连接标志进行判断
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable&&!needsConnection) ? YES : NO;
}

//
//+(BOOL)isConnectedToNetwork{
//    BOOL isReachable = NO;
//    Reachability *r = [Reachability reachabilityWithHostname:@"www.baidu.com"];
//    switch ([r currentReachabilityStatus]) {
//        case NotReachable:
//            // 没有网络连接
//            break;
//        case ReachableViaWWAN:
//            // 使用3G网络
//            isReachable = YES;
//            break;
//        case ReachableViaWiFi:
//            // 使用WiFi网络
//            isReachable = YES;
//            break;
//    }
//    return isReachable;
//}

//// 是否wifi
//+ (BOOL) IsEnableWIFI {
//    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
//}
//
//// 是否3G
//+ (BOOL) IsEnable3G {
//    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
//}

// Direct from Apple. Thank you Apple
+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address
{
    if (!IPAddress || ![IPAddress length]) return NO;
    
    memset((char *) address, sizeof(struct sockaddr_in), 0);
    address->sin_family = AF_INET;
    address->sin_len = sizeof(struct sockaddr_in);
    
    int conversionResult = inet_aton([IPAddress UTF8String], &address->sin_addr);
    if (conversionResult == 0) {
        NSAssert1(conversionResult != 1, @"Failed to convert the IP address string into a sockaddr_in: %@", IPAddress);
        return NO;
    }
    
    return YES;
}

+ (NSString *) getIPAddressForHost: (NSString *) theHost
{
    theHost=[theHost substringFromIndex:7];
    //NSLog(@"%@",theHost);
    struct hostent *host = gethostbyname([theHost UTF8String]);
    if (!host) {herror("resolv"); return NULL; }
    struct in_addr **list = (struct in_addr **)host->h_addr_list;
    NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
    return addressString;
}


+ (BOOL) hostAvailable: (NSString *) theHost
{
    
    NSString *addressString = [self getIPAddressForHost:theHost];
    if (!addressString)
    {
        printf("Error recovering IP address from host name\n");
        return NO;
    }
    
    struct sockaddr_in address;
    BOOL gotAddress = [self addressFromString:addressString address:&address];
    
    if (!gotAddress)
    {
        printf("Error recovering sockaddr address from %s\n", [addressString UTF8String]);
        return NO;
    }
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&address);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags =SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    return isReachable ? YES : NO;;
}


#pragma mark - 信息验证
//通过区分字符串
+(BOOL)validateEmail:(NSString*)email
{
    if((0 != [email rangeOfString:@"@"].length) &&
       (0 != [email rangeOfString:@"."].length))
    {
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        NSMutableCharacterSet* tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy];
        [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        
        
        NSRange range1 = [email rangeOfString:@"@"
                                      options:NSCaseInsensitiveSearch];
        
        //取得用户名部分
        NSString* userNameString = [email substringToIndex:range1.location];
        NSArray* userNameArray   = [userNameString componentsSeparatedByString:@"."];
        
        for(NSString* string in userNameArray)
        {
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])
                return NO;
        }
        
        //取得域名部分
        NSString *domainString = [email substringFromIndex:range1.location+1];
        NSArray *domainArray   = [domainString componentsSeparatedByString:@"."];
        
        for(NSString *string in domainArray)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        
        return YES;
    }
    else {
        return NO;
    }
}

//利用正则表达式验证
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL)isValidateString:(NSString *)myString
{
    NSCharacterSet *nameCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
    NSRange userNameRange = [myString rangeOfCharacterFromSet:nameCharacters];
    if (userNameRange.location != NSNotFound) {
        //NSLog(@"包含特殊字符");
        return FALSE;
    }else{
        return TRUE;
    }
    
}

+(BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}


#pragma mark - 图片操作相关
/**
 *@brief 图片分割函数
 *
 *@param image:原始图片
 *@param x:需切割成的行数（最小为１）
 *@param y:需切割成的列数（最小为１）
 *@param quality:处理后保存的小图片的质量，（0，1］有效，小于0会被强制为0，大于1时会被强强制为1
 *
 *@return NSArray*：返回包含图片本地全路径的数组
 */
+(NSArray*)SeparateImage:(UIImage*)image ByX:(int)x andY:(int)y cacheQuality:(float)quality
{
    
    //参数错误过滤
    if (x<1) {
        NSLog(@"非法的 x!");
        return nil;
    }else if (y<1) {
        NSLog(@"非法的 y!");
        return nil;
    }
    quality = (quality<0)?0:quality;
    quality=(quality>1)?1:quality;
    if (![image isKindOfClass:[UIImage class]]) {
        NSLog(@"illegal image format!");
        return nil;
    }
    
    //按设置的行列数计算切分度
    float _xstep=image.size.width*1.0/y;
    float _ystep=image.size.height*1.0/x;
    
    NSMutableArray *_mutableArray=[[NSMutableArray alloc]initWithCapacity:1];
    NSString*prefixName=@"imageSlice";
    
    //图片切割并持久化
    for (int i=0; i<x; i++)
    {
        for (int j=0; j<y; j++)
        {
            
            CGRect rect=CGRectMake(_xstep*j, _ystep*i, _xstep, _ystep);
            CGImageRef imageRef=CGImageCreateWithImageInRect([image CGImage],rect);
            UIImage* elementImage=[UIImage imageWithCGImage:imageRef];
            
            //UIImageView*_imageView=[[UIImageView alloc] initWithImage:elementImage];
            //_imageView.frame=rect;
            
            //小图储存到本地
            NSString*_imageString=[NSString stringWithFormat:@"%@_%d_%d.jpg",prefixName,i,j];
            NSString*_imagePath=[NSTemporaryDirectory() stringByAppendingPathComponent:_imageString];
            NSData* _imageData=UIImageJPEGRepresentation(elementImage, quality);
            [_imageData writeToFile:_imagePath atomically:NO];
            
            //记录路径
            [_mutableArray addObject:_imagePath];
        }
    }
    
    //返回图片路径数组
    NSArray*_retArray=_mutableArray;
    return _retArray;
}

#pragma mark - chat image save path
//+(NSString *)chatLogImgPathWithUid:(NSString *)uid{
//    NSString *realImgPath = [[self documentPath]stringByAppendingFormat:@"/%@%@",uid,MDJ_CHARTLOGS_IMG_PATH];
//    return realImgPath;
//}
//
//+(NSString *)chatlogImgNameWithUid:(NSString *)uid{
//    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
//    NSString *curDate = [dateFormatter stringFromDate:[NSDate date]];
//    
//    NSString *imgName = [self md5HexDigest:[NSString stringWithFormat:@"%@%@",uid,curDate]];
//    NSString *realImgName = [imgName stringByAppendingString:@".png"];
//    return realImgName;
//}



#pragma mark - 获取用户头像
/*
 +(UIImage *)getUserAvatarWithUserAuthInfo:(WWUserAuth *)userAuthInfo{
 UIImage * avatarImage = nil;
 NSFileManager * fm  = [[NSFileManager alloc]init];
 if (userAuthInfo.auth_avatar && [fm fileExistsAtPath:userAuthInfo.auth_avatar]) {
 avatarImage = [UIImage imageWithContentsOfFile:userAuthInfo.auth_avatar];
 }else{
 NSString * imageName = (userAuthInfo.auth_sex == 0?@"avatar_default_female":@"avatar_default_male");
 avatarImage = [UIImage imageNamed:imageName];
 }
 
 return avatarImage;
 }*/

#pragma mark - save image to document path
+(BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath
{
    if ((image == nil) || (aPath == nil) || ([aPath isEqualToString:@""]))
        return NO;
    @try
    {
        
        NSData *imageData = nil;
        NSString *ext = [aPath pathExtension];
        if ([ext isEqualToString:@"png"])
        {
            imageData = UIImagePNGRepresentation(image);
        }
        else
        {
            // the rest, we write to jpeg
            
            // 0. best, 1. lost. about compress.
            
            imageData = UIImageJPEGRepresentation(image, 0);
            
        }
        
        if ((imageData == nil) || ([imageData length] <= 0))
            return NO;
        
        [imageData writeToFile:aPath atomically:YES];
        return YES;
    }
    @catch (NSException *e)
    {
        NSLog(@"create thumbnail exception.");
    }
    return NO;
}

+(BOOL)writeImagetoFilePath:(NSString *)filePath andImageName:(NSString *)imageName andImage:(UIImage *)image{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString  *imagefilepath = filePath;
    
    if ((image == nil) || (filePath == nil) || ([filePath isEqualToString:@""]))
        return NO;
    
    if([fm fileExistsAtPath:imagefilepath] == false)//如果目录不存在，先创建
    {
        [fm createDirectoryAtPath:imagefilepath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    NSError * error = nil;
    NSData *imageData = nil;
    NSString *ext = [imageName pathExtension];
    if ([ext isEqualToString:@"png"])
    {
        imageData = UIImagePNGRepresentation(image);
    }
    else
    {
        // the rest, we write to jpeg
        
        // 0. best, 1. lost. about compress.
        
        imageData = UIImageJPEGRepresentation(image, 0);
        
    }
    
    if ((imageData == nil) || ([imageData length] <= 0))
        return NO;
    
    //NSLog(@"full path:%@",[imagefilepath stringByAppendingPathComponent:imageName]);
    [imageData writeToFile:[imagefilepath stringByAppendingPathComponent:imageName] options:NSDataWritingAtomic error:&error];//写入数据
    //return YES;
    
    
    //[imagedata writeToFile:[imagefilepath stringByAppendingPathComponent:imagename] atomically:YES];
    if (error) {
        NSLog(@"%@",[error description]);
        return NO;
    }else{
        return YES;
    }
}

+(BOOL)deleteFileAtPath:(NSString *)filePath{
    
    NSError *error = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:filePath error:&error];
    if (error) {
        NSLog(@"%@",[error description]);
        return NO;
    }else{
        return YES;
    }
}

+(BOOL)writeFileToPath:(NSString *)filePath andFileName:(NSString *)fileName andFileData:(NSData *)fileData{
    
    if (fileData == nil) {
        return NO;
    }
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    debugLog(@"filePath %@",filePath);
    NSError * error = nil;
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    NSString * fileFullPath = [filePath stringByAppendingPathComponent:fileName];
    debugLog(@"fileFullPath:%@",fileFullPath);
    if (error) {
        debugLog(@"create path error:%@",[error description]);
        return NO;
    }else{
        error = nil;
        [fileData writeToFile:fileFullPath options:NSDataWritingAtomic error:&error];
        if (error) {
            debugLog(@"write file error:%@",[error description]);
            return NO;
        }else{
            debugLog(@"succ write date to text.txt");
        }
    }
    
    return YES;
}

+(NSString *)calculateAgeByBirthday:(NSString *)birthday{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *destDate= [dateFormatter dateFromString:birthday];
    
    
    NSTimeInterval dateDiff = [destDate timeIntervalSinceNow];
    
    
    NSString * age =  [NSString stringWithFormat:@"%d",abs((int)dateDiff/(60*60*24)/365)];
    return age;
    
}

#pragma mark -　Message Records Method
////与某人的消息资源路径
//+ (NSString *)messageLocalResourcePathWithToUid:(NSInteger)toUid{
//    NSInteger MyUid = [[[NSUserDefaults standardUserDefaults]objectForKey:USERID]integerValue];
//    NSString * pathStr = [NSString stringWithFormat:@"%d/chatlog/%d/",MyUid,toUid];
//    NSString * retPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:pathStr];
//    
//    //路径不存在，则创建
//    if (![[NSFileManager defaultManager] fileExistsAtPath:retPath]) {
//        [[NSFileManager defaultManager] createDirectoryAtPath:retPath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    
//    return retPath;
//}

////消息资源路径
//+(NSString *)messageLocalPath{
//    NSInteger MyUid = [[[NSUserDefaults standardUserDefaults]objectForKey:USERID]integerValue];
//    NSString * pathStr = [NSString stringWithFormat:@"%d/chatlog/",MyUid];
//    NSString * retPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:pathStr];
//    return retPath;
//}

#pragma mark - 头像存放路径
+(NSString *)avatarImagesPath{
    NSString * retPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"avatarImages/"];
    return retPath;
}

//+(NSString *)imageAbsoluteUrlFormString:(NSString *)relativeUrlStr{
//    if (relativeUrlStr==nil) {
//        return nil;
//    }
//    NSString * absoluteUrlStr = [NSString stringWithFormat:@"%@%@",LZ_IMAGE_PATH,relativeUrlStr];
//    absoluteUrlStr = [absoluteUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//utf-8转码，处理中文问题
//    return absoluteUrlStr;
//}

+(NSString *)thumbImageAbsoluteUrlFormString:(NSString *)relativeUrlStr{
    NSString * retString = [self imageAbsoluteUrlFormString:relativeUrlStr];
    if (retString.length >0) {
        return [retString stringByAppendingString:@"@0e_120w_120h_0c_1i_0o_90Q_1x.jpg"];
    }
    return nil;
}


#pragma mark - 占位图片
+ (UIImage *)placeHolderImage80x80{
    UIImage * placeholderimg = LOADIMAGE(@"placeholder_image_80x80", @"png");
    return placeholderimg;
}

//首页广告图片路径
+ (NSString *)mainPageAdImagePath{
    return [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"MainPageAdImage.png"];
}

#pragma mark - Label内容自适应
//计算适应内容的label frame
+(CGRect)autoSizeLabelFrameWithMaxWidth:(float)maxWidth andMaxHeight:(float)maxHeight andContentString:(NSString *)contentString andLabelObj:(UILabel *)label{
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
    CGSize expectedLabelSize = [self getTextWidthWithWraperMaxWidth:maxWidth andMaxHeight:maxHeight andContentString:contentString andWraperFont:label.font andWraperLineBreakMode:label.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect newFrame = label.frame;
    newFrame.size.height = expectedLabelSize.height;
    newFrame.size.width = expectedLabelSize.width;
    return newFrame;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
+(CGSize)getTextWidthWithWraperMaxWidth:(float)maxWidth andMaxHeight:(float)maxHeight andContentString:(NSString *)contentString andWraperFont:(UIFont *)font andWraperLineBreakMode:(NSLineBreakMode)lineBreakMode{
#else
+(CGSize)getTextWidthWithWraperMaxWidth:(float)maxWidth andMaxHeight:(float)maxHeight andContentString:(NSString *)contentString andWraperFont:(UIFont *)font andWraperLineBreakMode:(UILineBreakMode)lineBreakMode{
#endif
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
    CGSize maximumLabelSize = CGSizeMake(maxWidth, maxHeight);
    CGSize expectedLabelSize = [contentString sizeWithFont:font constrainedToSize:maximumLabelSize lineBreakMode:lineBreakMode];
    return CGSizeMake(expectedLabelSize.width, expectedLabelSize.height);
}

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];  
}
    
#pragma mark - GPS相关
+(BOOL)isLocationInGuilin:(CLLocationCoordinate2D)coordinate{
    /*
     桂林市区
     1：110.0746473　25.45071　　　2：110.3747533　25.45071
     3：110.0746473　25.137095　　 4：110.3747533　25.137095
     */
    
    if (coordinate.longitude>=110.0746473 &&
        coordinate.longitude<= 110.3747533 &&
        coordinate.latitude >= 25.137095 &&
        coordinate.latitude <= 25.45071) {
        
        return YES;
    }else{
        return NO;
    }
}


@end
