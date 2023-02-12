//
//  FetchNewsDataTool.m
//  CampusOfGLUt
//
//  Created by HTC on 15/2/14.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "FetchNewsDataTool.h"
#import "AFNetworking.h"
#import "NewsModel.h"
#import "TFHpple.h"

@interface FetchNewsTool()<UIWebViewDelegate>

@property (nonatomic, weak) NSTimer * timer;
//@property (nonatomic, strong) AFHTTPSessionManager * mgr;
@property (nonatomic, strong) UIWebView * webView;//可以考虑加上web

@end

@implementation FetchNewsTool

// 定义一份变量(整个程序运行过程中, 只有1份)
static id _instance;

- (id)init
{
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // 加载资源
//            self.mgr = [AFHTTPSessionManager manager];
//            self.mgr.requestSerializer.timeoutInterval = 8;
//            [self.mgr.requestSerializer setValue:@"zh-cn" forHTTPHeaderField:@"Accept-Language"];
//            [self.mgr.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
//            [self.mgr.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1 Safari/605.1.15" forHTTPHeaderField:@"User-Agent"];
//            self.mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
//            self.mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",@"text/javascript",@"application/xhtml+xml,",@"application/xml", nil];
            // Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
//            Upgrade-Insecure-Requests: 1
//            Host: www.glut.edu.cn
//            User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1 Safari/605.1.15
//            Accept-Language: zh-cn
//            Accept-Encoding: gzip, deflate
//            Connection: keep-alive
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
//    [self.mgr.operationQueue cancelAllOperations];
}


