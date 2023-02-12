//
//  BaseWebViewController.m
//  CampusOfGLUt
//
//  Created by HTC on 15/2/13.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "BaseWebViewController.h"
#import "JDStatusBarNotification.h"
#import "NewsModel.h"
#import "FetchNewsDataTool.h"
#import "NewsCacheTool.h"
#import "TFHpple.h"
#import "MWPhotoBrowser.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SDImageCache.h"
#import "MWCommon.h"
#import "TOWebViewController.h"
#import "WeiboSDKTool.h"
#import "WeixinSDKTool.h"
#import "ShareActivityView.h"
#import "ImageUtilityTool.h"
#import "InformationHandleTool.h"
#import "QQSDKTool.h"
#import "CRToastTool.h"

#import "BaiduMobStat.h"

static NSString *const customWebStyle = @"customWebStyle";

@interface BaseWebViewController ()<UIWebViewDelegate,MWPhotoBrowserDelegate>

@property (nonatomic, strong) UIWebView * webView;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, strong) NewsModel * newsModel;

//网页图片浏览器的图片容器
@property (nonatomic, strong) NSMutableArray *photos;

//分享视图
@property (nonatomic, strong) ShareActivityView *shareView;

//info单例
@property (nonatomic, strong) InformationHandleTool *shareInfoTool;

//网页HTML代码
@property (nonatomic, copy) NSString * pageHTML;
@property (nonatomic, copy) NSString * pageContents;

@end

@implementation BaseWebViewController

// 进入页面，建议在此处添加
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString* cName = [NSString stringWithFormat:@"%@",  self.title, nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
}

// 退出页面，建议在此处添加
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self hideProgress];
    self.webView = nil;
    
    NSString* cName = [NSString stringWithFormat:@"%@", self.title, nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置浏览器背影
    [self settingBackground];
    
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.webView];
    self.webView.dataDetectorTypes = UIDataDetectorTypeLink;
    self.webView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.delegate = self;
    
    self.webView.opaque = YES;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scrollView.backgroundColor = [UIColor clearColor];
//    if (@available(iOS 11.0, *)) {
//        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
    
    self.shareInfoTool = [InformationHandleTool sharedInfoTool];

    //设置加载进度条的形式
    [self setJDStatusBarNotification];
    
    
    if(self.contentStr.length)
    {
        self.webView.scalesPageToFit = YES;
        
        if (![self.contentStr hasPrefix:@"http"])
        {
//            NSString * html = [NSString stringWithFormat:@"<html> \n <head> \n<style type=\"text/css\">body {font-family: \"%@\"; font-size: %d; color: %@;}</style> \n </head> \n <body>%@</body> \n </html>", @"宋体",60,@"#000",self.contentStr];
//        
//            [self.webView loadHTMLString:html baseURL:nil];
            
            NSData * textData = [self.contentStr dataUsingEncoding:NSUTF8StringEncoding];
            
            [self.webView loadData:textData MIMEType:@"text/plain" textEncodingName:@"utf-8" baseURL:[NSURL URLWithString:@""]];
        }
    }else if (self.articleURL.length){
        //直接网上加载
        [self fetchNews];
        
//        //如果数据库现在处理操作，就到网络去请求，不查询数据库是否存储，从而避免主线程等待引起阻塞
//        if ([NewsCacheTool currentExecuteCounts])
//        {
//            [self fetchNews];
//        }
//        else
//        {
//            //查询数据库，如果有数据就直接显示
//            NewsModel * news = [NewsCacheTool queryWithURL:self.articleURL];
//            if (news)
//            {
//                 self.newsModel = news;
//                 [self setHTML];
//            }
//            else
//            {
//                [self fetchNews];
//            
//            }
//        }

    }
    
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationbar_more"] style:UIBarButtonItemStylePlain target:self action:@selector(showShareView)];
    
    self.navigationItem.rightBarButtonItem = rightBtn;
}


