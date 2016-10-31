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
@property (nonatomic, strong) AFHTTPSessionManager * mgr;
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
            self.mgr = [AFHTTPSessionManager manager];
            self.mgr.requestSerializer.timeoutInterval = 8;
            self.mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
            self.mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",@"text/javascript", nil];
            //
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


- (void)getNewsListDataWithClassName:(NSString *)name page:(int)page success:(void (^)(NSArray *fetchNewsArray ,int nextPage))success failure:(void (^)(NSError *error))failure
{
    NSMutableArray * contentArray = [NSMutableArray array];
    
    //self.mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    /** 教学科研
     *  http://www.glut.edu.cn/Git/more.asp?BigClassName=%BD%CC%D1%A7%BF%C6%D1%D0&SmallClassName=&SpecialName=&page=2
     */
    
    /** 新闻中心 >> 桂工要闻
     *  http://www.glut.edu.cn/Git/more.asp?BigClassName=%D0%C2%CE%C5%D6%D0%D0%C4&SmallClassName=%B9%F0%B9%A4%D2%AA%CE%C5&SpecialName=&page=2
     */
    
    /**  公告
     *  http://www.glut.edu.cn/Git/Anc_more.asp?BigClassName=%B9%AB%B8%E6&SmallClassName=&SpecialName=&page=2
     */
    
    NSString * url;
    
    if ([name isEqualToString:@"教学科研"])
    {
        if (page==0) {
            url = @"http://www.glut.edu.cn/index/kjdt.htm";
        }else{
           url = [NSString stringWithFormat:@"http://www.glut.edu.cn/index/kjdt/%d.htm",page];
        }
        
        // url = @"http://www.glut.edu.cn/index/kjdt.htm";
        // http://www.glut.edu.cn/index/kjdt/1.htm
        //url = [NSString stringWithFormat:@"http://www.glut.edu.cn/Git/More.asp?BigClassName=%@&SmallClassName=&page=%d",name,page];
    }
    else if([name isEqualToString:@"新闻中心"])
    {
        if (page==0) {
            url = @"http://www.glut.edu.cn/index/ggyw.htm";
        }else{
            url = [NSString stringWithFormat:@"http://www.glut.edu.cn/index/ggyw/%d.htm",page];
        }
        //url  = @"http://www.glut.edu.cn/index/ggyw.htm";
        //url = [NSString stringWithFormat:@"http://www.glut.edu.cn/Git/More.asp?BigClassName=%@&SmallClassName=%@&page=%d",name,@"桂工要闻",page];
    }
    else if([name isEqualToString:@"公告"])
    {
        if (page==0) {
            url = @"http://www.glut.edu.cn/index/tzgg.htm";
        }else{
            url = [NSString stringWithFormat:@"http://www.glut.edu.cn/index/tzgg/%d.htm",page];
        }
        //url = @"http://www.glut.edu.cn/index/tzgg.htm";
        //url = [NSString stringWithFormat:@"http://www.glut.edu.cn/Git/Anc_more.asp?BigClassName=%@&SmallClassName=&page=%d",name,page];
    }
    
//    NSLog(@" --- %@",url);
    
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString* encodedString = [url stringByAddingPercentEscapesUsingEncoding:gbkEncoding];
    
    [self.mgr GET:encodedString parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        /*
         <div class="list_content">
         <ul>
         <li id="line_u8_0">
         <a href="../info/1109/25667.htm" target="_blank" title="《桂林日报》报道我校老红军柳林同志：百年征程情怀不减　淡泊从容安度晚年">《桂林日报》报道我校老红军柳林同志：百年征程情怀不减　淡泊从容安度晚年</a>
         <p>2016-10-20</p>
         </li>
         
         */
        
        TFHpple *xpathparser = [[TFHpple alloc]initWithHTMLData:responseObject];
        NSArray *elements  = [xpathparser searchWithXPathQuery:@"//div[@class='list_content']/ul/li"];
        
        for (int i = 0; i < elements.count; i++)
        {
            TFHppleElement * element = [elements objectAtIndex:i];
            
            //NSArray *aValue = [element childrenWithTagName:@"a"];
            //NSArray *aValue = [element searchWithXPathQuery:@"//a"];
            //TFHppleElement * aElement = aValue.firstObject;
            
            TFHppleElement * aElement = [element firstChildWithTagName:@"a"];
            NSString * href = [aElement objectForKey:@"href"];
            NSString * title = [aElement objectForKey:@"title"];
            
            
            TFHppleElement * pElement = [element firstChildWithTagName:@"p"];
            NSString * time = pElement.text;
            

            NewsModel * news = [[NewsModel alloc]init];
            news.title = title;
//            news.author = @"";
//            news.clickNum = @"1";
            news.time = time;
            // href	__NSCFString *	@"../info/1107/25711.htm" h ttp://www.glut.edu.cn/info/1108/25714.htm
            if (page == 0) {
                news.url = [href stringByReplacingOccurrencesOfString:@"../" withString:@"http://www.glut.edu.cn/"];
            }else{
                // ../../info/1110/25395.htm
                news.url = [href stringByReplacingOccurrencesOfString:@"../../" withString:@"http://www.glut.edu.cn/"];
            }
           
            
            [contentArray addObject:news];
            
        }
        
        
        // 查找剩下页数
        int nextPage = 0;
        NSArray *pageElements  = [xpathparser searchWithXPathQuery:@"//a[@class='Next']"];
        if (pageElements.count) {
            TFHppleElement * aElement = pageElements.firstObject;
            // href="kjdt/82.htm"
            NSString * href = [aElement objectForKey:@"href"];
            if (page == 0) {
                NSString * page = (NSString *) [[[[href componentsSeparatedByString:@"/"] objectAtIndex:1] componentsSeparatedByString:@".htm"] objectAtIndex:0];
                nextPage = [page intValue];
            }else{// href="80.htm"
                NSString * page = (NSString *) [[href componentsSeparatedByString:@".htm"] objectAtIndex:0];
                nextPage = [page intValue];
            }
            
        }
      
        success(contentArray, nextPage);
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        failure(error);
        //NSLog(@"error");
    }];
    
}


