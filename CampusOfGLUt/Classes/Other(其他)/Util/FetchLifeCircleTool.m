//
//  FetchLifeCircleTool.m
//  CampusOfGLUT
//
//  Created by HTC on 15/2/28.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "FetchLifeCircleTool.h"

/**
 *  高德sdk
 */
const static NSString *APIKey = @"0e56d7a79cbbade4442ba48d2a39df64";

/**
 *  我的测试表
 */
//const static NSString *tableID = @"54f1aa03e4b0a8782e4ecbda";

//const static NSString *tableID = @"551181ece4b005aa5597492f";

/**
 *  桂工云图 Rest 服务接口
 */
const static NSString *RestIKey = @"4303eecd49d9469bc440187367c0028f";

@interface FetchLifeCircleTool()

@property (nonatomic, strong) AFHTTPRequestOperationManager * mgr;

@end


@implementation FetchLifeCircleTool


// 定义一份变量(整个程序运行过程中, 只有1份)
static id _instance;

- (id)init
{
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // 加载资源
            self.mgr = [AFHTTPRequestOperationManager manager];
            self.mgr.requestSerializer.timeoutInterval = 5;
        });
    }
    return self;
}

/**
 *  重写这个方法 : 控制内存内存
 */
+ (id)allocWithZone:(struct _NSZone *)zone
{
    // 里面的代码永远只执行1次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    // 返回对象
    return _instance;
}

+ (instancetype)sharedFetchNewsTool
{
    // 里面的代码永远只执行1次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    // 返回对象
    return _instance;
}



- (void)cancelAllOperations
{
    [self.mgr.operationQueue cancelAllOperations];
}

#pragma mark - 通过ID搜索条目
- (void)fetchTalkOfLifeCircleWithTableID:(NSString *)tableId ID:(NSString *)ID success:(void (^)(NSArray *fetchArray))success failure:(void (^)(NSError *error))failure
{

    // 2.封装请求参数
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                RestIKey,@"key",
                                tableId,@"tableid",
                                ID,@"_id",
                                nil];
    
    /** yuntuapi.amap.com/datasearch/id?tableid=52b155b6e4b0bc61deeb7629&_id=372
     *  http://yuntuapi.amap.com/datasearch/id?tableid=52b155b6e4b0bc61deeb7629&_id=372
     &key= < 用户 key>
     http://yuntuapi.amap.com/datasearch/id?
     http://yuntuapi.amap.com/datamanage/data/list?
     */
    [self.mgr GET:@"http://yuntuapi.amap.com/datasearch/id?" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] intValue])
        {
            NSArray * array = [responseObject objectForKey:@"datas"];
        //NSLog(@"----%@",dic);
        
           success(array);
        }
        else
        {
            NSError * error = [[NSError alloc]initWithDomain:@"没有更多" code:1314520 userInfo:responseObject];
            failure(error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];
    
    
    //http://chuantu.biz/upload.php

}




#pragma mark -  获取最新条目
- (void)fetchNewLifeCircleWithTableID:(NSString *)tableId success:(void (^)(NSArray *fetchArray))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                RestIKey,@"key",
                                tableId,@"tableid",
                                nil];
    [self.mgr GET:@"http://yuntuapi.amap.com/datamanage/data/list?" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"status"] intValue])
            {
                NSArray * array = [responseObject objectForKey:@"datas"];
                
                success(array);
            }
            else
            {
                NSError * error = [[NSError alloc]initWithDomain:@"取最新数据失败" code:8888888 userInfo:responseObject];
                failure(error);
            }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];



}