- (void)settingBackground
{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 70)];
    label.numberOfLines = 2;
    label.text = @"网页由 桂林理工大学-校园通 转码\n以便在移动设备上浏览";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithRed:0.192 green:0.518 blue:0.984 alpha:1.000];
    label.textAlignment = NSTextAlignmentCenter;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:label];
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 70)];
    label2.numberOfLines = 2;
    label2.text = @"网页由 桂林理工大学-校园通 转码\n以便在移动设备上浏览";
    label2.font = [UIFont systemFontOfSize:13];
    label2.textColor = [UIColor colorWithRed:0.192 green:0.518 blue:0.984 alpha:1.000];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:label2];
    self.view.backgroundColor = [UIColor colorWithWhite:0.200 alpha:1.000];
}


- (void)fetchNews
{
        FetchNewsTool * tool = [FetchNewsTool sharedFetchNewsTool];
        self.webView.scalesPageToFit = NO;

        [tool getContentsWithURL:self.articleURL success:^(NewsModel *newsContentsModel) {
            
            self.newsModel = newsContentsModel;
            
            [self setHTML];
            
            
        } failure:^(NSError *error) {
            [self.navigationController popViewControllerAnimated:NO];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.articleURL]]];
            
//            NSLog(@"%@",error.description);
        }];
}

- (void)setHTML
{
    NSString * path;
    NSInteger imageHight;
 
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        path= [[NSBundle mainBundle] pathForResource:@"iPhoneNews_template.html" ofType:nil];
        imageHight = 220;
    }
    else
    {
        path = [[NSBundle mainBundle] pathForResource:@"iPadNews_template.html" ofType:nil];
    
        imageHight = 480;
    }

   // self.title = self.newsModel.title?self.newsModel.title:@"";
    NSString * html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    if (self.newsModel.title) {
        
        self.title = self.newsModel.title;  
        html = [html stringByReplacingOccurrencesOfString:@"${webview_title}" withString:self.newsModel.title];
    }else{
////        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
////        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
////            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.articleURL]]];
////        });
        [self.navigationController popViewControllerAnimated:NO];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.articleURL]]];
        return ;
    }
    
    NSString *subtitle = @"";
    if (self.newsModel.source) {
        subtitle = [NSString stringWithFormat:@"来源：%@ ", self.newsModel.source];
    }
    
    if (self.newsModel.author) {
        subtitle = [subtitle stringByAppendingFormat:
                    @"%@", [NSString stringWithFormat:@"%@作者：%@ ", subtitle.length>0 ? @"| " : @"", self.newsModel.author]];
    }
    
    if (self.newsModel.time) {
        subtitle = [subtitle stringByAppendingFormat:
                    @"%@", [NSString stringWithFormat:@"%@发布时间：%@ ", subtitle.length>0 ? @"| " : @"", self.newsModel.time]];
    }
    
    //来源：${webview_source} | 作者：${webview_author} | 发布时间：${webview_time}
    html = [html stringByReplacingOccurrencesOfString:@"${webview_subtitle}" withString: subtitle];
    
    NSMutableString * contentstr = [NSMutableString string];
    
    for (NSString * content in self.newsModel.contents)
    {
        NSString * contents = [NSString string];
        //检查空格，然后增加换行
        contents = [content stringByReplacingOccurrencesOfString:@"　　" withString:@"$#"];
        contents = [contents stringByReplacingOccurrencesOfString:@"  " withString:@"$#"];
        
        NSRange range2 = [contents rangeOfString:@"$#"];
        while(range2.length >0)
        {
            contents = [contents stringByReplacingOccurrencesOfString:@"$#$#" withString:@"$#"];
            range2 = [contents rangeOfString:@"$#$#"];
        }
        

        [contentstr appendFormat:@"%@</p><p>",[contents stringByReplacingOccurrencesOfString:@"$#" withString:@"</p><p>　　"]];

        
    }
    
    html = [html stringByReplacingOccurrencesOfString:@"${webview_contents}" withString:contentstr];
        
    self.pageContents = contentstr;
    
    
    NSMutableString * imagesHtml = [NSMutableString string];

    NSInteger imageCounts = self.newsModel.images.count;
    if (imageCounts > 0)
    {
        for (int i = 0; i < self.newsModel.images.count; i += 2) {
            // 可能全文只有一张回复我
            if (imageCounts == 1) {
                [imagesHtml appendString:[self getImageHTMLWithImage:self.newsModel.images[i] Title:@"" ImageHight:imageHight]];
            }
            
            if (i + 1 == imageCounts) {
                //可能由于格式原因，图片不成对出现
                [imagesHtml appendString:[self getImageHTMLWithImage:self.newsModel.images[i] Title:@"" ImageHight:imageHight]];
                break;
            }
            
            [imagesHtml appendString:[self getImageHTMLWithImage:self.newsModel.images[i] Title:self.newsModel.images[i+1] ImageHight:imageHight]];
        }
        
    }
    
    html = [html stringByReplacingOccurrencesOfString:@"${webview_images}" withString:imagesHtml];
    //}
    