- (void)getFocusImagesSuccess:(void (^)(NSArray *fetchImagesArray))success failure:(void (^)(NSError *error))failure
{
    
    
    [self.mgr GET:@"http://www.glut.edu.cn" parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        // 1.新闻内容模型
        NewsModel * contentModel = [[NewsModel alloc]init];
        // 2.创建HTML解释器
        TFHpple *xpathparser = [[TFHpple alloc]initWithHTMLData:responseObject];
        // 3.解释对应HTML标签
        
        /* <div id="zzsc" style="position: relative; background-image: url(http://www.glut.edu.cn/__local/B/BA/BE/A736DA98E29C6B08979DE8C6C54_2F62540B_315DD.jpg);">
        <a href="info/1107/25656.htm" target="_blank" title="【两学一做】学校“两学一做”学习教育知识抢答赛举行" style="z-index: 999; display: none;">*/
        
        NSArray *zzsc = [xpathparser searchWithXPathQuery:@"//div[@id='zzsc']/a"];
        
        NSMutableArray * imageArr = [NSMutableArray array];
        NSMutableArray * contentsArr = [NSMutableArray array];
        for (TFHppleElement * element in zzsc) {
            [contentsArr addObject:[@"http://www.glut.edu.cn/" stringByAppendingString:[element objectForKey:@"href"]]];
            NSString * imageurl = (NSString *) [[[[element.raw componentsSeparatedByString:@"rc=\""] objectAtIndex:1] componentsSeparatedByString:@"\""] objectAtIndex:0];
            [imageArr addObject:[@"http://www.glut.edu.cn" stringByAppendingString:imageurl]];
        }
        
        NSMutableArray * contentArray = [NSMutableArray arrayWithObjects:imageArr,contentsArr, nil];
        
        success(contentArray);
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        failure(error);
        NSLog(@"error");
    }];

//    
//    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectZero];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://www.glut.edu.cn/Git/Index.asp"]]]];
//       });
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        if (!webView.isLoading) {
//            
//            [self fetchImagesWithWeb:webView success:success];
//        }
//        else
//        {
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    
//                    
//                    if (!webView.isLoading) {
//                        
//                         [self fetchImagesWithWeb:webView success:success];
//                        
//                    }
//                    else
//                    {
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            
//                            
//                            if (!webView.isLoading) {
//                                
//                                 [self fetchImagesWithWeb:webView success:success];
//                                
//                            }
//                            else
//                            {
//                            
//                                failure(nil);
//                            
//                            }
//                            
//                            
//                        });
//                        
//                    }
//                    
//                });
//        
//        }
//    
//    
//    });
//        
//
}

