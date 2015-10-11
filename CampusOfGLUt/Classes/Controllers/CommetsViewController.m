//
//  CommetsViewController.m
//  CampusOfGLUT
//
//  Created by HTC on 15/3/29.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "CommetsViewController.h"
#import "MWPhotoBrowser.h"
#import "FetchLifeCircleTool.h"
#import "CRToastTool.h"
#import "ODRefreshControl.h"
#import "LifeToolBarView.h"
#import "LifeTopView.h"
#import "CommentFrameModel.h"
#import "CommentModel.h"
#import "CommentTableViewCell.h"

#import "ShareActivityView.h"
#import "WeiboSDKTool.h"
#import "WeixinSDKTool.h"
#import "ImageUtilityTool.h"
#import "InformationHandleTool.h"
#import "QQSDKTool.h"

#import "SendCommetsViewController.h"

@interface CommetsViewController ()<UITableViewDelegate,UITableViewDataSource, MWPhotoBrowserDelegate,LifeToolBarViewDelegate,LifeTopViewDelegate>

@property (nonatomic, strong) UITableView * commetTableView;


/** 存放所有cell的frame模型数据 */
@property (nonatomic, strong) NSMutableArray *commetsFrameArray;

@property (nonatomic, strong) FetchLifeCircleTool * fetchTalkTool;

/** 网页图片浏览器的图片容器 */
@property (nonatomic, strong) NSMutableArray *photos;

//分享视图
@property (nonatomic, strong) ShareActivityView *shareView;

//工具条 数据刷新用
@property (nonatomic, strong) LifeToolBarView * lifeToolBarView;

/** 刷新控件 */
@property (nonatomic, assign) ODRefreshControl *refreshControl;

@end

@implementation CommetsViewController

-(NSMutableArray *)commetsFrameArray
{
    if (_commetsFrameArray == nil) {
        
        _commetsFrameArray = [NSMutableArray array];
    }
    
    return _commetsFrameArray;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
    [CRToastTool dismissAllNotifications];
    [self.fetchTalkTool cancelAllOperations];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //初始化工具
    self.fetchTalkTool = [FetchLifeCircleTool sharedFetchNewsTool];
    [self dropViewDidBeginRefreshing:self.refreshControl];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    
    [self setCommetsData:self.lifeFrameModel.lifeModel];
    
    //设置刷新
    [self setDropViewRefreshing];
    
    
    //NaviBar RightBar
    [self setNaviRightSendMeassage];
    
}

#pragma mark - 设置评论的数据
- (void)setCommetsData:(LifeModel *)lifeModel
{
    NSString * commentStr = lifeModel.commets;
    
    //系统来空
    if ((NSNull *)lifeModel.commets == [NSNull null]) { // 无评论
    
        [CRToastTool showNotificationWithTitle:@"暂无评论哦" backgroundColor:[UIColor colorWithRed:0.975 green:0.349 blue:0.463 alpha:1.000] timeInterval:@3 completionBlock:nil];
        return;
    }
    
    //网络来的空
    if ([[[lifeModel.commets class] description] isEqualToString:@"__NSCFConstantString"]) {
        [CRToastTool showNotificationWithTitle:@"暂无评论哦" backgroundColor:[UIColor colorWithRed:0.975 green:0.349 blue:0.463 alpha:1.000] timeInterval:@3 completionBlock:nil];
        return;
    }
    
    /**
     *    "commets" : "0{1}ID{2}天下{1}name{2}1{1}icon{2}2015-03-30 02:00:01{1}time{2}天气{1}contents{2}来自：iPhone 5s{1}comefrom"
     }
     */
    
    NSArray *commetsArr = [commentStr componentsSeparatedByString:@"{3}"];
    
    NSMutableArray * dicsArr = [NSMutableArray array];
    for (int i = 0; i < commetsArr.count; i++) {
        NSString *obj = commetsArr[i];
        NSArray * fragment = [obj componentsSeparatedByString:@"{2}"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (int i = 0; i < fragment.count; i++) {
            NSString *keys = fragment[i];
            NSArray * key = [keys componentsSeparatedByString:@"{1}"];
            [dic setObject:key[0] forKeyedSubscript:key[1]];
        }
        [dicsArr addObject:dic];
    }

    
    [self.commetsFrameArray removeAllObjects];
    
    for (int i = 0; i < dicsArr.count; i++) {
        
        NSDictionary * dic = dicsArr[i];
        
        CommentModel * model = [CommentModel commentModelWithDict:dic];
        CommentFrameModel * frameModel = [[CommentFrameModel alloc]init];
        frameModel.commentModel = model;
        [self.commetsFrameArray addObject:frameModel];
        
    }
    
    [self.commetTableView reloadData];

}


- (void)initTableView
{
    self.commetTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -64) style:UITableViewStylePlain];
    self.commetTableView.allowsSelection = NO;
    self.commetTableView.delegate = self;
    self.commetTableView.dataSource = self;
    [self.view addSubview:self.commetTableView];
    self.commetTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, self.lifeFrameModel.cellHeight)];
    
    LifeTopView * top = [[LifeTopView alloc]init];
    top.lifeFrameModel = self.lifeFrameModel;
    top.frame = self.lifeFrameModel.topViewF;
    top.delegate = self;
    [headerView addSubview:top];
    
    LifeToolBarView * tool = [[LifeToolBarView alloc]init];
    tool.lifeFrameModel = self.lifeFrameModel;
    tool.frame = self.lifeFrameModel.lifeToolbarF;
    tool.delegate = self;
    [headerView addSubview:tool];
    self.lifeToolBarView = tool;
    
    self.commetTableView.tableHeaderView = headerView;
}