//    if (!self.newsModel.contentHTML)
//    {
//        if ([NewsCacheTool currentExecuteCounts] <10)
//        {
//            //存到数据库中
//            NewsModel * cacheNews = [[NewsModel alloc]init];
//            cacheNews.url = self.articleURL;
//            cacheNews.title = self.newsModel.title;
//            cacheNews.source = self.newsModel.source;
//            cacheNews.time = self.newsModel.time;
//            cacheNews.author = self.newsModel.author;
//            cacheNews.clickNum = self.newsModel.clickNum;
//            cacheNews.enter_men = self.newsModel.enter_men;
//            cacheNews.contentHTML = contentstr;
//            cacheNews.imagesHTML = imagesHtml;
//        
//            //数据库存储操作放子线程
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                
//                [NewsCacheTool insertNewItems:[NSArray arrayWithObject:cacheNews]];
//                
//            });
//        }
//        
//    }
    
    self.pageHTML = html;

    //加载网页
    //NSString *pathUrl = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    //NSLog(@"%@",html);
    
    [self.webView loadHTMLString:html baseURL:baseURL];

}

- (NSString *)getImageHTMLWithImage:(NSString *)imagestr Title:(NSString *)title ImageHight:(NSInteger)hight
{
    //<img src="http://www.glut.edu.cn/Git/UpdateFiles/2015/2015131153223723.jpg" width="99%" height="35%" style=" display:block; margin:0 auto;text-align:center" >
    //<p>与会人员合影</p>
    //-webkit-user-select:none; display:block; margin:auto;

    //return [NSString stringWithFormat:@"<img src=\"%@\" width=\"99%%\" height=\"35%%\" style=\" display:block; margin:0 auto;text-align:center\" ><p>%@</p>",imagestr,title];
    
    
    return [NSString stringWithFormat:@"<img src=\"%@\" width=\"99%%\" height=auto onclick=\"openIamge('%@title%@');\" \"><p>%@</p>",imagestr,imagestr,title,title];
    
    //    padding: 0;max-width: 610px;min-width: 290px;min-height: 100px;position: relative;margin: auto
    
    //return [NSString stringWithFormat:@"<img src=\"%@\" style=\" display:block; margin:0 auto;text-align:center\" ><p>%@</p>",imagestr,title];

}