#pragma mark - 搜索某ID范围条目
- (void)fetchTalkOfLifeCircleWithTableID:(NSString *)tableId endID:(NSInteger)eID range:(NSInteger)range  success:(void (^)(NSArray *fetchArray))success failure:(void (^)(NSError *error))failure
{

    // 1.封装请求参数
    NSString * IDs = [NSString stringWithFormat:@"_id:[%ld,%ld]",eID-range-1,eID];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                RestIKey,@"key",
                                tableId,@"tableid",
                                IDs,@"filter",
                                nil];
 
    [self.mgr GET:@"http://yuntuapi.amap.com/datamanage/data/list?" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([[responseObject objectForKey:@"status"] intValue])
        {
            if([[responseObject objectForKey:@"count"] intValue])
            {
                NSArray * array = [responseObject objectForKey:@"datas"];
                // NSLog(@"----%@",array);
                
                success(array);
            
            }
            else
            {
                // status = 1; count = 0 的情况
                NSError * error = [[NSError alloc]initWithDomain:@"没有更多" code:1314520 userInfo:responseObject];
                failure(error);
            
            }

        }
        else
        {
            NSError * error = [[NSError alloc]initWithDomain:@"加载失败" code:8888888 userInfo:responseObject];
            failure(error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];

}


#pragma mark - 发送一条说说
- (void)sendTextToLifeCircleWithTableID:(NSString *)tableId icon:(NSString *)icon name:(NSString *)name contents:(NSString *)contents images:(UIImage *)images imageURL:(NSString *)imageUrl  commets:(NSString *)commets comefrom:(NSString *)comefrom praises:(NSString *)praises reports:(NSString *)reports success:(void (^)(NSArray *fetchArray))success failure:(void (^)(NSError *error))failure
{
        // 1.封装请求参数
        NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 name.length == 0?@"匿名":name,@"_name",
                                 @"113.370295,23.134521",@"_location",
                                 @"暂无",@"_address",
                                 icon,@"icon",
                                 contents,@"contents",
                                 comefrom,@"comefrom",
                                 @"0",@"praises",
                                 @"0",@"reports",
                                 imageUrl,@"images",
                                 commets,@"commets",
                                 nil];
        
        NSString *jsonString;
        
        //Foundation对象转换为json数据
        if ([NSJSONSerialization isValidJSONObject:dataDic])
        {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:&error];
            jsonString=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"json data:%@",jsonString);
        }
        
        NSDictionary *dataAllDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                    RestIKey,@"key",
                                    tableId,@"tableid",
                                    @"1",@"loctype", //使用GPS坐标方式存储
                                    jsonString,@"data",
                                    nil];
        
        
        
        //NSLog(@"-------\n %@",dataAllDic);
        
        // 3.发送请求
        [self.mgr POST:@"http://yuntuapi.amap.com/datamanage/data/create" parameters:dataAllDic
               success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             NSString * status = [responseObject objectForKey:@"status"];
             NSLog(@"-------\n %@  %@",responseObject,status);
             
             if ([status intValue]){
                 success(nil);
                 //[self sendImages:images];
                 
             }else{
                 // 格式有误情况？
                 NSError * error = [[NSError alloc]initWithDomain:[responseObject objectForKey:@"info"] code:1314520 userInfo:responseObject];
                 failure(error);
             }
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             failure(error);
         }];

}


#pragma mark 发照片
- (void)sendImages:(UIImage *)image success:(void (^)(NSDictionary *dic))success failure:(void (^)(NSError *error))failure
{
    /*
     http://mingxuanmall.xyd.qushiyun.com/mobile/index.php?app=user&act=edit_user_portrait
     "user_id" = 2498263;
     "user_id" = 2498273;
     
     
     http://taixinlongmall.xyd.qushiyun.com/mobile/index.php?app=user&act=edit_user_portrait
     "user_id" = 2496773;
     
     "user_id" = 2498283;
     
     
     http://m.mflmall.xyd.qushiyun.com/mobile/index.php?app=user&act=edit_user_portrait
     "user_id" = 2498293;
     "user_id" = 2498303;
     */

    // 上传图片的URL
    NSDictionary * urlDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"http://mingxuanmall.xyd.qushiyun.com/mobile/index.php?app=user&act=edit_user_portrait",
                             @"2498263",
                             @"http://mingxuanmall.xyd.qushiyun.com/mobile/index.php?app=user&act=edit_user_portrait",
                             @"2498273",
                             @"http://taixinlongmall.xyd.qushiyun.com/mobile/index.php?app=user&act=edit_user_portrait",
                             @"2496773",
                             @"http://taixinlongmall.xyd.qushiyun.com/mobile/index.php?app=user&act=edit_user_portrait",
                             @"2498283",
                             @"http://m.mflmall.xyd.qushiyun.com/mobile/index.php?app=user&act=edit_user_portrait",
                             @"2498293",
                             @"http://m.mflmall.xyd.qushiyun.com/mobile/index.php?app=user&act=edit_user_portrait",
                             @"2498303", nil];
    
    
    NSArray * allID = urlDic.allKeys;
    int x = arc4random()%6;
    
    NSString *userID = allID[x];
    NSString *userUrl = [urlDic objectForKey:userID];

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:userID forKey:@"user_id"];
        NSLog(@"userUrl--%@",userUrl);
        NSLog(@"userID--%@",userID);
    
    [self.mgr POST:userUrl parameters:parameters
    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 一定要在这个block中添加文件参数
        // 1.加载文件数据
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        // 2.拼接文件参数 file
        [formData appendPartWithFileData:data name:@"Filedata" fileName:@"image.jpg" mimeType:@"image/jpg"];
      }
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"imageSuccess--%@",responseObject);
          success(responseObject);
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"上传失败----%@", error.description);
          failure(error);
      }];
    
}