#pragma mark - init刷新控件
- (void)setDropViewRefreshing
{
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.commetTableView];
    self.refreshControl = refreshControl;
    
    refreshControl.tintColor = [UIColor colorWithRed:0.046 green:0.674 blue:1.000 alpha:1.000];
    
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    //手动显示刷新时，不调动selector方法
    //[refreshControl beginRefreshing];
    //请求数据
    //[self dropViewDidBeginRefreshing:refreshControl];
}

#pragma mark - 下拉刷新
- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    [self.fetchTalkTool fetchTalkOfLifeCircleWithTableID:self.tableID ID:self.lifeFrameModel.lifeModel.ID success:^(NSArray *fetchArray) {
        
        LifeModel * newModel = [LifeModel lifeModelWithDict:[fetchArray firstObject]];
     
        LifeFrameModel * frameModel = [[LifeFrameModel alloc]init];
        frameModel.lifeModel = newModel;
        
        self.lifeToolBarView.lifeFrameModel = frameModel;
        
        [self setCommetsData:newModel];
        
        [refreshControl endRefreshing];
        
    } failure:^(NSError *error) {
        [CRToastTool showNotificationWithTitle:@"网络好像出了点问题" backgroundColor:[UIColor colorWithRed:1.000 green:0.435 blue:0.812 alpha:1.000] timeInterval:@(2) completionBlock:^{   }];
            [refreshControl endRefreshing];
    }];
    
    
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.commetsFrameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    CommentTableViewCell *cell = [CommentTableViewCell cellWithTableView:tableView];
    
    // 2.在这个方法算好了cell的高度
    cell.commentFrameModel = self.commetsFrameArray[indexPath.row];
    
//    // 3.设置toolbar代理（监听点击按钮）
//    cell.commentFrameModel.delegate = self;
//    
//    // 4.设置topView代理（监听点击图片）
//    cell.topView.delegate = self;
    
    // 4.返回cell
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出这行对应的frame模型
    LifeFrameModel *Frame = self.commetsFrameArray[indexPath.row];
    return Frame.cellHeight;
}


#pragma 点击工具栏
- (void)lifeToolBarClicked:(UIButton *)button lifeMode:(LifeFrameModel *)lifeFrameModel superviewCell:(UIView *)contenView
{
    switch (button.tag) {
        case 0:{//分享按钮
            
            //CGRect supframe = [self.tableView convertRect:frame toView:[self.tableView superview]];
            //
            //            NSLog(@"---%@",NSStringFromCGRect(frame));
            
           [self showShareView:lifeFrameModel.lifeModel];
            
            break;}
        case 1://评价
            [self commetBtnClicked];
            break;
        case 2://点赞
            //NSLog(@"2");
            [self updataLickButton:button lifeMode:lifeFrameModel.lifeModel];
            break;
            
        default:
            break;
    }
}

