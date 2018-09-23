//
//  BulletinBoardViewController.m
//  CampusOfGLUT
//
//  Created by HTC on 15/3/30.
//  Copyright (c) 2015年 HTC. All rights reserved.
//



#define TableID @"551933d5e4b05079796eff0f"

#define KCertification @"551933a4e4b05079796efed1"

//举报数
#define kREPORTS  30

#import "BulletinBoardViewController.h"
#import "FetchLifeCircleTool.h"
#import "LifesTableViewCell.h"
#import "LifeModel.h"
#import "LifeFrameModel.h"
#import "AppUtils.h"
#import "FetchLifeCircleTool.h"
#import "ODRefreshControl.h"
#import "CRToastTool.h"
#import "SendTextViewController.h"
#import "LifeToolBarView.h"
#import "LifeModel.h"
#import "MWPhotoBrowser.h"
#import "WeiboSDKTool.h"
#import "WeixinSDKTool.h"
#import "ShareActivityView.h"
#import "ImageUtilityTool.h"
#import "InformationHandleTool.h"
#import "QQSDKTool.h"
#import "CommetsViewController.h"


@interface BulletinBoardViewController ()<UITableViewDelegate,UITableViewDataSource, LifeToolBarViewDelegate,LifeTopViewDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) UITableView * tableView;


/** 存放所有cell的frame模型数据 */
@property (nonatomic, strong) NSMutableArray *talkFrameArray;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, strong) FetchLifeCircleTool * fetchTalkTool;

/** 网页图片浏览器的图片容器 */
@property (nonatomic, strong) NSMutableArray *photos;

//分享视图
@property (nonatomic, strong) ShareActivityView *shareView;

@end

@implementation BulletinBoardViewController

-(NSMutableArray *)talkFrameArray
{
    if (_talkFrameArray == nil) {
        
        _talkFrameArray = [NSMutableArray array];
    }
    
    return _talkFrameArray;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
    [CRToastTool dismissAllNotifications];
    [self.fetchTalkTool cancelAllOperations];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    
    //初始化工具
    self.fetchTalkTool = [FetchLifeCircleTool sharedFetchNewsTool];
    
    self.ID = 0;
    
    //设置刷新
    [self setDropViewRefreshing];
    
    
    //NaviBar RightBar
    [self setNaviRightSendMeassage];
    
}


- (void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
}


#pragma mark - init刷新控件
- (void)setDropViewRefreshing
{
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    
    refreshControl.tintColor = kAppMainColor;
    
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    //手动显示刷新时，不调动selector方法
    //[refreshControl beginRefreshing];
    //请求数据
    [self dropViewDidBeginRefreshing:refreshControl];
}

