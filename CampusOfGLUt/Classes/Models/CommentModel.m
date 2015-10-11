//
//  CommentModel.m
//  CampusOfGLUT
//
//  Created by HTC on 15/3/29.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "CommentModel.h"
#import "NSDate+TC.h"


@implementation CommentModel

- (instancetype)initWithDict:(NSDictionary *)dic
{
    if (self = [super init]) {
        //[self setValuesForKeysWithDictionary:dict];
        _ID = [dic objectForKey:@"ID"];
        _icon = [dic objectForKey:@"icon"];
        _name = [dic objectForKey:@"name"];
        _time = [dic objectForKey:@"time"];
        _contents = [dic objectForKey:@"contents"];
        _comefrom = [dic objectForKey:@"comefrom"];
    }
    return self;
}

+ (instancetype)commentModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}


-(NSString *)time
{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *createdDate = [fmt dateFromString:_time];
    
    // 2..判断微博发送时间 和 现在时间 的差距
    if (createdDate.isToday) { // 今天
        if (createdDate.deltaWithNow.hour >= 1) {
            return [NSString stringWithFormat:@"%ld小时前", (long)createdDate.deltaWithNow.hour];
        } else if (createdDate.deltaWithNow.minute >= 1) {
            return [NSString stringWithFormat:@"%ld分钟前", (long)createdDate.deltaWithNow.minute];
        } else {
            return @"刚刚";
        }
    } else if (createdDate.isYesterday) { // 昨天
        fmt.dateFormat = @"昨天 HH:mm";
        return [fmt stringFromDate:createdDate];
    } else if (createdDate.isThisYear) { // 今年(至少是前天)
        fmt.dateFormat = @"MM-dd HH:mm";
        return [fmt stringFromDate:createdDate];
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createdDate];
    }
    
}

@end
