//
//  NewsCacheTool.m
//  CampusOfGLUt
//
//  Created by HTC on 15/2/16.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "NewsCacheTool.h"
#import "FMDB.h"
#import "NewsModel.h"

@implementation NewsCacheTool


static FMDatabaseQueue *_queue;

/**
 *  在C语言中，关键字static有三个明显的作用：
 
 1). 在函数体，一个被声明为静态的变量在这一函数被调用过程中只会初始化一次。
 
 2). 在模块内（但在函数体外），一个被声明为静态的变量可以被模块内所用函数访问，但不能被模块外其它函数访问。它是一个本地的全局变量。
 
 3). 在模块内，一个被声明为静态的函数只可被这一模块内的其它函数调用。那就是，这个函数被限制在声明它的模块的本地范围内使用。
 */
static NSInteger _currentExecuteCounts;

+ (void)initialize
{
    // 0.获得沙盒中的数据库文件名
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"glutNews.sqlite"];
    
    // 1.创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    // 2.创表
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_news (id integer primary key autoincrement, ids integer, title text, url text, author text, clickNum text, time text, source text, enter_men text, contents text, images text);"];
    }];
    
}

+ (NSInteger)currentExecuteCounts
{

    return _currentExecuteCounts;

}

+ (void)insertNewItems:(NSArray *)items
{
    _currentExecuteCounts += 1;
    
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         for(NSInteger i = (items.count -1); i >= 0; i--)
         {
             NewsModel * news = items[i];
             //查询数据库中是否存在url对应的项
             rs = [db executeQuery:@"select * from t_news where url = ?",news.url];
             if(rs.next)
             {
                 //存在就查看 是否缓存了内容
                 NSString * source = [rs stringForColumn:@"source"];
                 int ids = [rs intForColumn:@"ids"];
                 [rs close];
        
                 if (source || !news.source)
                 {
                     //如果有缓存，就不在插入, 或者新项里没缓存内容，也不存
                     continue;
                 }
                 else
                 {

                     [db executeUpdate:@"update t_news set title = ? , url = ? , author = ? , clickNum = ? , time  = ? , source = ? , enter_men = ? , contents = ? , images = ? where ids = ?;",news.title, news.url, news.author, news.clickNum, news.time, news.source, news.enter_men, news.contentHTML, news.imagesHTML, [NSNumber numberWithInt:ids]];
                     
                     continue;
                 
                 }
                 
             }
             [rs close];
             
            //不存在的直接插入到最后面
             
             //1、查询数据库中有几组数据
             rs = [db executeQuery:@"select count(*) from t_news"];
             int counts = 0;
             if (rs.next)
             {
                 counts = [rs intForColumnIndex:0] + 1;
             }
             [rs close];
             
             
             //插入项
             [db executeUpdate:@"insert into t_news(ids, title, url, author, clickNum, time, source, enter_men, contents, images) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",[NSNumber numberWithInt:counts],  news.title, news.url, news.author, news.clickNum, news.time, news.source, news.enter_men, news.contentHTML, news.imagesHTML];
             
         }
         
     }];

    _currentExecuteCounts -= 1;
}


+ (void)insertOldItems:(NSArray *)items
{
    _currentExecuteCounts += 1;
    
    NSLog(@"insertOldItem  stard--%ld",(long)_currentExecuteCounts);
    
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         int ids = 0;
         int ID= 0;
         for(NSInteger i = 0; i < items.count; i++)
         {
             NewsModel * news = items[i];
             //查询数据库中是否存在url对应的项
             rs = [db executeQuery:@"select * from t_news where url = ?",news.url];
             if(rs.next)
             {
                 //记录这项所在位置,下一个
                 ids = [rs intForColumn:@"ids"];
                 ID = [rs intForColumn:@"id"];
                 //NSLog(@"---%d",ids);
                 [rs close];
                 
                 continue;
             }
             [rs close];
             
             //不存在的 如果ids不为0,即存在项，则插入到ids的上一个。
             //        如果ids为0，不存在，即这项是最旧的，直接插入到第一ids＝ 1
             
             if (ids ==0)
             {
                 ids = 1;
             }
             //1、查询数据库中有几组数据
             rs = [db executeQuery:@"select count(*) from t_news"];
             int counts = 0;
             if (rs.next)
             {
                 counts = [rs intForColumnIndex:0];
             }
             [rs close];
             
             for(counts; counts >= ids; counts--)
             {

                 //查询循环里ids对应的id
                 rs = [db executeQuery:@"select * from t_news where ids = ?",[NSNumber numberWithInt:counts]];
                 if(rs.next)
                 {
                     //记录这项所在位置,下一个
                     ID = [rs intForColumn:@"id"];
                     [rs close];
                 }
                 
                 //大于当前的ids加1
                 [db executeUpdate:@"update t_news set ids = ? where id = ? ;",[NSNumber numberWithInt:counts +1],[NSNumber numberWithInt:ID]];
                 
                //NSLog(@"counts%d ----- ID%d",counts,ID);
                 
             }
             //插入项
             [db executeUpdate:@"insert into t_news(ids, title, url, author, clickNum, time, source, enter_men, contents, images) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",[NSNumber numberWithInt:ids],  news.title, news.url, news.author, news.clickNum, news.time, news.source, news.enter_men, news.contentHTML, news.imagesHTML];
             
         }
         
     }];

    _currentExecuteCounts -= 1;
    NSLog(@"insertOldItem end--%ld",_currentExecuteCounts);
    
}