- (void)fetchImagesWithWeb:(UIWebView *)webView success:(void (^)(NSArray *fetchImagesArray))success
{

    
    NSString *Js = @"document.body.innerHTML";
    NSString *dataString = [webView stringByEvaluatingJavaScriptFromString:Js];
    
    //NSString *urlString =@"http://www.glut.edu.cn/Git/View.asp?ArticleID=12102";
    //NSString *urlString =@"http://www.glut.edu.cn/Git/Index.asp";
    
    //NSData *htmlData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:urlString]];
    
    return;
    
    if (!dataString.length)
    {
        NSLog(@"广告数据为空！");
        return;
    }
    
    NSData * data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *xpathparser = [[TFHpple alloc]initWithHTMLData:data];
    NSArray *elements  = [xpathparser searchWithXPathQuery:@"//param[@name='FlashVars']"];
    
    /*
     dataString	__NSCFString *	@" \n\t<table width=\"100%\" height=\"100%\">\n    \t<tbody><tr height=\"10%\">\n    \t\t<td></td>\n    \t</tr>\n    \t<tr>\n    \t\t<td valign=\"top\" align=\"center\">\n    \t\t\t<div class=\"prompt\">\n\t\t            <div class=\"prompt_up\"><strong>404错误提示</strong></div>\n\t\t            <div class=\"prompt_down\">\n\t\t              <div class=\"pd_text\">页面没有找到!</div>\n\t\t            </div>\n\t\t          </div>\n    \t\t</td>\n    \t</tr>\n\t</tbody></table>\n\n\n"	0x0000000102f8e350
    */
    
    //raw = \"<param name=\\\"FlashVars\\\" value=\\\"pic s= UpdateFiles/2015/2015112232753485.jpg|UpdateFiles/2014/20141226215745614.jpg|UpdateFiles/2014/20141127201815543.jpg|UpdateFiles/2014/20141113104340213.jpg|UpdateFiles/2014/20141029162043925.jpg&amp;link s= View.asp?ArticleID=12052|View.asp?ArticleID=11999|View.asp?ArticleID=11915|View.asp?ArticleID=11875|View.asp?ArticleID=11829&amp;text s= &amp;borderwidth=300&amp;borderheight=200&amp;textheight=0\\\"/>\";\n}",
    
    //从数据中分段
    
    //教学科研
    TFHppleElement *element1 = [elements objectAtIndex:0];
    NSString * str1 = element1.raw;
    
    NSArray * arry1 = [str1 componentsSeparatedByString:@"s="];
    
     //图片url
    NSArray * arry12 = [arry1[1] componentsSeparatedByString:@"&"];
    NSArray *imagesURL1 = [arry12[0] componentsSeparatedByString:@"|"];
    //连接url
    NSArray * arry13 = [arry1[2] componentsSeparatedByString:@"&"];
    NSArray *contentsURL1 = [arry13[0] componentsSeparatedByString:@"|"];
    
    
    NSMutableArray * imageArr1 = [NSMutableArray array];
    for (NSString * url in imagesURL1) {
        
        NSString * image = [NSString stringWithFormat:@"http://www.glut.edu.cn/Git/%@",url];
        
        [imageArr1 addObject:image];
    }

    NSMutableArray * contentsArr1 = [NSMutableArray array];
    for (NSString * url in contentsURL1) {
        
        NSString * contents = [NSString stringWithFormat:@"http://www.glut.edu.cn/Git/%@",url];
        
        [contentsArr1 addObject:contents];
    }
    
    BOOL isExce = NO;
    NSArray *imagesURL2;
    NSArray *contentsURL2;
    //新闻中心/桂工要闻
    @try {

    TFHppleElement *element2 = [elements objectAtIndex:1];
    NSString * str2 = element2.raw;
    
    NSArray * arry22 = [str2 componentsSeparatedByString:@"s="];
    
    //图片url
    NSArray * arry23 = [arry22[1] componentsSeparatedByString:@"&"];
    imagesURL2 = [arry23[0] componentsSeparatedByString:@"|"];
    //连接url
    NSArray * arry24 = [arry22[2] componentsSeparatedByString:@"&"];
    contentsURL2 = [arry24[0] componentsSeparatedByString:@"|"];
    
  }

    @catch (NSException *exception) {
        isExce = YES;
    }
    @finally {
        
    }
    
    if (isExce) {//有异常直接返回
        return;
    }
    NSMutableArray * imageArr2 = [NSMutableArray array];
    for (NSString * url in imagesURL2) {
        
        NSString * image = [NSString stringWithFormat:@"http://www.glut.edu.cn/Git/%@",url];
        
        [imageArr2 addObject:image];
    }
    
    NSMutableArray * contentsArr2 = [NSMutableArray array];
    for (NSString * url in contentsURL2) {
        
        NSString * contents = [NSString stringWithFormat:@"http://www.glut.edu.cn/Git/%@",url];
        
        [contentsArr2 addObject:contents];
    }
    
    NSMutableArray * contentArray = [NSMutableArray arrayWithObjects:imageArr1,contentsArr1,imageArr2,contentsArr2, nil];
    
    success(contentArray);
    
}