#pragma mark- 分享
- (void)showShareView
{
    
    if (!self.shareView)
    {
        self.shareView = [[ShareActivityView alloc]initWithTitle:@"分享到" referView:self.view];
        
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        self.shareView.numberOfButtonPerLine = 7;

        //设置分享到网络的视图
       ButtonView *bv = [self shareToNetwork];
    
        //如果是网页新闻，则分享到全部
        if (self.articleURL)
        {
            bv = [[ButtonView alloc]initWithText:@"邮件" image:[UIImage imageNamed:@"ShareIcon_Mail"] handler:^(ButtonView *buttonView)
                  {
                      //邮件
                      [self.shareInfoTool sendEmailWithSubject:self.newsModel.title MessageBody:self.pageHTML isHTML:YES toRecipients:nil ccRecipients:nil bccRecipients:nil Image:nil imageQuality:0 Controller:self];
                  }];
            [self.shareView addButtonView:bv];
            
            bv = [[ButtonView alloc]initWithText:@"保存到相册" image:[UIImage imageNamed:@"ShareIcon_Msg"] handler:^(ButtonView *buttonView)
                  {
                      [self saveImageToPhotos:[ImageUtilityTool imageFromScrollView:self.webView.scrollView]];
                      //点击短信
//                      [self.shareInfoTool sendSMSWithBody:[NSString stringWithFormat:@"%@\n%@\n\n原文连接:%@\n【桂林理工大学-校园通】",self.newsModel.title,self.pageContents,self.articleURL] recipients:nil controller:self];
                  }];
            [self.shareView addButtonView:bv];
            
            bv = [[ButtonView alloc]initWithText:@"刷新" image:[UIImage imageNamed:@"ShareIcon_refresh"] handler:^(ButtonView *buttonView)
                  {
                      //刷新
                      [self fetchNews];
                  }];
            [self.shareView addButtonView:bv];
            
            bv = [[ButtonView alloc]initWithText:@"复制链接" image:[UIImage imageNamed:@"ShareIcon_link"] handler:^(ButtonView *buttonView)
                  {
                      //复制链接
                      UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                      pasteboard.string = self.articleURL;
                     [CRToastTool showNotificationWithTitle:@"复制成功" backgroundColor:[UIColor colorWithRed:0.251 green:0.796 blue:0.518 alpha:1.000] timeInterval:@1 completionBlock:nil];
                      
                  }];
            [self.shareView addButtonView:bv];
            
            bv = [[ButtonView alloc]initWithText:@"Safari打开" image:[UIImage imageNamed:@"ShareIcon_safari"] handler:^(ButtonView *buttonView)
                  {
                      //Safari打开
                      [self.shareInfoTool inSafariOpenWithURL:self.articleURL];
                  }];
            [self.shareView addButtonView:bv];
        }
    }
    
   [self.shareView show];
    
    
     //   NSString *str = @"document.body.innerHTML";
    //    NSString *lHtml3 = [self.webView stringByEvaluatingJavaScriptFromString:Js];
    //

    //NSString *str = @"document.getElementsByTagName('pre')[0].style.webkitTextSizeAdjust= '140%'";
//    NSString * str = @"document.body.style.fontSize= 33;";
//    
//     NSString *html = [self.webView stringByEvaluatingJavaScriptFromString:str];
//    
//     NSLog(@" ---- \n ---- \n%@  ---- \n---- \n",html);
//
    //self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    /**
     *  NSString *lJs = @"document.body.innerHTML";
     NSString *lJs = @"document.documentElement.innerHTML";
     
     
     
     */


//    
//    NSString *lJs = @"document.getElementsByTagName(\"tbody\")";
//    NSString *lJs2 = @"document.title";
//    NSString *lHtml1 = [self.webView stringByEvaluatingJavaScriptFromString:lJs];
//    NSString *lHtml2 = [self.webView stringByEvaluatingJavaScriptFromString:lJs2];
//
//    NSString *Js = @"document.body.innerHTML";
//    NSString *lHtml3 = [self.webView stringByEvaluatingJavaScriptFromString:Js];
//    
//    //NSLog(@" ---- \n ---- \n%@  ---- \n---- \n",lHtml3);
//    NSData * date = [lHtml3 dataUsingEncoding:NSUTF8StringEncoding];
//    
//    TFHpple *xpathparser = [[TFHpple alloc]initWithHTMLData:date];
//    NSArray *elements  = [xpathparser searchWithXPathQuery:@"//param[@name='FlashVars']"];
//    
//    NSLog(@"%@",elements);
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"bubble" ofType:@"html"];
//    NSError *error = nil;
//    shared_manager.bubble_pattern_htmlStr = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
//    NSString * path = [[NSBundle mainBundle] pathForResource:@"news_template.html" ofType:nil];
//    
//    NSString * html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    
//    NSString *pathUrl = [[NSBundle mainBundle] bundlePath];
//    NSURL *baseURL = [NSURL fileURLWithPath:pathUrl];
//    
//    NSLog(@"%@",html);
    
    
    
    
    //NSURLRequest * re = [NSURLRequest alloc]init
    
    //[self.webView loadHTMLString:html baseURL:baseURL];
    
}