+ (NSArray *)queryWithNumber:(NSInteger)number
{
    _currentExecuteCounts += 1;

    __block NSMutableArray * newsArray = [NSMutableArray array];

    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         //1、查询数据库中有几组数据
         rs = [db executeQuery:@"select count(*) from t_news"];
         int counts = 0;
         if (rs.next)
         {
             counts = [rs intForColumnIndex:0];
         }
         [rs close];

         if (counts != 0)
         {
             int ids = counts;//数据库最大条数
             int min ; //最小下界值
             //判断提取数和所有数比较，设置提取的下限界
             if (ids <= number)
             {
                 min = 0;
             }
             else
             {
                 min = ids -  (int)number;
             }
             
             for (ids; ids > min; ids--)
             {
                 //查询
                 rs = [db executeQuery:@"select * from t_news where ids = ?",[NSNumber numberWithInt:ids]];
                 if(rs.next)
                 {
                     
                     //ids, title, url, author, clickNum, time, source, enter_men, contentHTML, images
                     NewsModel * news = [[NewsModel alloc]init];
                     news.title = [rs stringForColumn:@"title"];
                     news.url = [rs stringForColumn:@"url"];
                     news.author = [rs stringForColumn:@"author"];
                     news.clickNum = [rs stringForColumn:@"clickNum"];
                     news.time = [rs stringForColumn:@"time"];
                     news.source = [rs stringForColumn:@"source"];
                     news.enter_men = [rs stringForColumn:@"enter_men"];
                     news.contentHTML = [rs stringForColumn:@"contents"];
                     news.imagesHTML = [rs stringForColumn:@"images"];
                     
                     [newsArray addObject:news];
                     
                     [rs close];
                 }
             }
         }
         else
         {
         
             newsArray = nil;
         
         }
         
     }];

    _currentExecuteCounts -= 1;
    
    return newsArray;

}


+ (NewsModel *)queryWithURL:(NSString *)url
{
    _currentExecuteCounts += 1;
 
    __block NewsModel * newsModel = [[NewsModel alloc]init];
    
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         //查询
         rs = [db executeQuery:@"select * from t_news where url = ?",url];
         if(rs.next)
         {
             
             //ids, title, url, author, clickNum, time, source, enter_men, contentHTML, images
             newsModel.title = [rs stringForColumn:@"title"];
             newsModel.url = [rs stringForColumn:@"url"];
             newsModel.author = [rs stringForColumn:@"author"];
             newsModel.clickNum = [rs stringForColumn:@"clickNum"];
             newsModel.time = [rs stringForColumn:@"time"];
             newsModel.source = [rs stringForColumn:@"source"];
             newsModel.enter_men = [rs stringForColumn:@"enter_men"];
             newsModel.contentHTML = [rs stringForColumn:@"contents"];
             newsModel.imagesHTML = [rs stringForColumn:@"images"];
 
             [rs close];
         }
         
         if (!newsModel.source)
         {
              newsModel = nil;
         }
         
     }];
    
    _currentExecuteCounts -= 1;
    
    return newsModel;

}


+ (NSInteger )updateNewItems:(NSArray *)items
{
    
    _currentExecuteCounts += 1;
    
    
    __block NSInteger newcounts = 0;
    
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         for(NSInteger i = (items.count -1); i >= 0; i--)
         {
             NewsModel * news = items[i];
             //查询数据库中是否存在url对应的项
             rs = [db executeQuery:@"select * from t_news where url = ?",news.url];
             if(rs.next)
             {
                 int ids = [rs intForColumn:@"ids"];
                 
                 //依然插入最新的浏览数
                 [db executeUpdate:@"update t_news set clickNum = ? where ids = ?;",news.clickNum, [NSNumber numberWithInt:ids]];
                 
                [rs close];
                continue;
             }
             
             
             //不存在的直接插入到最后面
             
             //1、查询数据库中有几组数据
             rs = [db executeQuery:@"select count(*) from t_news"];
             int counts = 0;
             if (rs.next)
             {
                 counts = [rs intForColumnIndex:0] + 1;
             }
             [rs close];
             
             
             //插入项
             [db executeUpdate:@"insert into t_news(ids, title, url, author, clickNum, time, source, enter_men, contents, images) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",[NSNumber numberWithInt:counts],  news.title, news.url, news.author, news.clickNum, news.time, news.source, news.enter_men, news.contentHTML, news.imagesHTML];
             
             newcounts += 1;
         }
         
     }];

    _currentExecuteCounts -= 1;
    
    return newcounts;

}

@end