- (void)getNewsListDataWithClassName:(NSString *)name page:(int)page success:(void (^)(NSArray *fetchNewsArray ,int nextPage))success failure:(void (^)(NSError *error))failure
{
    NSMutableArray * contentArray = [NSMutableArray array];
    
    /*
     科教动态
     https://www.glut.edu.cn/kjdt.htm
     https://www.glut.edu.cn/kjdt/297.htm
     https://www.glut.edu.cn/info/1076/16788.htm

     桂工要闻
     https://www.glut.edu.cn/ggyw.htm
     https://www.glut.edu.cn/ggyw/837.htm

     通知公告
     https://www.glut.edu.cn/tzgg.htm
     https://www.glut.edu.cn/tzgg/251.htm

     学术活动
     https://www.glut.edu.cn/xshd.htm
     https://www.glut.edu.cn/xshd/2.htm

     校园快讯
     https://www.glut.edu.cn/xykx.htm
     https://www.glut.edu.cn/xykx/1.htm

     媒体桂工
     https://www.glut.edu.cn/mtgg.htm
     https://www.glut.edu.cn/mtgg/87.htm

     融媒矩阵
     https://www.glut.edu.cn/rmjz.htm
     https://www.glut.edu.cn/rmjz/1.htm
     */
    
    NSString * url;
    if ([name isEqualToString:@"教学科研"])
    {
        if (page==0) {
            url = @"https://www.glut.edu.cn/kjdt.htm";
        }else{
           url = [NSString stringWithFormat:@"https://www.glut.edu.cn/kjdt/%d.htm",page];
        }
    }
    else if([name isEqualToString:@"新闻中心"])
    {
        if (page==0) {
            url = @"https://www.glut.edu.cn/ggyw.htm";
        }else{
            url = [NSString stringWithFormat:@"https://www.glut.edu.cn/ggyw/%d.htm",page];
        }
    }
    else if([name isEqualToString:@"公告"])
    {
        if (page==0) {
            url = @"https://www.glut.edu.cn/tzgg.htm";
        }else{
            url = [NSString stringWithFormat:@"https://www.glut.edu.cn/tzgg/%d.htm",page];
        }
    }
    else if([name isEqualToString:@"学术活动"])
    {
        if (page==0) {
            url = @"https://www.glut.edu.cn/xshd.htm";
        }else{
            url = [NSString stringWithFormat:@"https://www.glut.edu.cn/xshd/%d.htm",page];
        }
    }
    else if([name isEqualToString:@"校园快讯"])
    {
        if (page==0) {
            url = @"https://www.glut.edu.cn/xykx.htm";
        }else{
            url = [NSString stringWithFormat:@"https://www.glut.edu.cn/xykx/%d.htm",page];
        }
    }
    else if([name isEqualToString:@"媒体桂工"])
    {
        if (page==0) {
            url = @"https://www.glut.edu.cn/mtgg.htm";
        }else{
            url = [NSString stringWithFormat:@"https://www.glut.edu.cn/mtgg/%d.htm",page];
        }
    }
    else if([name isEqualToString:@"融媒矩阵"])
    {
        if (page==0) {
            url = @"https://www.glut.edu.cn/rmjz.htm";
        }else{
            url = [NSString stringWithFormat:@"https://www.glut.edu.cn/rmjz/%d.htm",page];
        }
    }
    
//    NSLog(@" --- %@",url);
    
//    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//
//    NSString* encodedString = [url stringByAddingPercentEscapesUsingEncoding:gbkEncoding];
    

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //创建NSURLSession对象（可以获取单例对象）
    NSURLSession *session = [NSURLSession sharedSession];
    //根据NSURLSession对象创建一个Task
    NSURLSessionDataTask * dataTask =  [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {

        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error || !data) {
                failure(error);
                //NSLog(@"error");
                return;
            }
        
//        //拿到响应头信息
//        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
//
//        //6.解析拿到的响应数据
//        NSLog(@"%@\n%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],res.allHeaderFields);
//
        /*
         <div class="list_content">
         <ul>
         <li id="line_u8_0">
         <a href="../info/1109/25667.htm" target="_blank" title="《桂林日报》报道我校老红军柳林同志：百年征程情怀不减　淡泊从容安度晚年">《桂林日报》报道我校老红军柳林同志：百年征程情怀不减　淡泊从容安度晚年</a>
         <p>2016-10-20</p>
         </li>
         
         */
            
            TFHpple *xpathparser = [[TFHpple alloc] initWithHTMLData:data];
            // /html/body/div/div/div[2]/div[2]/ul
            //NSArray *elements  = [xpathparser searchWithXPathQuery:@"//div[@class='list_content']/ul/li"];
            
            // /html/body/section/section[6]/div[2]/div[2]/section/ul/li
            NSArray *elements  = [xpathparser searchWithXPathQuery:@"//section[@class='n_riqi']/ul/li"];
            
            for (int i = 0; i < elements.count; i++)
            {
                TFHppleElement * element = [elements objectAtIndex:i];
                
                //NSArray *aValue = [element childrenWithTagName:@"a"];
                //NSArray *aValue = [element searchWithXPathQuery:@"//a"];
                //TFHppleElement * aElement = aValue.firstObject;
                
                TFHppleElement * aElement = [element firstChildWithTagName:@"a"];
                NSString * href = [aElement objectForKey:@"href"];

                // /html/body/section/section[6]/div[2]/div[2]/section/ul/li[1]/a/div[2]/h5
                NSArray * titleElements = [aElement searchWithXPathQuery:@"//div[@class='con']/h5"];
                NSString * title = titleElements.firstObject ? [(TFHppleElement *)titleElements.firstObject text] : @"";
                
                // month: /html/body/section/section[6]/div[2]/div[2]/section/ul/li[1]/a/div[1]/div/h3
                // year: /html/body/section/section[6]/div[2]/div[2]/section/ul/li[1]/a/div[1]/div/h6
                NSArray * monthElements = [aElement searchWithXPathQuery:@"//div[@class='ll']/div/h3"];
                NSString * month = monthElements.firstObject ? [(TFHppleElement *)monthElements.firstObject text] : @"";
                
                NSArray * yearElements = [aElement searchWithXPathQuery:@"//div[@class='ll']/div/h6"];
                NSString * year = yearElements.firstObject ? [(TFHppleElement *)yearElements.firstObject text] : @"";
                
                // /html/body/section/section[6]/div[2]/div[2]/section/ul/li[1]/a/div[2]/h5/font
                //*[@id="dynclicks_u57_16768"]
//                NSArray * numElements = [aElement searchWithXPathQuery:@"//div[@class='con']/h5/font//span"];
//                NSString * num = numElements.firstObject ? [(TFHppleElement *)numElements.firstObject text] : @"";
                
                NSArray * subtitleElements = [aElement searchWithXPathQuery:@"//div[@class='con']/p"];
                NSString * subtitle = subtitleElements.firstObject ? [(TFHppleElement *)subtitleElements.firstObject text] : @"";
                
                NewsModel * news = [[NewsModel alloc]init];
                news.title = title;
    //            news.author = @"";
//                news.clickNum = @"1";
                news.time = [year stringByAppendingString: month.length >0 ? [@"-" stringByAppendingString:month] : @""];
                
                // href="https://zcglc.glut.edu.cn/info/1192/2899.htm"
                if ([href hasPrefix:@"http"]) {
                    news.url = href;
                }
                else if(page == 0) {
                    // href="info/1076/16788.htm"
                    news.url = [@"http://www.glut.edu.cn/" stringByAppendingString:href];
                }else{
                    // href="../info/1076/16737.htm"
                    news.url = [href stringByReplacingOccurrencesOfString:@"../" withString:@"http://www.glut.edu.cn/"];
                }
                
                [contentArray addObject:news];
                
            }
            
            
            // 查找剩下页数
            int nextPage = 0;
            // /html/body/section/section[6]/div[2]/div[2]/section/div/span[1]/span[10]/a
            NSArray *pageElements  = [xpathparser searchWithXPathQuery:@"//span[@class='p_next p_fun']/a"];
            if (pageElements.count) {
                TFHppleElement * aElement = pageElements.firstObject;
                // href="kjdt/297.htm"
                NSString * href = [aElement objectForKey:@"href"];
                if (page == 0) {
                    NSString * page = (NSString *) [[[[href componentsSeparatedByString:@"/"] objectAtIndex:1] componentsSeparatedByString:@".htm"] objectAtIndex:0];
                    nextPage = [page intValue];
                }else{
                    // href="4.htm"
                    NSString * page = (NSString *) [[href componentsSeparatedByString:@".htm"] objectAtIndex:0];
                    nextPage = [page intValue];
                }
            }
            
            success(contentArray, nextPage);

        });
    
    }];
    
    //执行Task
    //注意：刚创建出来的task默认是挂起状态的，需要调用该方法来启动任务（执行任务）
    [dataTask resume];
}