#pragma mark - 下拉刷新
- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    //获取最新数据
    [self.fetchTalkTool fetchNewLifeCircleWithTableID:TableID success:^(NSArray *fetchArray) {
        
        NSInteger newCounts = 0;
        NSString * meassage;
        
        //旧数据更新
        if (self.talkFrameArray.count) {
            
            LifeFrameModel * firstF = [self.talkFrameArray objectAtIndex:0];
            LifeModel * firstModel = firstF.lifeModel;
            
            for (int i = 0; i <(self.talkFrameArray.count > fetchArray.count ?fetchArray.count:self.talkFrameArray.count); i++) {
                
                LifeModel * newModel = [LifeModel lifeModelWithDict:[fetchArray objectAtIndex:i]];
                //举报数小于3O次才显示
                if ([newModel.reports intValue] < kREPORTS) {
                    
                    //创建时间比 原来数组第一个的时间比较早先，就是最新
                    if ([self compareEarlierDate:firstModel.time otherDate:newModel.time]) {
                        LifeFrameModel * frameModel = [[LifeFrameModel alloc]init];
                        frameModel.lifeModel = newModel;
                        [self.talkFrameArray insertObject:frameModel atIndex:0];
                        newCounts += 1;
                    }
                    
                    //遍历全部model，如果相同时间的也更新
                    for (int j = 0; j <(self.talkFrameArray.count >15 ?8:self.talkFrameArray.count); j++)
                    {
                        LifeFrameModel * oldModel  = [self.talkFrameArray objectAtIndex:j];
                        
                        if([self isEqualDate:oldModel.lifeModel.time otherDate:newModel.time])
                        {
                            //时间相同，也更新 可能有评论内容
                            oldModel.lifeModel = newModel;
                        }
                    }
                    
                }
            }
            
            meassage = [NSString stringWithFormat:@"%ld条新说说",newCounts];
            
        }else{
            //第一次进入时
            for (NSDictionary * dic in fetchArray)
            {
                LifeModel * newModel = [LifeModel lifeModelWithDict:dic];
                
                //举报数小于3O次才显示
                if ([newModel.reports intValue] < kREPORTS) {
                    
                    LifeFrameModel * frameModel = [[LifeFrameModel alloc]init];
                    frameModel.lifeModel = newModel;
                    [self.talkFrameArray addObject:frameModel];
                    
                    newCounts += 1;
                    self.ID = [[dic objectForKey:@"_id"] integerValue];//取得数据中最小id
                }
            }
            
            //TableView FooterView (加载更多按钮）
            [self createTableFooterView];
            self.ID -= 1; //旧id应该更小一个
            meassage = [NSString stringWithFormat:@"最新%ld条说说",newCounts];
        }
        
        [refreshControl endRefreshing];
        
        [self.tableView reloadData];
        
        if(newCounts){
            [CRToastTool showNotificationWithTitle:meassage backgroundColor:[UIColor colorWithRed:0.975 green:0.528 blue:0.069 alpha:1.000] timeInterval:@(1) completionBlock:^{   }];
        }else{
            
            [CRToastTool showNotificationWithTitle:@"已经是最新啦!" backgroundColor:[UIColor colorWithRed:0.251 green:0.796 blue:0.518 alpha:1.000] timeInterval:@(1) completionBlock:^{     }];
        }
        
    } failure:^(NSError *error) {
        
        [refreshControl endRefreshing];
        [CRToastTool showNotificationWithTitle:@"网络好像出了点问题" backgroundColor:[UIColor colorWithRed:1.000 green:0.435 blue:0.812 alpha:1.000] timeInterval:@(2) completionBlock:^{   }];
    }];
    
}


#pragma mark - 时间方法
/**
 *  返回是否第一个比第二个早
 *
 *  @param early 假设最早的时间
 *  @param later 比较时间
 *
 *  @return 返回是否第一个比第二个早
 */
- (BOOL) compareEarlierDate:(NSString *)early otherDate:(NSString *)later
{
    NSDate * earlyDate = [self creatDateWith:early];
    NSDate * laterDate = [self creatDateWith:later];
    
    NSDate *date = [earlyDate earlierDate:laterDate];
    
    if ([date isEqualToDate:earlyDate] && [date isEqualToDate:laterDate]) {
        return NO;
    }else if([date isEqualToDate:earlyDate]){
        return YES;
    }else{
        return NO;
    }
}


- (BOOL) isEqualDate:(NSString *)date otherDate:(NSString *)otherDate
{
    NSDate * firstDate = [self creatDateWith:date];
    NSDate * sconedDate = [self creatDateWith:otherDate];
    
    return [firstDate isEqualToDate:sconedDate];
}


- (NSDate *)creatDateWith:(NSString *)str
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    return [fmt dateFromString:str];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.talkFrameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    LifesTableViewCell *cell = [LifesTableViewCell cellWithTableView:tableView];
    
    // 2.在这个方法算好了cell的高度
    cell.lifeFrameModel = self.talkFrameArray[indexPath.row];
    
    // 3.设置toolbar代理（监听点击按钮）
    cell.lifeToolbar.delegate = self;
    
    // 4.设置topView代理（监听点击图片）
    cell.topView.delegate = self;
    
    // 4.返回cell
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出这行对应的frame模型
    LifeFrameModel *Frame = self.talkFrameArray[indexPath.row];
    return Frame.cellHeight;
}