- (void)saveImageToPhotos:(UIImage*)savedImage
{
    
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}

// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    
    NSString *msg = nil ;
    
    if(error != NULL){
        
        msg = @"保存图片失败,请检查是否有相册权限" ;
        
    }else{
        
        msg = @"保存图片成功" ;
        
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                        
                                                    message:msg
                          
                                                   delegate:self
                          
                                          cancelButtonTitle:@"确定"
                          
                                          otherButtonTitles:nil];
    [alert show];
}

- (ButtonView *)shareToNetwork
{
    ButtonView *bv = [[ButtonView alloc]initWithText:@"新浪微博" image:[UIImage imageNamed:@"ShareIcon_SinaWeibo"] handler:^(ButtonView *buttonView)
                      {
                          //新浪微博
                          [WeiboSDKTool shareToWeiboWithContent:[NSString stringWithFormat:@"%@ 详见%@",self.newsModel.title,self.articleURL] image:[ImageUtilityTool imageFromScrollView:self.webView.scrollView] media:nil];
                      }];
    [self.shareView addButtonView:bv];
    
    bv = [[ButtonView alloc]initWithText:@"微信好友" image:[UIImage imageNamed:@"ShareIcon_Weixin"] handler:^(ButtonView *buttonView)
          {
              //微信
              [WeixinSDKTool sendImageContent:[ImageUtilityTool imageFromScrollView:self.webView.scrollView] scene:WXSceneTypeSession];
          }];
    [self.shareView addButtonView:bv];
    
    bv = [[ButtonView alloc]initWithText:@"微信朋友圈" image:[UIImage imageNamed:@"ShareIcon_WeixinZone"] handler:^(ButtonView *buttonView)
          {
              //微信朋友圈
              [WeixinSDKTool sendImageContent:[ImageUtilityTool imageFromScrollView:self.webView.scrollView] scene:WXSceneTypeTimeline];
          }];
    [self.shareView addButtonView:bv];
    
    bv = [[ButtonView alloc]initWithText:@"微信收藏" image:[UIImage imageNamed:@"ShareIcon_WeixinFav"] handler:^(ButtonView *buttonView)
          {
              //微信收藏
              [WeixinSDKTool sendImageContent:[ImageUtilityTool imageFromScrollView:self.webView.scrollView] scene:WXSceneTypeFavorite];
          }];
    [self.shareView addButtonView:bv];
    
    bv = [[ButtonView alloc]initWithText:@"QQ/空间" image:[UIImage imageNamed:@"ShareIcon_QQ"] handler:^(ButtonView *buttonView)
          {
              //QQ
              [QQSDKTool shareToWeiboWithImage:[ImageUtilityTool imageFromScrollView:self.webView.scrollView] title:self.newsModel.title description:[NSString stringWithFormat:@"由【桂林理工大学-校园通】转码 本文来源:%@",self.articleURL]];

          }];

    [self.shareView addButtonView:bv];
    
    
    return bv;

}


#pragma mark- webViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //webView.request.expectedContentLength
    NSLog(@"%@",request);
    NSString *url = request.URL.absoluteString;
    if ([url hasPrefix:@"openiamge"]){

        // 截取方法名
        NSString * content = [url substringFromIndex:9];
        
        NSArray * contents = [content componentsSeparatedByString:@"title"];
        
        NSString * imageURL = contents[0];

        NSString * title = [contents[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self openPhotoBrowserWithImageURL:imageURL title:title];
        
        return NO;
        
    }
    else if([url hasPrefix:@"file"])
    {
        return YES;
        
    }
//    else if([url hasPrefix:@"about"])
//    {
//        //文本进入
//    
//        
//    }
    else if([url hasPrefix:@"http://www.glut"])
    {
        self.webView.scalesPageToFit = YES;
        return YES;
    }
    else if([url hasPrefix:@"http"])
    {

        [self openTOWebViewWithURL:url];
        return NO;
        
    }
    
    
    self.webView.scalesPageToFit = YES;
    
    //// 实现WebView的代理方法，并在此函数中调用SDK的webviewStartLoadWithRequest:传入request参数，进行统计
    [[BaiduMobStat defaultStat] webviewStartLoadWithRequest:request];

    return YES;
}


