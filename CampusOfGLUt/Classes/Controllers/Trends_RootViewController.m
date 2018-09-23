//
//  Trends_RootViewController.m
//  CampusOfGLUt
//
//  Created by HTC on 15/2/11.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "Trends_RootViewController.h"
#import "FocusImageView.h"
#import "TrendsViewCell.h"
#import "RDVTabBarController.h"
#import "FetchNewsDataTool.h"
#import "NewsModel.h"
#import "BaseWebViewController.h"
#import "NewsCacheTool.h"
#import "ODRefreshControl.h"
#import "CRToast.h"
#import "InformationHandleTool.h"

@interface Trends_RootViewController ()<FocusImageViewDelegate>

@property (nonatomic,strong) NSMutableArray * newsList;

//当前请求了的页数
@property (nonatomic,assign) NSInteger morePage;

//单例
@property (nonatomic,strong) FetchNewsTool *fetchNewsTool;


//@property (nonatomic,assign) UIButton *toTopBtn;
@end

@implementation Trends_RootViewController

//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    return NO;
//}

-(NSMutableArray *)newsList
{

    if (_newsList == nil)
    {
        _newsList = [NSMutableArray array];
    }
    
    return _newsList;
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.title = @"教学科研";
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.000];
    
    [self setTabBarStyle];
    
    //NSArray * imageArr = @[@"1",@"2",@"3",@"4"];
    
    [self createTableHeaderView];
    [self createTableFooterView];
    
    //加载更多的开始页数
    self.morePage = 2;
    
    //控制请求新闻数据的单例工具对象
    self.fetchNewsTool = [FetchNewsTool sharedFetchNewsTool];
    
    //查看数据库是否有数据（显示最新20条）
    NSArray * newscache = [NewsCacheTool queryWithNumber:20];
    if (newscache)
    {
        [self.newsList addObjectsFromArray:newscache];
    }
    
    [self checkUpdate];

    //上拉刷新
    [self setDropViewRefreshing];
    
    //头部照片
    [self getFocusImages];
    
    //回到首页
    //[self initTopBtn];
    
}

#pragma mark - 检查版本更新
-(void) checkUpdate{
    
    InformationHandleTool * tool = [InformationHandleTool sharedInfoTool];
    [tool checkUpdateWithAppID:@"968615456" success:^(NSDictionary *resultDic, BOOL isNewVersion, NSString *newVersion) {
        
        if (isNewVersion) {
            [self showUpdateView:newVersion];
        }
        
    } failure:^(NSError *error) {
        ;
    }];

}

- (void)showUpdateView:(NSString *)newVersion
{
    NSString *alertMsg=[[@"桂林理工大学-校园通v" stringByAppendingString:[NSString stringWithFormat:@"%0.1f",[newVersion floatValue]]] stringByAppendingString:@"，赶快体验最新版本吧！"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发现新版本" message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"稍后再说" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSString *str = @"https://itunes.apple.com/us/app/gui-lin-li-gong-da-xue-xiao/id968615456?mt=8&uo=4";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - setTabBarStyle
- (void)setTabBarStyle
{

    CGRect frame = self.tableView.frame;
    frame.size.height = frame.size.height - 20;
    self.tableView.frame = frame;
}


#pragma mark - createTableHeaderView
- (void)createTableHeaderView
{
    
    UIImageView * header =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kAD_HIGHT * kScreenWidth / 320)];
    header.image = [UIImage imageNamed:@"placeholderImage"];
    self.tableView.tableHeaderView = header;
    
}