- (void)getFocusImagesSuccess:(void (^)(NSArray *fetchImagesArray))success failure:(void (^)(NSError *error))failure
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.glut.edu.cn/index.htm"]];
    //创建NSURLSession对象（可以获取单例对象）
//    NSURLSession *session = [NSURLSession sharedSession];
//    //根据NSURLSession对象创建一个Task
//    NSURLSessionDataTask * dataTask =  [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            if (error || !data) {
//                failure(error);
//                //NSLog(@"error");
//                return;
//            }
//
//            NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"str: %@", str);
//            // 1.新闻内容模型
////            NewsModel * contentModel = [[NewsModel alloc] init];
//            // 2.创建HTML解释器
//            TFHpple *xpathparser = [[TFHpple alloc]initWithHTMLData:data];
//            // 3.解释对应HTML标签
//
//            /*
//             <a href="info/1073/16792.htm" tabindex="-1">
//                 <div class="img slow img_zd">
//                     <div class="img_hezi"></div>
//                    <img src="/__local/B/6E/C6/C4D38707CD269366AEDCB4DF009_DE92BD47_1648F.jpg">
//                 </div>
//                 <div class="top">
//                     <div class="time">
//                     </div>
//                     <div class="con">
//                         <h5 class="overfloat-dot">王敦球校长带队慰问春节期间坚守岗位的教职员工</h5>
//                     </div>
//                 </div>
//             </a>
//             */
//            /// <div class="miso-track" role="listbox" style="opacity: 1; width: 2750px;">
//            /// //*[@id="page1"]/div/div/div[1]/ul/div[2]/div/li[1]/a
//            NSArray *zzsc = [xpathparser searchWithXPathQuery:@"//div[@class='miso-track']/li"];
//
//            NSMutableArray * imageArr = [NSMutableArray array];
//            NSMutableArray * contentsArr = [NSMutableArray array];
//            for (TFHppleElement * element in zzsc) {
//                [contentsArr addObject:[@"https://www.glut.edu.cn/" stringByAppendingString:[element objectForKey:@"href"]]];
//                NSString * imageurl = (NSString *) [[[[element.raw componentsSeparatedByString:@"rc=\""] objectAtIndex:1] componentsSeparatedByString:@"\""] objectAtIndex:0];
//                [imageArr addObject:[@"https://www.glut.edu.cn" stringByAppendingString:imageurl]];
//            }
//
//            NSMutableArray * contentArray = [NSMutableArray arrayWithObjects:imageArr,contentsArr, nil];
//
//            success(contentArray);
//        });
//    }];
//
//
//
//    //执行Task
//    //注意：刚创建出来的task默认是挂起状态的，需要调用该方法来启动任务（执行任务）
//    [dataTask resume];
//    
    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectZero];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            [webView loadRequest:request];
       });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (!webView.isLoading) {
            
            [self fetchImagesWithWeb:webView success:success];
        }
        else
        {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    if (!webView.isLoading) {
                        
                         [self fetchImagesWithWeb:webView success:success];
                        
                    }
                    else
                    {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            if (!webView.isLoading) {
                                
                                 [self fetchImagesWithWeb:webView success:success];
                            }
                            else
                            {
                                failure(nil);
                            
                            }
                            
                        });
                    }
                });
        }
    });
}

