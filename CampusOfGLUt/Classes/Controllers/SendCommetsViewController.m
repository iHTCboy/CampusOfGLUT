//
//  SendCommetsViewController.m
//  CampusOfGLUT
//
//  Created by HTC on 15/3/30.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "SendCommetsViewController.h"
#import "CustomTextView.h"
#import "Utility.h"
#import "FetchLifeCircleTool.h"
#import "CRToastTool.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "KxMenu.h"

@interface SendCommetsViewController ()


@property (nonatomic,weak) UIImageView * headerImageView;
@property (nonatomic,weak) UITextField * nameFieldView;
@property (nonatomic,weak) CustomTextView * contentTextView;
@property (nonatomic,weak) UIImageView * addImageView;
@property (nonatomic,weak) UILabel * fromLabelView;
@property (nonatomic,weak) UIButton * sendBn;
/**
 *  发送失败的信息通知
 */
@property (nonatomic,weak) UILabel * infoLaabelView;
@property (nonatomic,copy) NSString * imageURL;

@property (nonatomic,assign) BOOL isSendSuccess;

@end

@implementation SendCommetsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviBarinit];
    
    [self initContentView];
    
}


#pragma mark - 发送
- (void)sendText
{
    
    //判断
    if (self.contentTextView.text.length == 0){
        [CRToastTool showNotificationWithTitle:@"主人评论点什么吧！" backgroundColor:[UIColor colorWithRed:1.000 green:0.213 blue:0.298 alpha:1.000] timeInterval:@(2.5) completionBlock:^{   }];;
        return;
    }
    
    self.sendBn.enabled = NO;
    FetchLifeCircleTool *tool = [FetchLifeCircleTool sharedFetchNewsTool];
    [tool sendCommentToLifeCircleWithTableID:self.tableID icon:[NSString stringWithFormat:@"%ld",(long)self.headerImageView.tag] name:self.nameFieldView.text contents:self.contentTextView.text comefrom:self.fromLabelView.text lifeModel:self.lifeModel success:^(NSArray *fetchArray)
     {
        self.isSendSuccess = YES;
        [self dismissVC];
        
    } failure:^(NSError *error) {
        [self.view endEditing:YES];
        self.sendBn.enabled = YES;
        
        if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
            
            [CRToastTool showNotificationWithTitle:@"网络好像出了点问题" backgroundColor:[UIColor colorWithRed:1.000 green:0.435 blue:0.812 alpha:1.000] timeInterval:@(2.5) completionBlock:^{   }];
        }else{
            self.infoLaabelView.text = [NSString stringWithFormat:@"发送失败，可能含有敏感词，\n 参考错误：%@\n \n 请“修改”后在发送啊😱🙈",error.domain];
            [CRToastTool showNotificationWithTitle:@"可能含有敏感词" backgroundColor:[UIColor colorWithRed:1.000 green:0.237 blue:0.374 alpha:1.000] timeInterval:@(2.5) completionBlock:^{   }];
        }
    }];
    
}


#pragma mark - 点击头像
- (void)tapHeaderImageView
{
    NSArray *titleArray=@[@"男童鞋",@"女童鞋",@"男老师",@"女老师"];
    
    //生成菜单项
    NSMutableArray *menuItems=[NSMutableArray array];
    for (int i=1; i<=titleArray.count; i++) {
        KxMenuItem *menuItem=[KxMenuItem menuItem:titleArray[i-1] index:i image:nil target:self action:@selector(menuItemSelected:)];
        NSString *imageNamge = [NSString stringWithFormat:@"iconView_%d",i];
        menuItem.image= [UIImage imageNamed:imageNamge];
        [menuItems addObject:menuItem];
    }
    //
    KxMenuItem *first = menuItems[self.headerImageView.tag -1];
    first.foreColor = [UIColor colorWithRed:0.046 green:0.674 blue:1.000 alpha:1.000];
    
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(20, 64, 40, 40)
                 menuItems:menuItems];
    
}

#pragma mark - 更换头像
-(void) menuItemSelected:(KxMenuItem*) item{
    
    NSString *imageNamge = [NSString stringWithFormat:@"iconView_%d",(int)item.index];
    self.headerImageView.image= [UIImage imageNamed:imageNamge];
    self.headerImageView.tag = item.index;
    
    NSLog(@"--%ld",(long)item.index);
    
}