#pragma mark - 更新说说的点赞数
-(void)updataPraisesWithTableID:(NSString *)tableId IDs:(NSString *)ids newPraises:(NSString *)praises success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    //更新数据请求 请求地址：http://yuntuapi.amap.com/datamanage/data/update
    
    // 1.封装请求参数
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             ids,@"_id",
                             praises,@"praises",
                             nil];
    
    NSString *jsonString;
    
    //Foundation对象转换为json数据
    if ([NSJSONSerialization isValidJSONObject:dataDic])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:&error];
        jsonString=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"json data:%@",jsonString);
    }
    
    NSDictionary *dataAllDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                RestIKey,@"key",
                                tableId,@"tableid",
                                jsonString,@"data",
                                nil];
    
    [self.mgr POST:@"http://yuntuapi.amap.com/datamanage/data/update" parameters:dataAllDic success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSString * status = [responseObject objectForKey:@"status"];
//        NSString * info = [responseObject objectForKey:@"info"];
//        NSLog(@"-------\n %@  %@",responseObject,info);
        
        if ([status intValue]){
            success(nil);
            //[self sendImages:images];
            
        }else{
            // 格式有误情况？
            NSError * error = [[NSError alloc]initWithDomain:@"格式有误" code:1314520 userInfo:responseObject];
            failure(error);
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failure(error);
    }];
    
}

#pragma mark - 更新说说的举报数
-(void)updataReportsWithTableID:(NSString *)tableId IDs:(NSString *)ids newReports:(NSString *)reports success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    //更新数据请求 请求地址：http://yuntuapi.amap.com/datamanage/data/update
    
    // 1.封装请求参数
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             ids,@"_id",
                             reports,@"reports",
                             nil];
    
    NSString *jsonString;
    
    //Foundation对象转换为json数据
    if ([NSJSONSerialization isValidJSONObject:dataDic])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:&error];
        jsonString=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"json data:%@",jsonString);
    }
    
    NSDictionary *dataAllDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                RestIKey,@"key",
                                tableId,@"tableid",
                                jsonString,@"data",
                                nil];
    
    [self.mgr POST:@"http://yuntuapi.amap.com/datamanage/data/update" parameters:dataAllDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString * status = [responseObject objectForKey:@"status"];
         // NSLog(@"-------\n %@  %@",responseObject,status);
         
         if ([status intValue]){
             success(nil);
             //[self sendImages:images];
             
         }else{
             // 格式有误情况？
             NSError * error = [[NSError alloc]initWithDomain:@"格式有误" code:1314520 userInfo:responseObject];
             failure(error);
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failure(error);
     }];
    
    
}

- (void)test
{

    
    
}


