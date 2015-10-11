//
//  TCProtocolViewController.m
//  GLUTJWS
//
//  Created by HTC on 14-10-1.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//

#import "TCProtocolViewController.h"

@interface TCProtocolViewController ()

@end

@implementation TCProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //导航栏属性
    UIView *_navView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0, self.view.frame.size.width, 64)];
    ((UIImageView *)_navView).backgroundColor = [UIColor colorWithRed:0.046 green:0.674 blue:1.000 alpha:1.000];
    [self.view addSubview:_navView];
    _navView.userInteractionEnabled = YES;
    
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_navView.frame.size.width - 200)/2, (_navView.frame.size.height - 20)/2, 200, 40)];
    titleLabel.text = @"桂工教务用户服务条款";
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    

    //右栏
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rbtn setFrame:CGRectMake(_navView.frame.size.width - 45, 25, 40, 40)];
    [rbtn setTitle:@"关闭" forState:UIControlStateNormal];
    rbtn.adjustsImageWhenHighlighted = NO;
    [rbtn addTarget:self action:@selector(backMove) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:rbtn];
    

    UITextView * aboutGlut = [[UITextView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height -64)];
    
    aboutGlut.text = @"1、重要须知： 程序员在此特别提醒，用户（您）欲访问和使用桂工教务在线， 必须事先认真阅读本服务条款中各条款， 包括免除或者限制程序员责任的免责条款及对用户的权利限制。请您审阅并接受或不接受本服务条款。如您不同意本服务条款及/或随时对其的修改， 您应不使用或主动取消本应用提供的服务。您的使用行为将被视为您对本服务条款全部的完全接受， 包括接受程序员对服务条款随时所做的任何修改。\n\n2、这些条款可由程序员随时更新， 且毋须另行通知。桂工教务在线服务条款(以下简称“服务条款”)一旦发生变更， 程序员将在应用微博网页上公布修改内容（http://weibo.com/iHTCapp）。修改后的服务一旦在网页上公布即有效代替原来的服务条款。您可随时登陆应用微博查阅最新版服务条款。\n\n3、感谢你使用本应用，谢谢你的信任，本应用只会在本应用内部使用用户的数据信息，绝对不会盗用用户的信息。\n\n4、最后，我想要彻底澄清一点：我们从未与任何国家的任何政府机构就任何产品或服务建立过所谓的 \"后门\"。我们也从未开放过我们的服务器，并且永远不会。\n\n5、我们对保护个人隐私的承诺，源于对用户深深的尊重。我们知道，获得你的信任并非易事。也正因如此，我们才一如既往地全力以赴，来赢得并保持这份信任。\n\n\n   程序员: 何天从";
    
    aboutGlut.font = [UIFont systemFontOfSize:16];
    aboutGlut.editable = NO;
    [self.view addSubview:aboutGlut];

    
}

//点击左上角箭头时，返回
-(void)backMove
{
    //返回
    [self dismissViewControllerAnimated:YES completion:^{
        
        ;
    }];
    
}

@end