#pragma mark -  select Cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self commentsVC:self.talkFrameArray[indexPath.row]];
    
}

//
//#pragma mark - 列表的编辑模式
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //点击举报
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你确实要举报吗" message:@"每条信息举报超过30次后，将会暂时隐藏，审核通过后才能在显示" preferredStyle:UIAlertControllerStyleAlert];
//        
//        // 添加按钮
//        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            
//            [self updataReportsWithTableView:tableView forRowAtIndexPath:indexPath];
//            
//            
//        }]];
//        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//            
//            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        }]];
//        
//        [self presentViewController:alert animated:YES completion:nil];
//        
//    }
//}
//

#pragma mark - 侧滑时，显示 举报
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"举报";
}

#pragma mark - 举报
- (void)updataReportsWithTableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath
{
    LifeFrameModel * model = self.talkFrameArray[indexPath.row];
    NSString *reports = [NSString stringWithFormat:@"%d",([model.lifeModel.reports intValue] +1)];
    
    [self.fetchTalkTool updataReportsWithTableID:TableID IDs:model.lifeModel.ID newReports:reports success:^(NSArray *fetchArray)
     {
         [CRToastTool showNotificationWithTitle:@"举报成功" backgroundColor:[UIColor colorWithRed:0.251 green:0.796 blue:0.518 alpha:1.000] timeInterval:@(1) completionBlock:^{     }];
         [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
         //防止重复举报
         //model.lifeModel.reports = reports;
         
     } failure:^(NSError *error) {
         
         [CRToastTool showNotificationWithTitle:@"网络好像出了点问题" backgroundColor:[UIColor colorWithRed:1.000 green:0.435 blue:0.812 alpha:1.000] timeInterval:@(2) completionBlock:^{   }];
     }];
}


#pragma mark - 创建Table FootView
- (void)createTableFooterView
{
    UIButton * moreBtn = [[UIButton alloc]init];
    moreBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    moreBtn.backgroundColor = [UIColor whiteColor];
    [moreBtn setTitleColor:[UIColor colorWithRed:0.046 green:0.674 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
    [moreBtn setTitle:@"加载更多" forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(loadinagMore:) forControlEvents:UIControlEventTouchDown];
    
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
#pragma mark - 点击加载更多
- (void)loadinagMore:(UIButton *)moreBtn
{
    
    moreBtn.hidden = YES;
    
    [self.fetchTalkTool fetchTalkOfLifeCircleWithTableID:TableID endID:self.ID range:10 success:^(NSArray *fetchArray) {
        
        for (NSDictionary * dic in fetchArray)
        {
            LifeModel * newModel = [LifeModel lifeModelWithDict:dic];
            //举报数小于3O次才显示
            if ([newModel.reports intValue] < kREPORTS) {
                
                LifeFrameModel * frameModel = [[LifeFrameModel alloc]init];
                frameModel.lifeModel = newModel;
                [self.talkFrameArray addObject:frameModel];
            }
        }
        
        [self.tableView reloadData];
        
        moreBtn.hidden = NO;
        
        [CRToastTool showNotificationWithTitle:@"加载更多成功" backgroundColor:[UIColor colorWithRed:1.000 green:0.574 blue:0.221 alpha:1.000] timeInterval:@(1) completionBlock:^{        }];
        
        self.ID -= 10;
        
    } failure:^(NSError *error) {
        
        //Error Domain=没有更多 Code=1314520 "The operation couldn’t be completed. (没有更多 error 1314520.)" UserInfo=0x1746766c0 {status=0, info=_id不存在, count=0, datas=()}
        
        NSLog(@"====%@",error);
        if (error.code == 1314520)
        {
            [CRToastTool showNotificationWithTitle:@"没有更多了" backgroundColor:[UIColor colorWithRed:1.000 green:0.285 blue:0.291 alpha:1.000] timeInterval:@(2) completionBlock:^{   }];
            
            [moreBtn setTitle:@"亲,你好利害，可惜没有更多啦！" forState:UIControlStateNormal];
        }
        else{
            
            [CRToastTool showNotificationWithTitle:@"休息一下再试试" backgroundColor:[UIColor colorWithRed:1.000 green:0.435 blue:0.812 alpha:1.000] timeInterval:@(2) completionBlock:^{   }];
        }
        moreBtn.hidden = NO;
    }];
    
    
}

#pragma 点击工具栏
- (void)lifeToolBarClicked:(UIButton *)button lifeMode:(LifeFrameModel *)lifeFrameModel superviewCell:(UIView *)contenView
{
    switch (button.tag) {
        case 0:{//分享按钮
            CGRect frame = [self.tableView rectForRowAtIndexPath:[self.tableView indexPathForCell:(LifesTableViewCell*)[contenView superview]]];
            
            //CGRect supframe = [self.tableView convertRect:frame toView:[self.tableView superview]];
            //
            //            NSLog(@"---%@",NSStringFromCGRect(frame));
            
            [self showShareView:lifeFrameModel.lifeModel imageFrame:frame];
            
            break;}
        case 1://评价
            NSLog(@"1");
            [self commentsVC:lifeFrameModel];
            break;
        case 2://点赞
            //NSLog(@"2");
            [self updataLickButton:button lifeMode:lifeFrameModel.lifeModel];
            break;
            
        default:
            break;
    }
}

#pragma mark - 点击评论
- (void)commentsVC:(LifeFrameModel *)lifeFrameModel
{
    CommetsViewController  * VC = [[CommetsViewController alloc]init];
    VC.title = self.title;
    VC.lifeFrameModel = lifeFrameModel;
    VC.tableID = TableID;
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - 分享说说

- (void)showShareView:(LifeModel *)lifeModel imageFrame:(CGRect)frame
{
    
    [self.shareView removeFromSuperview];
    
    
    self.shareView = [[ShareActivityView alloc]initWithTitle:@"分享到" referView:self.view];
    
    //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
    self.shareView.numberOfButtonPerLine = 7;
    
    
    //设置分享到网络的视图
    [self shareToNetwork:lifeModel imageFrame:frame];
    
    [self.shareView show];
    
}

- (ButtonView *)shareToNetwork:(LifeModel *)lifeModel imageFrame:(CGRect)frame
{
    ButtonView *bv = [[ButtonView alloc]initWithText:@"新浪微博" image:[UIImage imageNamed:@"ShareIcon_SinaWeibo"] handler:^(ButtonView *buttonView)
                      {
                          //新浪微博
                          [WeiboSDKTool shareToWeiboWithContent:(lifeModel.contents.length >139 ? lifeModel.name :lifeModel.contents) image:[ImageUtilityTool imageFromScrollView:self.tableView withFrame:frame] media:nil];
                      }];
    [self.shareView addButtonView:bv];
    
    bv = [[ButtonView alloc]initWithText:@"微信好友" image:[UIImage imageNamed:@"ShareIcon_Weixin"] handler:^(ButtonView *buttonView)
          {
              //微信
              [WeixinSDKTool sendImageContent:[ImageUtilityTool imageFromScrollView:self.tableView withFrame:frame] scene:WXSceneTypeSession];
          }];
    [self.shareView addButtonView:bv];
    
    bv = [[ButtonView alloc]initWithText:@"微信朋友圈" image:[UIImage imageNamed:@"ShareIcon_WeixinZone"] handler:^(ButtonView *buttonView)
          {
              //微信朋友圈
              [WeixinSDKTool sendImageContent:[ImageUtilityTool imageFromScrollView:self.tableView withFrame:frame] scene:WXSceneTypeTimeline];
          }];
    [self.shareView addButtonView:bv];
    
    bv = [[ButtonView alloc]initWithText:@"微信收藏" image:[UIImage imageNamed:@"ShareIcon_WeixinFav"] handler:^(ButtonView *buttonView)
          {
              //微信收藏
              [WeixinSDKTool sendImageContent:[ImageUtilityTool imageFromScrollView:self.tableView withFrame:frame] scene:WXSceneTypeFavorite];
          }];
    [self.shareView addButtonView:bv];
    
    bv = [[ButtonView alloc]initWithText:@"QQ/空间" image:[UIImage imageNamed:@"ShareIcon_QQ"] handler:^(ButtonView *buttonView)
          {
              //QQ
              [QQSDKTool shareToWeiboWithImage:[ImageUtilityTool imageFromScrollView:self.tableView withFrame:frame] title:lifeModel.name description:[NSString stringWithFormat:@"来自校园话题：%@",self.title]];
              
          }];
    
    [self.shareView addButtonView:bv];
    
    return bv;
}



#pragma mark - 更新点赞数
- (void)updataLickButton:(UIButton *)button lifeMode:(LifeModel *)lifeModel
{
    if (lifeModel.isLicked) {//如果已经点赞，则取消点赞
        
        NSString *lickCounts = [NSString stringWithFormat:@"%ld",([lifeModel.praises integerValue] -1)];
        
        [self.fetchTalkTool updataPraisesWithTableID:TableID IDs:lifeModel.ID newPraises:lickCounts success:^(NSArray *fetchArray)
         {//取消成功
             button.selected = NO;
             lifeModel.isLicked = NO;
             lifeModel.praises = lickCounts;
             [self setupBtn:button originalTitle:@"点赞" count:lickCounts];
             
         } failure:^(NSError *error) {
             [CRToastTool showNotificationWithTitle:@"休息一下再试试" backgroundColor:[UIColor colorWithRed:1.000 green:0.435 blue:0.812 alpha:1.000] timeInterval:@(2) completionBlock:^{   }];
         }];
        
        
        
    }else{
        
        NSString *lickCounts = [NSString stringWithFormat:@"%ld",([lifeModel.praises integerValue] +1)];
        
        [self.fetchTalkTool updataPraisesWithTableID:TableID IDs:lifeModel.ID newPraises:lickCounts success:^(NSArray *fetchArray) {
            button.selected = YES;
            lifeModel.isLicked = YES;
            lifeModel.praises = lickCounts;
            [self setupBtn:button originalTitle:@"点赞" count:lickCounts];
        } failure:^(NSError *error) {
            [CRToastTool showNotificationWithTitle:@"休息一下再试试" backgroundColor:[UIColor colorWithRed:1.000 green:0.435 blue:0.812 alpha:1.000] timeInterval:@(2) completionBlock:^{   }];
        }];
        
        
    }
    
    
}


/**
 *  设置按钮的显示标题
 *
 *  @param btn           哪个按钮需要设置标题
 *  @param originalTitle 按钮的原始标题(显示的数字为0的时候, 显示这个原始标题)
 *  @param count         显示的个数
 */
- (void)setupBtn:(UIButton *)btn originalTitle:(NSString *)originalTitle count:(NSString *)counts
{
    /**
     0 -> @"转发"
     <10000  -> 完整的数量, 比如个数为6545,  显示出来就是6545
     >= 10000
     * 整万(10100, 20326, 30000 ....) : 1万, 2万
     * 其他(14364) : 1.4万
     */
    
    int count = [counts intValue];
    
    if (count) { // 个数不为0
        NSString *title = nil;
        if (count < 10000) { // 小于1W
            title = [NSString stringWithFormat:@"%d", count];
        } else { // >= 1W
            // 42342 / 1000 * 0.1 = 42 * 0.1 = 4.2
            // 10742 / 1000 * 0.1 = 10 * 0.1 = 1.0
            // double countDouble = count / 1000 * 0.1;
            
            // 42342 / 10000.0 = 4.2342
            // 10742 / 10000.0 = 1.0742
            double countDouble = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万", countDouble];
            
            // title == 4.2万 4.0万 1.0万 1.1万
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
        [btn setTitle:title forState:UIControlStateNormal];
    } else {
        [btn setTitle:originalTitle forState:UIControlStateNormal];
    }
}

#pragma mark - 点击浏览图片
- (void)lifeTopViewClickedImageView:(LifeModel *)lifeModel
{
    [self openPhotoBrowserWithImageURL:lifeModel.images title:lifeModel.contents];
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
    
    [self.navigationController pushViewController:browser animated:YES];
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


#pragma mark - NaviIint
- (void)setNaviRightSendMeassage
{
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navi_add_normol"] style:UIBarButtonItemStylePlain target:self action:@selector(checkCertification)] animated:NO];
}

#pragma mark - 检查认证
- (void)checkCertification
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登陆" message:@"发布公告需要认证，有问题可联系管理员" preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加按钮
    __weak typeof(alert) weakAlert = alert;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [self checkCertificationWiht:[weakAlert.textFields.firstObject text] password:[weakAlert.textFields.lastObject text]];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //NSLog(@"点击了取消按钮");
    }]];
    //    [alert addAction:[UIAlertAction actionWithTitle:@"其它" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    //        NSLog(@"点击了其它按钮");
    //    }]];
    
    // 添加文本框
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.textColor = [UIColor redColor];
        textField.placeholder = @"帐号";
        //[textField addTarget:self action:@selector(usernameDidChange:) forControlEvents:UIControlEventEditingChanged];
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usernameDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.secureTextEntry = YES;
        textField.placeholder = @"密码";
    }];
    
    [self presentViewController:alert animated:YES completion:nil];

    
}
/**
 *  (
 {
 "_address" = "";
 "_createtime" = "2015-03-31 00:00:52";
 "_id" = 1;
 "_image" =         (
 );
 "_location" = "79.550455,42.581097";
 "_name" = test123;
 "_updatetime" = "2015-03-31 00:01:12";
 }
 )
 *
 -{
 count = 0;
 datas =     (
 );
 info = "_id\U4e0d\U5b58\U5728";
 status = 0;
 }
 */
#pragma mark -  发送认证请求
- (void)checkCertificationWiht:(NSString *)name password:(NSString *)psword
{
    if (name.length == 0 || psword.length == 0 ) {
        
     [CRToastTool showNotificationWithTitle:@"帐号和密码不能空哦" backgroundColor:[UIColor colorWithRed:0.975 green:0.636 blue:0.167 alpha:1.000] timeInterval:@(2) completionBlock:^{   }];
        return ;
    }
    
    [self.fetchTalkTool fetchTalkOfLifeCircleWithTableID:KCertification ID:name success:^(NSArray *fetchArray) {
        
        [fetchArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSString * _psword = [obj objectForKey:@"_name"];
            if([_psword isEqualToString:psword]){
                [self sendTextViewController];
            }else{
                
              [CRToastTool showNotificationWithTitle:@"帐号或密码错误哦" backgroundColor:[UIColor colorWithRed:1.000 green:0.348 blue:0.510 alpha:1.000] timeInterval:@(2) completionBlock:^{   }];
            }
        }];
        
    } failure:^(NSError *error) {
        [CRToastTool showNotificationWithTitle:@"网络好像出了点问题" backgroundColor:[UIColor colorWithRed:0.251 green:0.796 blue:0.518 alpha:1.000] timeInterval:@(2) completionBlock:^{   }];
    }];
}


-(void)sendTextViewController
{
    SendTextViewController * sendVC = [[SendTextViewController alloc]init];
    sendVC.tableID = TableID;
    [self presentViewController:sendVC animated:YES completion:nil];
}

@end