- (void)fetchImagesWithWeb:(UIWebView *)webView success:(void (^)(NSArray *fetchImagesArray))success
{

    
    NSString *Js = @"document.body.innerHTML";
    NSString *dataString = [webView stringByEvaluatingJavaScriptFromString:Js];
    
    //NSString *urlString =@"http://www.glut.edu.cn/Git/View.asp?ArticleID=12102";
    //NSString *urlString =@"http://www.glut.edu.cn/Git/Index.asp";
    
    //NSData *htmlData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:urlString]];
    
//    return;
    
    if (!dataString.length)
    {
        NSLog(@"主页图片数据为空！");
        return;
    }
    
    NSData * data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *xpathparser = [[TFHpple alloc]initWithHTMLData:data];
    
    /*
     <a href="info/1073/16792.htm" tabindex="-1">
         <div class="img slow img_zd">
             <div class="img_hezi"></div>
            <img src="/__local/B/6E/C6/C4D38707CD269366AEDCB4DF009_DE92BD47_1648F.jpg">
         </div>
         <div class="top">
             <div class="time">
             </div>
             <div class="con">
                 <h5 class="overfloat-dot">王敦球校长带队慰问春节期间坚守岗位的教职员工</h5>
             </div>
         </div>
     </a>
     */
    /// <div class="miso-track" role="listbox" style="opacity: 1; width: 2750px;">
    /// //*[@id="page1"]/div/div/div[1]/ul/div[2]/div/li[1]/a
    NSArray *elements  = [xpathparser searchWithXPathQuery:@"//div[@class='miso-track']/li/a"];
    
    //从数据中分段
    
    NSMutableArray * imageArr = [NSMutableArray array];
    NSMutableArray * contentsArr = [NSMutableArray array];
    for (TFHppleElement * element in elements) {
        NSString * href = [element objectForKey:@"href"];
        if ([href hasPrefix:@"http"]) {
            [contentsArr addObject:href];
        } else {
            [contentsArr addObject:[@"https://www.glut.edu.cn/" stringByAppendingString:href]];
        }
        NSString * imageurl = (NSString *) [[[[element.raw componentsSeparatedByString:@"rc=\""] objectAtIndex:1] componentsSeparatedByString:@"\""] objectAtIndex:0];
        if (![imageurl hasPrefix:@"/"]) {
            continue;
        }
        if ([imageurl hasPrefix:@"http"]) {
            [imageArr addObject:imageurl];
        } else {
            [imageArr addObject:[@"https://www.glut.edu.cn" stringByAppendingString:imageurl]];
        }
    }
//    NSLog(@"imageArr --- %d", imageArr.count);
//    NSLog(@"imageArr --- %@", imageArr);
    NSMutableArray * contentArray = [NSMutableArray arrayWithObjects:imageArr,contentsArr, nil];
    
    success(contentArray);
    
}