- (void)openTOWebViewWithURL:(NSString *)url
{
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    
    [self.navigationController pushViewController:webViewController animated:YES];

}


- (void)openPhotoBrowserWithImageURL:(NSString *)URL title:(NSString *)title
{
    //打开照片浏览器
    // Browser
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    
    // Photos
    photo = [MWPhoto photoWithURL:[NSURL URLWithString:URL]];
    photo.caption = title;
    [photos addObject:photo];
    
    self.photos = photos;
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:0];
    
    // Reset selections
    //        if (displaySelectionButtons) {
    //            _selections = [NSMutableArray new];
    //            for (int i = 0; i < photos.count; i++) {
    //                [_selections addObject:[NSNumber numberWithBool:NO]];
    //            }
    //        }
    
    // Show
    [self.navigationController pushViewController:browser animated:YES];
}




- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self addTimer];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self finishLoading];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

    [self stopLoading];

}





#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
//    if (index < _thumbs.count)
//        return [_thumbs objectAtIndex:index];
//    return nil;
//}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
//}

//- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
//    return [[_selections objectAtIndex:index] boolValue];
//}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
//    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
//    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
//}

//- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
//    // If we subscribe to this method we must dismiss the view controller ourselves
//    NSLog(@"Did finish modal presentation");
//    [self dismissViewControllerAnimated:YES completion:nil];
//}



#pragma mark- 定时器方法

/**
 *  添加定时器
 */
- (void)addTimer
{
    self.progress = 0.0;
    [JDStatusBarNotification showWithStatus:nil styleName:customWebStyle];
    //[JDStatusBarNotification showProgress:self.progress];
    
    /**
     CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(startTimer)];
     displayLink.frameInterval = 2;
     [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
     */
    
    CGFloat step = 0.02;
    if (!self.timer) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:step target:self
                                                    selector:@selector(startTimer)
                                                    userInfo:nil repeats:YES];
    }
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

- (void)startTimer;
{
    
    [JDStatusBarNotification showProgress:self.progress];
    
    if (self.progress < 0.3) {
        
        self.progress += 0.005;
     
    } else  if( self.progress < 0.7 )
    {
        self.progress += 0.01;
    }
     else  if( self.progress < 0.90 )
    {
        self.progress += 0.005;
    }
    else if( self.progress < 0.95)
    {
        self.progress += 0.0005;
    
    }
}


- (void)finishLoading
{
    [JDStatusBarNotification showProgress:1.0];
    [self.timer invalidate];
    self.timer = nil;
    [JDStatusBarNotification dismissAfter:0.5];
    //[self performSelector:@selector(hideProgress)
    // withObject:nil afterDelay:0.5];
}

- (void)stopLoading
{
    //[JDStatusBarNotification showProgress:1.0];
    [self.timer invalidate];
    self.timer = nil;
    //[JDStatusBarNotification dismissAfter:0.2];
    //[self performSelector:@selector(hideProgress)
              // withObject:nil afterDelay:0.5];

}

- (void)hideProgress;
{
    [self.timer invalidate];
    self.timer = nil;
    [JDStatusBarNotification dismiss];
}


- (void)dealloc
{
    [self hideProgress];
    self.webView = nil;
}


#pragma mark- DStatusBarNotificationStyle
- (void)setJDStatusBarNotification
{
        [JDStatusBarNotification addStyleNamed:customWebStyle
                                       prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
                                           style.barColor = [UIColor clearColor];
                                           style.textColor = [UIColor clearColor];
                                           style.animationType = JDStatusBarAnimationTypeNone;
                                           style.font = [UIFont systemFontOfSize:13.0];
                                           style.progressBarColor = [UIColor colorWithRed:0.126 green:0.871 blue:0.084 alpha:1.000];
                                           style.progressBarHeight = 3.0;
                                           style.progressBarPosition = JDStatusBarProgressBarPositionNavBar;
                                           return style;
                                       }];
}

@end