/** 更新评论 */
- (void)sendCommentToLifeCircleWithTableID:(NSString *)tableId icon:(NSString *)icon name:(NSString *)name contents:(NSString *)contents comefrom:(NSString *)comefrom lifeModel:(LifeModel *)lifeModel success:(void (^)(NSArray *fetchArray))success failure:(void (^)(NSError *error))failure
{
    //获取最新的评论，在发
    [self fetchTalkOfLifeCircleWithTableID:tableId ID:lifeModel.ID success:^(NSArray *fetchArray) {
        
        LifeModel * newModel = [LifeModel lifeModelWithDict:[fetchArray firstObject]];
        NSString * commetStr = newModel.commets;
        
        NSDate * newdata = [NSDate date];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString * newDateStr = [dateFormatter stringFromDate:newdata];
        
        // 1.无评论，新封装(从网络回来，无数据时是“__NSCFConstantString" 有数据是“__NSCFString"  本地是“NSNull”
        if ([[[newModel.commets class] description] isEqualToString:@"__NSCFConstantString"]) {
            
            commetStr = [@"1" stringByAppendingString:@"{1}"];
            commetStr = [commetStr stringByAppendingString:@"ID"];
            
            commetStr = [commetStr stringByAppendingString:@"{2}"];
            
            commetStr = [commetStr stringByAppendingString:name.length == 0?@"匿名":name];
            commetStr = [commetStr stringByAppendingString:@"{1}"];
            commetStr = [commetStr stringByAppendingString:@"name"];
            
            commetStr = [commetStr stringByAppendingString:@"{2}"];
            
            commetStr = [commetStr stringByAppendingString:icon];
            commetStr = [commetStr stringByAppendingString:@"{1}"];
            commetStr = [commetStr stringByAppendingString:@"icon"];
            
            commetStr = [commetStr stringByAppendingString:@"{2}"];
            
            commetStr = [commetStr stringByAppendingString:newDateStr];
            commetStr = [commetStr stringByAppendingString:@"{1}"];
            commetStr = [commetStr stringByAppendingString:@"time"];
            
            commetStr = [commetStr stringByAppendingString:@"{2}"];
            
            commetStr = [commetStr stringByAppendingString:contents];
            commetStr = [commetStr stringByAppendingString:@"{1}"];
            commetStr = [commetStr stringByAppendingString:@"contents"];
            
            commetStr = [commetStr stringByAppendingString:@"{2}"];
            
            commetStr = [commetStr stringByAppendingString:comefrom];
            commetStr = [commetStr stringByAppendingString:@"{1}"];
            commetStr = [commetStr stringByAppendingString:@"comefrom"];
            
        }else{
            
            NSString *ID = [NSString stringWithFormat:@"%lu",(unsigned long)[commetStr componentsSeparatedByString:@"{3}"].count +1];
            
            commetStr = [commetStr stringByAppendingString:@"{3}"];
            
            commetStr = [commetStr stringByAppendingString:ID];
            commetStr = [commetStr stringByAppendingString:@"{1}"];
            commetStr = [commetStr stringByAppendingString:@"ID"];
            
            commetStr = [commetStr stringByAppendingString:@"{2}"];
            
            commetStr = [commetStr stringByAppendingString:name.length == 0?@"匿名":name];
            commetStr = [commetStr stringByAppendingString:@"{1}"];
            commetStr = [commetStr stringByAppendingString:@"name"];
            
            commetStr = [commetStr stringByAppendingString:@"{2}"];
            
            commetStr = [commetStr stringByAppendingString:icon];
            commetStr = [commetStr stringByAppendingString:@"{1}"];
            commetStr = [commetStr stringByAppendingString:@"icon"];
            
            commetStr = [commetStr stringByAppendingString:@"{2}"];
            
            commetStr = [commetStr stringByAppendingString:newDateStr];
            commetStr = [commetStr stringByAppendingString:@"{1}"];
            commetStr = [commetStr stringByAppendingString:@"time"];
            
            commetStr = [commetStr stringByAppendingString:@"{2}"];
            
            commetStr = [commetStr stringByAppendingString:contents];
            commetStr = [commetStr stringByAppendingString:@"{1}"];
            commetStr = [commetStr stringByAppendingString:@"contents"];
            
            commetStr = [commetStr stringByAppendingString:@"{2}"];
            
            commetStr = [commetStr stringByAppendingString:comefrom];
            commetStr = [commetStr stringByAppendingString:@"{1}"];
            commetStr = [commetStr stringByAppendingString:@"comefrom"];
            
        }
        
        
        // 4.封装请求参数
        NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 newModel.ID,@"_id",
                                 commetStr,@"commets",
                                 nil];
        NSString *alljson;
        
        //Foundation对象转换为json数据
        if ([NSJSONSerialization isValidJSONObject:dataDic])
        {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:&error];
            alljson=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"alljson data:%@",alljson);
        }
        
        NSDictionary *dataAllDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                    RestIKey,@"key",
                                    tableId,@"tableid",
                                    alljson,@"data",
                                    nil];
        
        [self.mgr POST:@"http://yuntuapi.amap.com/datamanage/data/update" parameters:dataAllDic success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSString * status = [responseObject objectForKey:@"status"];
             // NSLog(@"-------\n %@  %@",responseObject,status);
             
             if ([status intValue]){
                 success(nil);
                 //[self sendImages:images];
                 
             }else{
                 // 格式有误情况？
                 NSError * error = [[NSError alloc]initWithDomain:@"格式有误" code:1314520 userInfo:responseObject];
                 failure(error);
             }
             
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(error);
         }];
        
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
    
}


@end