#pragma mark - 关闭
- (void)dismissVC{
    
    //提示不保存
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.isSendSuccess) {
            [CRToastTool showNotificationWithTitle:@"评论成功" backgroundColor:[UIColor colorWithRed:0.251 green:0.796 blue:0.518 alpha:1.000] timeInterval:@(2.5) completionBlock:^{     }];
        }
    }];
}


#pragma mark 初始化视图
- (void)initContentView
{
    UIColor * bgColor = [UIColor colorWithWhite:0.947 alpha:0.530];
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64)];
    scrollView.alwaysBounceVertical = YES;
    scrollView.backgroundColor = bgColor;
    [self.view addSubview:scrollView];
    
    CGFloat marginW = 10;
    CGFloat marginH = 5;
    
    CGFloat headerWH = 40;
    
    UIImageView * headerV = [[UIImageView alloc]initWithFrame:CGRectMake(marginW, marginH, headerWH, headerWH)];
    headerV.image = [UIImage imageNamed:@"iconView_1"];
    headerV.tag = 1;
    headerV.userInteractionEnabled = YES;
    UITapGestureRecognizer * taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeaderImageView)];
    [headerV addGestureRecognizer:taps];
    [scrollView addSubview:headerV];
    self.headerImageView = headerV;
    
    UITextField * nameV = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headerV.frame) + marginW, marginH, UI_SCREEN_WIDTH - CGRectGetMaxX(headerV.frame) - marginW, 30)];
    nameV.placeholder = @"匿名评论";
    [scrollView addSubview:nameV];
    self.nameFieldView = nameV;
    
    
    CGFloat textH = 80;
    
    CustomTextView * textView = [[CustomTextView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(headerV.frame), UI_SCREEN_WIDTH -10, textH)];
    textView.placeholder = @"来，评论一下吧";
    textView.backgroundColor = bgColor;
    textView.font = [UIFont systemFontOfSize:17];
    [scrollView addSubview:textView];
    self.contentTextView = textView;
    
    
//    CGFloat imageHW = 80;
//    //    UIView * imageCV = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(textView.frame) + 5, imageHW, imageHW)];
//    //    imageCV.backgroundColor = bgColor;
//    //    [scrollView addSubview:imageCV];
//    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(textView.frame) + 5, imageHW, imageHW)];
//    imageV.image = [UIImage imageNamed:@"addPictureBgImage"];
//    imageV.userInteractionEnabled = YES;
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPicture)];
//    [imageV addGestureRecognizer:tap];
//    [scrollView addSubview:imageV];
//    self.addImageView = imageV;
    
    
    UILabel * fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 190, CGRectGetMaxY(textView.frame) + marginH, 150, 30)];
    fromLabel.textAlignment = NSTextAlignmentRight;
    fromLabel.font = [UIFont systemFontOfSize:13];
    fromLabel.textColor = kMianColor;
    //fromLabel.backgroundColor = bgColor;
    fromLabel.text =[@"来自：" stringByAppendingString:[Utility getCurrentDeviceModel]];
    [scrollView addSubview:fromLabel];
    self.fromLabelView = fromLabel;
    
    
    UILabel * infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(fromLabel.frame), UI_SCREEN_WIDTH -20, 200)];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = [UIColor redColor];
    infoLabel.numberOfLines = 0;
    
    self.infoLaabelView = infoLabel;
    
    [scrollView addSubview:infoLabel];
    
}

#pragma mark NaviInit
- (void)naviBarinit
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView * topColor = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    
    topColor.backgroundColor  = kMianColor;
    
    [self.view addSubview:topColor];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleLabel.center = CGPointMake(self.view.frame.size.width /2, 41);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"评论";
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:titleLabel];
    
    UIButton * backBn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBn  setFrame:CGRectMake(12, 30, 25, 25)];
    [backBn  setBackgroundImage:[UIImage imageNamed:@"navi_close_normol"] forState:UIControlStateNormal];
    [backBn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBn];
    
    
    UIButton * saveBn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveBn  setFrame:CGRectMake(self.view.frame.size.width - 50, 30, 40, 30)];
    [saveBn setTitle:@"发送" forState:UIControlStateNormal];
    saveBn.tintColor = [UIColor whiteColor];
    saveBn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [saveBn addTarget:self action:@selector(sendText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBn];
    self.sendBn = saveBn;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
