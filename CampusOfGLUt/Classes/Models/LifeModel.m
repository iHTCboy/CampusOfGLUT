//
//  LifeModel.m
//  CampusOfGLUT
//
//  Created by HTC on 15/3/1.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "LifeModel.h"
#import "NSDate+TC.h"

@implementation LifeModel

- (instancetype)initWithDict:(NSDictionary *)dic
{
    if (self = [super init]) {
        //[self setValuesForKeysWithDictionary:dict];
        _ID = [dic objectForKey:@"_id"];
        _icon = [dic objectForKey:@"icon"];
        _name = [dic objectForKey:@"_name"];
        _contents = [dic objectForKey:@"contents"];
        _createtime = [dic objectForKey:@"_createtime"];
        _time = [dic objectForKey:@"_createtime"];
        _images = [dic objectForKey:@"images"];
        _comefrom = [dic objectForKey:@"comefrom"];
        _commets = [dic objectForKey:@"commets"];
        _praises = [dic objectForKey:@"praises"];
        _reports = [dic objectForKey:@"reports"];
    }
    return self;
}

+ (instancetype)lifeModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}


-(NSString *)createtime
{

    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *createdDate = [fmt dateFromString:_createtime];
    
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