//获取新闻体
- (void)getContentsWithURL:(NSString *)url success:(void (^)(NewsModel *newsContentsModel))success failure:(void (^)(NSError *error))failure
{

    //self.mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //创建NSURLSession对象（可以获取单例对象）
    NSURLSession *session = [NSURLSession sharedSession];
    //根据NSURLSession对象创建一个Task
    NSURLSessionDataTask * dataTask =  [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {

        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error || !data) {
                failure(error);
                //NSLog(@"error");
                return;
            }
        
        // 1.新闻内容模型
        NewsModel * contentModel = [[NewsModel alloc]init];
        // 2.创建HTML解释器
        TFHpple *xpathparser = [[TFHpple alloc]initWithHTMLData:data];
        // 3.解释对应HTML标签
        
        // 文章标题
        /* <div class="nav01">
            <h3>2022年度国家自然科学基金桂林联络网管理工作会顺利召开</h3>
            <h6>
                <span>来源：科技处
</span>
                <span>作者：候笑娜</span>
                <span>发布时间：2023-01-16</span>
                <span>浏览次数：<script>_showDynClicks("wbnews", 1860243556, 16788)</script><span id="dynclicks_wbnews_16788_861" name="dynclicks_wbnews_16788_861">425</span></span>
            </h6>
        </div>
         */
        // /html/body/section/section[6]/div[2]/div[2]/section/div/form/div[1]
        NSArray *article_title = [xpathparser searchWithXPathQuery:@"//div[@class='nav01']/h3"];
        // 其它子域名页面
        if (article_title.count == 0) {
            // https://zcglc.glut.edu.cn/info/1192/2910.htm
            // /html/body/div[3]/div[2]/div/div[2]/div[1]/div[1]/h1
            article_title = [xpathparser searchWithXPathQuery:@"//div[@class='showMaintops']/h1"];
        }
        if (article_title.count == 0) {
            // https://gj.glut.edu.cn/info/1008/3083.htm
            // /html/body/div/table[4]/tbody/tr[1]/td[2]/table[3]/tbody/tr/td/form/table/tbody/tr[1]/td
            article_title = [xpathparser searchWithXPathQuery:@"//td[@class='titlestyle18089']"];
        }
        if (article_title.count == 0) {
            // https://hqjt.glut.edu.cn/info/1021/3164.htm
            // /html/body/center/table[4]/tbody/tr/td/form/div/h2
            article_title = [xpathparser searchWithXPathQuery:@"//form[@name='_newscontent_fromname']/div/h2"];
        }
        
        if (article_title.count) {
            TFHppleElement * element = article_title.firstObject;
            contentModel.title = element.text;
        }
        
        /// 来源
        NSArray *article_source = [xpathparser searchWithXPathQuery:@"//div[@class='nav01']/h6"];
        if (article_source.count == 0) {
            // /html/body/div[3]/div[2]/div/div[2]/div[1]/div[1]/div
            article_source = [xpathparser searchWithXPathQuery:@"//div[@class='titls fs3 fc10']"];
        }
            
        if (article_source.count == 0) {
            // https://gj.glut.edu.cn/info/1008/3078.htm
            // /html/body/div/table[4]/tbody/tr[1]/td[2]/table[3]/tbody/tr/td/form/table/tbody/tr[2]/td/span[1]
            TFHppleElement *times = [[xpathparser searchWithXPathQuery:@"//span[@class='timestyle18089']"] firstObject];
            TFHppleElement *authors = [[xpathparser searchWithXPathQuery:@"//span[@class='authorstyle18089']"] firstObject];
            if (times) {
                contentModel.time = times.content;
            }
            if (authors) {
                contentModel.author = authors.content;
            }
        }
        
        if (article_source.count == 0) {
            // https://hqjt.glut.edu.cn/info/1021/3164.htm
            // /html/body/center/table[4]/tbody/tr/td/form/div/div/p[1]
            article_source = [xpathparser searchWithXPathQuery:@"//form[@name='_newscontent_fromname']/div/div/p"];
        }
            
        if (article_source.count) {
            TFHppleElement * element = article_source.firstObject;
            NSString * content = element.content;
            @try {
                NSString * source = (NSString *) [[[[content componentsSeparatedByString:@"源："] objectAtIndex:1] componentsSeparatedByString:@"\r"] objectAtIndex:0];
                NSString * author = (NSString *) [[[[content componentsSeparatedByString:@"者："] objectAtIndex:1] componentsSeparatedByString:@"\r"] objectAtIndex:0];
                NSString * time = (NSString *) [[[[content componentsSeparatedByString:@"间："] objectAtIndex:1] componentsSeparatedByString:@"\r"] objectAtIndex:0];
                NSString * enter_man = nil;
                //公告无录入人
                if ([content containsString:@"编辑："])
                {
                    enter_man = (NSString *) [[[[content componentsSeparatedByString:@"编辑："] objectAtIndex:1] componentsSeparatedByString:@"\r"] objectAtIndex:0];
                }
                contentModel.source = source;
                contentModel.author = author;
                contentModel.clickNum = @"1";
                contentModel.time = time;
                contentModel.enter_men = enter_man;
            } @catch (NSException *exception) {
                @try {
                    NSString * source = nil;
                    NSString * author = nil;
                    NSString * time = nil;
                    NSString * enter_man = nil;
                    //如果为空，在判断一次
                    if ([content componentsSeparatedByString:@"源："].count > 1) {
                        source = (NSString *) [[[[content componentsSeparatedByString:@"源："] objectAtIndex:1] componentsSeparatedByString:@" "] objectAtIndex:0];
                    }
                    if ([content componentsSeparatedByString:@"者："].count > 1) {
                        author = (NSString *) [[[[content componentsSeparatedByString:@"者："] objectAtIndex:1] componentsSeparatedByString:@" "] objectAtIndex:0];
                    }
                    if ([content componentsSeparatedByString:@"间："].count > 1) {
                        time = (NSString *) [[[[content componentsSeparatedByString:@"间："] objectAtIndex:1] componentsSeparatedByString:@" "] objectAtIndex:0];
                    }
                    if ([content componentsSeparatedByString:@"期："].count > 1) {
                        time = (NSString *) [[[[content componentsSeparatedByString:@"期："] objectAtIndex:1] componentsSeparatedByString:@" "] objectAtIndex:0];
                    }
                    contentModel.source = source;
                    contentModel.author = author;
                    contentModel.clickNum = @"1";
                    contentModel.time = time;
                    contentModel.enter_men = enter_man;
                } @catch (NSException *exception) {
                    contentModel.source = @"未知";
                    contentModel.author = @"未知";
                    contentModel.clickNum = @"1";
                    contentModel.time = @"未知";
                } @finally {
                    
                }
            } @finally {
                
            }

        }
        
        // 文章正文
        // //*[@id="vsb_content"]/div/p[1]
        // //*[@id="vsb_content"]/div
        NSArray *elements  = [xpathparser searchWithXPathQuery:@"//*[@id='vsb_content']/div"];
        @try {
            if (!elements.count){
                // 可能没有嵌套多层的 //*[@id="vsb_content"]  /html/body/div/div/div[2]/div[2]/form/div/div/div[1]
                elements  = [xpathparser searchWithXPathQuery:@"//div[@class='WordSection1']/"];
            }
        } @catch (NSException *exception) {
            @try {
                ////*[@id="vsb_content"]/div/table/tbody/tr/td
                NSArray *elements  = [xpathparser searchWithXPathQuery:@"//div[@class='v_news_content']/p"];
                if (!elements.count){
                    // 可能没有嵌套多层的
                    elements  = [xpathparser searchWithXPathQuery:@"//div[@class='WordSection1']/p"];
                }
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        } @finally {
            TFHppleElement * element = elements.firstObject;
            if (element) {
                elements = element.children;
            }
        }
            
        
        NSMutableArray * imagesArray = [NSMutableArray array];
        NSMutableArray * contentsArray = [NSMutableArray array];
        BOOL isImage = NO;
        
        for (int i = 0; i < elements.count; i++){
            TFHppleElement * element = elements[i];
            NSString *content = element.content;
            if(!content.length || ![content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length){
                // 长度为空或空格的可能是是照片
                NSString * imageurl;
                BOOL isExce = NO;
                @try {
                      imageurl = (NSString *) [[[[element.raw componentsSeparatedByString:@"rc=\""] objectAtIndex:1] componentsSeparatedByString:@"\""] objectAtIndex:0];
                }@catch (NSException *exception) {
                       isExce = YES;
                }@finally {
                    
                }
                
                if (!isExce && imageurl) {
                    if (isImage) {
                        // 无题照片
                        [imagesArray addObject:@""];
                    }
                    [imagesArray addObject:[@"https://www.glut.edu.cn" stringByAppendingString:imageurl]];
                    isImage = YES;
                }
            
            }else if (isImage){
                // 如果有 text-align: center，才认为是图片的标注
                if ([element.raw containsString:@"text-align: center"]) {
                    [imagesArray addObject:element.content];
                } else {
                    [imagesArray addObject:@""];
                    [contentsArray addObject:element.content];
                }
                isImage = NO;
            
            }else{
                [contentsArray addObject:element.content];
            }
        }
        
        contentModel.images = imagesArray;
        contentModel.contents = contentsArray;
        
            success(contentModel);
        });
    }];

        
    //执行Task
    //注意：刚创建出来的task默认是挂起状态的，需要调用该方法来启动任务（执行任务）
    [dataTask resume];

}


+ (NSString *)safetyString:(NSString *)string
{
    //去掉所有换行
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //去掉所有空格
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return string;
}




@end



