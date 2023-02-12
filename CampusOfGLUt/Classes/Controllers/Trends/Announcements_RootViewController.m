//
//  Announcements_RootViewController.m
//  CampusOfGLUT
//
//  Created by HTC on 15/2/24.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "Announcements_RootViewController.h"
#import "FocusImageView.h"
#import "TrendsViewCell.h"
#import "RDVTabBarController.h"
#import "FetchNewsDataTool.h"
#import "NewsModel.h"
#import "BaseWebViewController.h"
#import "NewsCacheTool.h"
#import "ODRefreshControl.h"
#import "CRToast.h"

@interface Announcements_RootViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray * newsList;

//当前请求了的页数
@property (nonatomic,assign) NSInteger morePage;

//单例
@property (nonatomic,strong) FetchNewsTool *fetchNewsTool;

@property (nonatomic, weak) UIButton * moreBtn;

@property (nonatomic, weak) UITableView * tableView;
@end

@implementation Announcements_RootViewController

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
    
    //self.title = @"公告";
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.000];
    }
    
    [self setTabBarStyle];
    
    //NSArray * imageArr = @[@"1",@"2",@"3",@"4"];
    
    //[self createTableHeaderView];
    [self createTableFooterView];
    
    //加载更多的开始页数
    self.morePage = 0;
    
    //控制请求新闻数据的单例工具对象
    self.fetchNewsTool = [FetchNewsTool sharedFetchNewsTool];
    
    //查看数据库是否有数据（显示最新20条）
//    NSArray * newscache = [NewsCacheTool queryWithNumber:20];
//    if (newscache)
//    {
//        [self.newsList addObjectsFromArray:newscache];
//    }
    
    
    //上拉刷新
    [self setDropViewRefreshing];
    
    //头部照片
   // [self getFocusImages];
    
}


- (void)setTabBarStyle
{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStylePlain];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 200, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"tableView": tableView};
    NSArray *widthConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:views];
    NSArray *heightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:nil views:views];
    [NSLayoutConstraint activateConstraints:widthConstraints];
    [NSLayoutConstraint activateConstraints:heightConstraints];
}

- (void)createTableHeaderView
{
    
    UIImageView * header =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kAD_HIGHT * kScreenWidth / 320)];
    header.image = [UIImage imageNamed:@"placeholderImage"];
    self.tableView.tableHeaderView = header;
    
}


- (void)createTableFooterView
{
    UIButton * moreBtn = [[UIButton alloc]init];
    self.moreBtn = moreBtn;
    moreBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if (@available(iOS 13.0, *)) {
        moreBtn.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        moreBtn.backgroundColor = [UIColor whiteColor];
    }
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
    if (self.newsList.count == 0) {
        //请求数据
        [self setDropViewRefreshing];
        return;
    }
    
    //[moreBtn setTitle:@"加载中..." forState:UIControlStateNormal];
    moreBtn.hidden = YES;
    
    [CRToastManager dismissAllNotifications:YES];
    
    //最多加载到80页
    if (self.morePage >0)
    {
        
        [self.fetchNewsTool getNewsListDataWithClassName:@"公告" page:(int)self.morePage success:^(NSArray *fetchNewsArray, int nextPage)
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
             //self.morePage +=1 ;
             
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
                 [CRToastManager showNotificationWithOptions:[self optionsWithMessage:@"网络好像出错啦~" backgroundColor:[UIColor colorWithRed:1.000 green:0.435 blue:0.812 alpha:1.000]]
                                             completionBlock:^{ }];
                 
             }
             
             [moreBtn setTitle:@"加载失败,点击重新加载" forState:UIControlStateNormal];
         }];
        
        
    }
    else
    {
        [CRToastManager showNotificationWithOptions:[self optionsWithMessage:@"加载到底啦！" backgroundColor:[UIColor colorWithRed:1.000 green:0.285 blue:0.291 alpha:1.000]] completionBlock:^{ }];
        [moreBtn setTitle:@"已经到底，没有更多啦~" forState:UIControlStateNormal];
        moreBtn.hidden = NO;
    }
    
    
}


- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    [self.fetchNewsTool getNewsListDataWithClassName:@"公告" page:0 success:^(NSArray *fetchNewsArray, int nextPage)
      {
          
          self.morePage = nextPage;
        //提示数据更新信息
        NSString * message;
        UIColor * backgroundColor;
        
        //如果当前数据库无操作，才执行  查询并插入新项，返回插入条数
        if (![NewsCacheTool currentExecuteCounts]) {
            
//            NSInteger counts = [NewsCacheTool updateNewItems:fetchNewsArray];
//            
//            if (!counts == 0)
//            {
//                message = [NSString stringWithFormat:@"%ld 条更新",(long)counts];
//                backgroundColor = [UIColor colorWithRed:0.975 green:0.528 blue:0.069 alpha:1.000];
//            }
//            else
//            {
                message = @"暂无更新";
                backgroundColor = [UIColor colorWithRed:0.251 green:0.796 blue:0.518 alpha:1.000];
//            }
//            
//            //取最新数据，从而显示人气数变化
//            NSArray * newscache = [NewsCacheTool queryWithNumber:20];
//            
//            //NSLog(@"-----%lu",(unsigned long)fetchNewsArray.count);
//            //            [self.newsList removeAllObjects];
//            //            [self.newsList addObjectsFromArray:newscache];
            
            NSRange range;
            range.length = 20;
            range.location = 0;
            //替换前20条数据
            [self.newsList removeAllObjects];
            [self.newsList addObjectsFromArray:fetchNewsArray];
            
            [self.tableView reloadData];
            
            
        }
        else
        {
            message = @"暂无更新";
            backgroundColor = [UIColor colorWithRed:0.251 green:0.796 blue:0.518 alpha:1.000];
            
        }
          
          if (self.morePage != 1)
          {
              [CRToastManager showNotificationWithOptions:[self optionsWithMessage:message backgroundColor:backgroundColor] completionBlock:^{  }];
          }
        
        [refreshControl endRefreshing];
        
    } failure:^(NSError *error) {
        
        
        //非手动取消网络操作
        if (!(error.code == -999))
        {
            [CRToastManager dismissAllNotifications:YES];
            [CRToastManager showNotificationWithOptions:[self optionsWithMessage:@"网络好像出错啦~" backgroundColor:[UIColor colorWithRed:1.000 green:0.435 blue:0.812 alpha:1.000]]
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
         
         NSMutableArray * imageArr = [NSMutableArray array];
         
         for (NSString * url in fetchImagesArray[0]) {
             
             NSString * image = [NSString stringWithFormat:@"http://www.glut.edu.cn/Git/%@",url];
             
             [imageArr addObject:image];
         }
         
         // NSLog(@"%@",imageArr);
         
         FocusImageView * header = [[FocusImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kAD_HIGHT * kScreenWidth / 320) forcusImages:imageArr titles:nil tag:3];
         
         self.tableView.tableHeaderView = header;
         
         
     } failure:^(NSError *error) {
         
     }];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.newsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    
    // 最后一条
    if ((indexPath.row + 1) == self.newsList.count) {
        [self loadinagMoreNews:self.moreBtn];
    }
    
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
    
    [CRToastManager dismissAllNotifications:YES];
    
    //取消网络加载
    [self.fetchNewsTool cancelAllOperations];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    BaseWebViewController * webVc = [[BaseWebViewController alloc]init];
    NewsModel * news = self.newsList[indexPath.row];
    webVc.articleURL = news.url;
    webVc.hidesBottomBarWhenPushed = YES;
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
                                      kCRToastTimeIntervalKey : @(0.25),
                                      kCRToastAnimationInTypeKey : @(CRToastAnimationTypeSpring),
                                      kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                                      kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionBottom),
                                      kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionBottom)
                                      } mutableCopy];
    
    return [NSDictionary dictionaryWithDictionary:options];
}


@end