- (void)createTableFooterView
{
    UIButton * moreBtn = [[UIButton alloc]init];
    moreBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    moreBtn.backgroundColor = [UIColor whiteColor];
    [moreBtn setTitleColor:[UIColor colorWithRed:0.046 green:0.674 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
    [moreBtn setTitle:@"加载更多" forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(loadinagMoreNews:) forControlEvents:UIControlEventTouchDown];
    
    UIView * footer = [[UIView alloc]init];
    //footer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIActivityIndicatorView * ai = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    ai.color = kAppMainColor;
    [ai startAnimating];
    ai.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    ai.center = footer.center;
    [footer addSubview:ai];

    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        moreBtn.frame = CGRectMake(0, 5, kScreenWidth, 40);
        [moreBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        
        footer.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);

    }
    else
    {
        moreBtn.frame = CGRectMake(0, 5, kScreenWidth, 60);
        [moreBtn.titleLabel setFont:[UIFont systemFontOfSize:30]];
        
        footer.frame = CGRectMake(0, 0, self.view.frame.size.width, 70);
    
    }
    
    [footer addSubview:moreBtn];
    self.tableView.tableFooterView = footer;

}

- (void)setDropViewRefreshing
{
        ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    
        refreshControl.tintColor = kAppMainColor;
    
        [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
        //手动显示刷新时，不调动selector方法
        [refreshControl beginRefreshing];
        //请求数据
        [self dropViewDidBeginRefreshing:refreshControl];
}

    
- (void)loadinagMoreNews:(UIButton *)moreBtn
{
    //[moreBtn setTitle:@"加载中..." forState:UIControlStateNormal];
    moreBtn.hidden = YES;
    
    [CRToastManager dismissAllNotifications:YES];
    
    //最多加载到80页
    if (self.morePage > 0)
    {
        
        [self.fetchNewsTool getNewsListDataWithClassName:@"教学科研" page:(int)self.morePage success:^(NSArray *fetchNewsArray, int nextPage)
        {
            self.morePage = nextPage;
            
            [self.newsList addObjectsFromArray:fetchNewsArray];
            
            [self.tableView reloadData];
            
    
            //同时操作数小于10才 存储数据
//            if ([NewsCacheTool currentExecuteCounts] <10)
//            {
//                //数据库存储操作放子线程
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    
//                    [NewsCacheTool insertOldItems:fetchNewsArray];
//                    
//                });
//            
//            }
            

            
            [moreBtn setTitle:@"加载更多" forState:UIControlStateNormal];
             moreBtn.hidden = NO;
            
            
            [CRToastManager showNotificationWithOptions:[self optionsWithMessage:@"加载完成" backgroundColor:[UIColor colorWithRed:1.000 green:0.574 blue:0.221 alpha:1.000]]
                                        completionBlock:^{  }];
            //self.morePage +=1;
            
        } failure:^(NSError *error) {
            
            moreBtn.hidden = NO;
            //NSLog(@"%@",error.description);
            
            //手动取消网络操作
            if (error.code == -999)
            {
                [moreBtn setTitle:@"加载更多" forState:UIControlStateNormal];
                return ;
            }
            else
            {
                [CRToastManager showNotificationWithOptions:[self optionsWithMessage:@"休息一下在试试" backgroundColor:[UIColor colorWithRed:1.000 green:0.435 blue:0.812 alpha:1.000]]
                                            completionBlock:^{ }];
            
            }
            
            [moreBtn setTitle:@"加载失败,点击重新加载" forState:UIControlStateNormal];
        }];
        
        
    }
    else
    {
        [CRToastManager showNotificationWithOptions:[self optionsWithMessage:@"亲,没有更多啦！" backgroundColor:[UIColor colorWithRed:1.000 green:0.285 blue:0.291 alpha:1.000]] completionBlock:^{ }];
        [moreBtn setTitle:@"亲,你好利害，可惜没有更多啦！" forState:UIControlStateNormal];
         moreBtn.hidden = NO;
    }
    

}


- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    [self getFocusImages];
    
     [self.fetchNewsTool getNewsListDataWithClassName:@"教学科研" page:0 success:^(NSArray *fetchNewsArray, int nextPage)
      {
        
          self.morePage = nextPage;
            //提示数据更新信息
            NSString * message;
            UIColor * backgroundColor;
        
        //如果当前数据库无操作，才执行  查询并插入新项，返回插入条数
    if (![NewsCacheTool currentExecuteCounts]) {
            
            NSInteger counts = [NewsCacheTool updateNewItems:fetchNewsArray];
     
            if (!(counts == 0))
            {
                message = [NSString stringWithFormat:@"%ld 条更新",(long)counts];
                backgroundColor = [UIColor colorWithRed:0.975 green:0.528 blue:0.069 alpha:1.000];
            }
            else
            {
                message = @"暂无更新";
                backgroundColor = [UIColor colorWithRed:0.251 green:0.796 blue:0.518 alpha:1.000];
            }
        
            //取最新数据，从而显示人气数变化
            NSArray * newscache = [NewsCacheTool queryWithNumber:20];
            
            //NSLog(@"-----%lu",(unsigned long)fetchNewsArray.count);
//            [self.newsList removeAllObjects];
//            [self.newsList addObjectsFromArray:newscache];
        
        //如果不是首次加载的数据（为空），才替换
        if (self.newsList.count)
        {
            NSRange range;
            range.length = 20;
            range.location = 0;
            
            //替换前20条数据
            [self.newsList replaceObjectsInRange:range withObjectsFromArray:newscache];
        }
        else
        {
             [self.newsList addObjectsFromArray:newscache];
        }
        
            [self.tableView reloadData];

        
    }
    else
    {
        message = @"暂无更新";
        backgroundColor = [UIColor colorWithRed:0.251 green:0.796 blue:0.518 alpha:1.000];
    
    }
        
        [CRToastManager showNotificationWithOptions:[self optionsWithMessage:message backgroundColor:backgroundColor] completionBlock:^{  }];
        
        [refreshControl endRefreshing];
        
    } failure:^(NSError *error) {
        

        //非手动取消网络操作
        if (!(error.code == -999))
        {
            [CRToastManager dismissAllNotifications:YES];
            [CRToastManager showNotificationWithOptions:[self optionsWithMessage:@"休息一下在试试" backgroundColor:[UIColor colorWithRed:1.000 green:0.435 blue:0.812 alpha:1.000]]
                                        completionBlock:^{
                                            
                                        }];
            
        }
        
        [refreshControl endRefreshing];
        
    }];

    
}


- (void)getFocusImages
{
    [self.fetchNewsTool getFocusImagesSuccess:^(NSArray *fetchImagesArray)
    {
        
    //NSLog(@"%@",fetchImagesArray);
    
    FocusImageView * header = [[FocusImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kAD_HIGHT * kScreenWidth / 320) forcusImages:fetchImagesArray titles:nil tag:1];
    header.delegate = self;
    self.tableView.tableHeaderView = header;
    
    } failure:^(NSError *error) {
    
     }];

}

#pragma mark - FocusImagesDelegate
-(void)focusImageWithtouchImagePage:(NSInteger)page imageurl:(NSString *)url scrollView:(UIScrollView *)scrollview
{
    if (scrollview.tag == 1)
    {
        [self gotoWebViewWithURL:url];
    }
    
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.newsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[self switchToTopBtn:indexPath];
    
    static NSString * trendsCellID = @"trendsCellID";
    
    TrendsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:trendsCellID];
    if (cell == nil)
    {
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {

            cell = [[[NSBundle mainBundle] loadNibNamed:@"PhoneTrendsViewCell" owner:nil options:nil]firstObject];
        }
        else
        {
             cell = [[[NSBundle mainBundle] loadNibNamed:@"PadTrendsViewCell" owner:nil options:nil]firstObject];
        }
    }
    
    NewsModel * news = self.newsList[indexPath.row];
    
    cell.lblTitle.text = news.title;
    cell.lblAuthor.text = news.author;
    cell.lblClicks.text = @"";//[NSString stringWithFormat:@"人气:%@",news.clickNum];
    cell.lblTime.text = news.time;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 100;

}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    return ;
//
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NewsModel * news = self.newsList[indexPath.row];
    
    [self gotoWebViewWithURL:news.url];
}