//获取新闻体
- (void)getContentsWithURL:(NSString *)url success:(void (^)(NewsModel *newsContentsModel))success failure:(void (^)(NSError *error))failure
{

    //self.mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self.mgr GET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        // 1.新闻内容模型
        NewsModel * contentModel = [[NewsModel alloc]init];
        // 2.创建HTML解释器
        TFHpple *xpathparser = [[TFHpple alloc]initWithHTMLData:responseObject];
        // 3.解释对应HTML标签
        
        // <h1 class="article_title">香港中港生态环境顾问公司董事佘书生博士应邀做客桂工讲坛</h1>
        NSArray *article_title = [xpathparser searchWithXPathQuery:@"//h1[@class='article_title']"];
        if (article_title.count) {
            TFHppleElement * element = article_title.firstObject;
            contentModel.title = element.text;
        }
        
        /*
         <p class="article_source">来源：环境科学与工程学院   作者：黄亮亮、谢永雄  发布时间：<span>2016-10-26</span>
         */
        NSArray *article_source = [xpathparser searchWithXPathQuery:@"//p[@class='article_source']"];
        if (article_source.count) {
            TFHppleElement * element = article_source.firstObject;
            NSString * source = (NSString *) [[[[element.text componentsSeparatedByString:@"源："] objectAtIndex:1] componentsSeparatedByString:@" "] objectAtIndex:0];
            NSString * author = (NSString *) [[[[element.text componentsSeparatedByString:@"者："] objectAtIndex:1] componentsSeparatedByString:@" "] objectAtIndex:0];
            contentModel.source = source;
            contentModel.author = author;
            contentModel.clickNum = @"1";
            TFHppleElement * time = [element firstChildWithTagName:@"span"];
            contentModel.time = time.text;
        }
        
        NSArray *elements  = [xpathparser searchWithXPathQuery:@"//td[@class='border01']/p"];
        if (!elements.count){
            // 可能没有嵌套多层的
            elements  = [xpathparser searchWithXPathQuery:@"//div[@class='article_paragraph']/p"];
            if (!elements.count){
                failure(nil);
                return ;
            }
        }
        
        NSMutableArray * imagesArray = [NSMutableArray array];
        NSMutableArray * contentsArray = [NSMutableArray array];
        BOOL isImage = NO;
        
        for (int i = 0; i < elements.count; i++){
            TFHppleElement * element = elements[i];
            if (i == 0) {
                // 过滤标题
                //contentModel.title = element.content;
            }else if(!element.content.length || ![element.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length){
                // 长度为空或空格的可能是是照片
                NSString * imageurl;
                BOOL isExce = NO;
                @try {
                      imageurl = (NSString *) [[[[element.raw componentsSeparatedByString:@"rc=\""] objectAtIndex:1] componentsSeparatedByString:@"\""] objectAtIndex:0];
                }@catch (NSException *exception) {
                       isExce = YES;
                }@finally {
                    
                }
                
                if (!isExce) {
                    [imagesArray addObject:[@"http://www.glut.edu.cn" stringByAppendingString:imageurl]];
                    isImage = YES;
                }
            
            }else if (isImage){
                [imagesArray addObject:element.content];
                 isImage = NO;
            
            }else{
                [contentsArray addObject:element.content];
            }
        }
        
        contentModel.images = imagesArray;
        contentModel.contents = contentsArray;
        
        success(contentModel);
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        failure(error);
        NSLog(@"error");
    }];

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