#pragma mark - 分享说说

- (void)showShareView:(LifeModel *)lifeModel
{
    
    [self.shareView removeFromSuperview];
    
    
    self.shareView = [[ShareActivityView alloc]initWithTitle:@"分享到" referView:self.view];
    
    //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
    self.shareView.numberOfButtonPerLine = 7;
    
    
    //设置分享到网络的视图
    [self shareToNetwork:lifeModel];
    
    [self.shareView show];
    
}

- (ButtonView *)shareToNetwork:(LifeModel *)lifeModel
{
    ButtonView *bv = [[ButtonView alloc]initWithText:@"新浪微博" image:[UIImage imageNamed:@"ShareIcon_SinaWeibo"] handler:^(ButtonView *buttonView)
                      {
                          //新浪微博
                          [WeiboSDKTool shareToWeiboWithContent:(lifeModel.contents.length >139 ? lifeModel.name :lifeModel.contents) image:[ImageUtilityTool imageFromScrollView:self.commetTableView] media:nil];
                      }];
    [self.shareView addButtonView:bv];
    
    bv = [[ButtonView alloc]initWithText:@"微信好友" image:[UIImage imageNamed:@"ShareIcon_Weixin"] handler:^(ButtonView *buttonView)
          {
              //微信
              [WeixinSDKTool sendImageContent:[ImageUtilityTool imageFromScrollView:self.commetTableView] scene:WXSceneTypeSession];
          }];
    [self.shareView addButtonView:bv];
    
    bv = [[ButtonView alloc]initWithText:@"微信朋友圈" image:[UIImage imageNamed:@"ShareIcon_WeixinZone"] handler:^(ButtonView *buttonView)
          {
              //微信朋友圈
              [WeixinSDKTool sendImageContent:[ImageUtilityTool imageFromScrollView:self.commetTableView] scene:WXSceneTypeTimeline];
          }];
    [self.shareView addButtonView:bv];
    
    bv = [[ButtonView alloc]initWithText:@"微信收藏" image:[UIImage imageNamed:@"ShareIcon_WeixinFav"] handler:^(ButtonView *buttonView)
          {
              //微信收藏
              [WeixinSDKTool sendImageContent:[ImageUtilityTool imageFromScrollView:self.commetTableView] scene:WXSceneTypeFavorite];
          }];
    [self.shareView addButtonView:bv];
    
    bv = [[ButtonView alloc]initWithText:@"QQ/空间" image:[UIImage imageNamed:@"ShareIcon_QQ"] handler:^(ButtonView *buttonView)
          {
              //QQ
              [QQSDKTool shareToWeiboWithImage:[ImageUtilityTool imageFromScrollView:self.commetTableView] title:lifeModel.name description:[NSString stringWithFormat:@"来自校园话题：%@",self.title]];
              
          }];
    
    [self.shareView addButtonView:bv];
    
    return bv;
}



#pragma mark - 更新点赞数
- (void)updataLickButton:(UIButton *)button lifeMode:(LifeModel *)lifeModel
{
    if (lifeModel.isLicked) {//如果已经点赞，则取消点赞
        
        NSString *lickCounts = [NSString stringWithFormat:@"%ld",([lifeModel.praises integerValue] -1)];
        
        [self.fetchTalkTool updataPraisesWithTableID:self.tableID IDs:lifeModel.ID newPraises:lickCounts success:^(NSArray *fetchArray)
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
        
        [self.fetchTalkTool updataPraisesWithTableID:self.tableID IDs:lifeModel.ID newPraises:lickCounts success:^(NSArray *fetchArray) {
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
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"评论" style:UIBarButtonItemStylePlain target:self action:@selector(commetBtnClicked)] animated:NO];
}

-(void)commetBtnClicked
{
    SendCommetsViewController  * sendVc = [[SendCommetsViewController alloc]init];
    sendVc.tableID = self.tableID;
    sendVc.lifeModel = self.lifeFrameModel.lifeModel;
    
    [self presentViewController:sendVc animated:YES completion:nil];
    
}


@end