- (void)gotoWebViewWithURL:(NSString*)url
{
    [CRToastManager dismissAllNotifications:YES];
    
    //取消网络加载
    [self.fetchNewsTool cancelAllOperations];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    BaseWebViewController * webVc = [[BaseWebViewController alloc]init];
    webVc.articleURL = url;
    
    [self.navigationController pushViewController:webVc animated:YES];

}


- (NSDictionary*)optionsWithMessage:(NSString *)message backgroundColor:(UIColor *)backgroundColor
{
    NSMutableDictionary *options = [@{
        kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
        kCRToastFontKey             : [UIFont boldSystemFontOfSize:22],
        kCRToastTextColorKey        : [UIColor whiteColor],
        kCRToastBackgroundColorKey  : backgroundColor,
        kCRToastAutorotateKey       : @(YES),
        kCRToastNotificationPresentationTypeKey: @(CRToastPresentationTypePush),
        kCRToastUnderStatusBarKey : @(YES),
        kCRToastTextKey : message,
        kCRToastTextAlignmentKey : @(1),
        kCRToastTimeIntervalKey : @(2.0),
        kCRToastAnimationInTypeKey : @(CRToastAnimationTypeSpring),
        kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
        kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionBottom),
        kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionBottom),
        kCRToastInteractionRespondersKey : @[[CRToastInteractionResponder interactionResponderWithInteractionType:CRToastInteractionTypeTap
                                                        automaticallyDismiss:YES
                                                                       block:^(CRToastInteractionType interactionType){
                                                                           //NSLog(@"Dismissed with %@ interaction", NSStringFromCRToastInteractionType(interactionType));
                                                                       }]]
        } mutableCopy];
    
    return [NSDictionary dictionaryWithDictionary:options];
}


@end
