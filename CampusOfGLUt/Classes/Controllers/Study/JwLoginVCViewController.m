//
//  JwLoginVCViewController.m
//  CampusOfGLUT
//
//  Created by HTC on 15/4/30.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#define TCCoror(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#import "JwLoginVCViewController.h"
#import "HUDUtil.h"
#import "DXAlertView.h"
#import "TCProtocolViewController.h"
#import "JWTableViewController.h"

@interface JwLoginVCViewController ()<UITextFieldDelegate>


@property (nonatomic, weak) UITextField * name;
@property (nonatomic, weak) UITextField * password;
@property (nonatomic, weak) UITextField * captchaYZM;
@property (nonatomic, weak) UIImageView * imageYZM;
@property (nonatomic, weak) UISwitch * switchPassword;
@property (nonatomic, weak) UILabel * holdPassword;
@property (nonatomic, weak) UILabel * logoutLabel;
@property (nonatomic, weak) UISwitch * switchLogout;
@property (nonatomic, weak) UIView * l4;
@property (nonatomic, weak) UIView * l5;

@property (nonatomic, weak) UIButton * loginBut;

@property (nonatomic, weak) UIButton * yBut;
@property (nonatomic, weak) UIButton * sBut;

@end

@implementation JwLoginVCViewController

#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if(self.name.text.length >0){
        [self loadYZM];
    }
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
}

#pragma mark - initView
- (void)initView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    //背景
    UIImageView * backImage = [[UIImageView alloc ]initWithFrame:self.view.bounds];
    backImage.image = [UIImage imageNamed:@"loginB.png"];
    [self.view addSubview:backImage];
    
    //back
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(15, 29, 70, 35)];
    btn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.40];
    btn.layer.cornerRadius = 5.0;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backNavi) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //logo
    UIImageView * logo = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x -50, self.view.center.y * 1/8, 100, 100)];
    logo.image = [UIImage imageNamed:@"login.png"];
    
    // logo.layer.cornerRadius = 50;
    //logo.layer.masksToBounds = YES;
    //logo.layer.borderWidth = 1;
    // logo.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:logo];
    
    
    //分隔线
    UIView * l1 = [[UIView alloc ]initWithFrame:CGRectMake(0, self.view.center.y * 1.1/2, self.view.frame.size.width, 40)];
    l1.backgroundColor = TCCoror(239, 239, 239);
    [self.view addSubview:l1];
    
    
    //学号栏
    UITextField * name = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.1, self.view.center.y * 1.1/2, self.view.frame.size.width * 0.8, 40)];
    if (self.isStudent) {
        name.placeholder = @"学号";
    }else{
        name.placeholder = @"教工号";
    }
    name.textAlignment = NSTextAlignmentCenter;
    name.clearButtonMode = UITextFieldViewModeWhileEditing;
    name.keyboardType = UIKeyboardTypeNamePhonePad;
    name.returnKeyType = UIReturnKeyGo;
    name.backgroundColor = TCCoror(239, 239, 239);
    self.name = name;
    [self.view addSubview:name];
    
    //设置通知，当文字改变是，存储帐号
    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(nameChanged) name:UITextFieldTextDidEndEditingNotification object:name];
    
    
    //分隔线
    UIView * l2 = [[UIView alloc ]initWithFrame:CGRectMake(0, self.view.center.y * 1.1/2 + 40, self.view.frame.size.width, 0.5)];
    l2.backgroundColor = TCCoror(180, 180, 180);
    [self.view addSubview:l2];
    
    
    UIView * l3 = [[UIView alloc ]initWithFrame:CGRectMake(0, self.view.center.y * 1.1/2 + 40.5, self.view.frame.size.width, 40)];
    l3.backgroundColor = TCCoror(239, 239, 239);
    [self.view addSubview:l3];
    
    //密码栏
    UITextField * password = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.1, self.view.center.y * 1.1/2 + 40.5, self.view.frame.size.width * 0.8, 40)];
    password.placeholder = @"密码";
    password.textAlignment = NSTextAlignmentCenter;
    password.secureTextEntry = YES;
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    password.keyboardType = UIKeyboardTypeNamePhonePad;
    password.returnKeyType = UIReturnKeyGo;
    password.backgroundColor = TCCoror(239, 239, 239);
    self.password = password;
    [self.view addSubview:password];
    
    //设置通知，当文字改变是，存储帐号
    [defaultCenter addObserver:self selector:@selector(passwordTextChanged) name:UITextFieldTextDidEndEditingNotification object:password];
    
    
    //分隔线
    UIView * l4 = [[UIView alloc ]initWithFrame:CGRectMake(0, self.view.center.y * 1.1/2 + 80.5, self.view.frame.size.width, 0.5)];
    l4.backgroundColor = TCCoror(180, 180, 180);
    [self.view addSubview:l4];
    self.l4 = l4;
    
    
    UIView * l5 = [[UIView alloc ]initWithFrame:CGRectMake(0, self.view.center.y * 1.1/2 + 81, self.view.frame.size.width, 40)];
    l5.backgroundColor = TCCoror(239, 239, 239);
    [self.view addSubview:l5];
    self.l5 = l5;
    
    //验证码文本框
    UITextField * captchaYZM = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.3, self.view.center.y * 1.1/2 + 81, self.view.frame.size.width * 0.4, 40)];
    captchaYZM.placeholder = @"验证码";
    captchaYZM.textAlignment = NSTextAlignmentCenter;
    captchaYZM.clearButtonMode = UITextFieldViewModeWhileEditing;
    captchaYZM.keyboardType = UIKeyboardTypeNumberPad;
    captchaYZM.returnKeyType = UIReturnKeyJoin;
    captchaYZM.backgroundColor = TCCoror(239, 239, 239);
    captchaYZM.delegate = self;
    self.captchaYZM = captchaYZM;
    [self.view addSubview:captchaYZM];
    
    //验证码图片
    UIImageView * imageYZM = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.75, self.view.center.y * 1.1/2 + 82, 85, 35)];
    imageYZM.contentMode = UIViewContentModeScaleAspectFit;
    imageYZM.backgroundColor = TCCoror(239, 239, 239);
    imageYZM.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadYZM)];
    [imageYZM addGestureRecognizer:singleTap];
    self.imageYZM = imageYZM;
    [self.view addSubview:imageYZM];
    
    
    //登陆按钮
    UIButton * login = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.1, self.view.center.y * 1.1/2 + 130, self.view.frame.size.width * 0.8, 30)];
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
        login.frame = CGRectMake(self.view.frame.size.width * 0.1, self.view.center.y * 1.1/2 + 130, self.view.frame.size.width * 0.8, 60);
    }
    
    [login setTitle:@"登录" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [login setTitleColor:TCCoror(186, 186, 192) forState:UIControlStateDisabled];
    login.adjustsImageWhenHighlighted = NO;
    [login addTarget:self action:@selector(loginVeb) forControlEvents:UIControlEventTouchUpInside];
    login.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    //login.titleLabel.textColor = [UIColor blackColor];
    login.layer.cornerRadius = 3.5;
    login.layer.masksToBounds = YES;
    //login.layer.borderWidth = 1;
    //login.layer.borderColor = [UIColor whiteColor].CGColor;
    login.backgroundColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1];
    self.loginBut = login;
    [self.view addSubview:login];
    
    
    
    //记住密码功能
    UILabel * holdPassword = [[UILabel alloc ]initWithFrame:CGRectMake(self.view.frame.size.width * 0.58, CGRectGetMaxY(login.frame) +5, 70, 30)];
    holdPassword.text = @"记住密码";
    holdPassword.textColor = [UIColor whiteColor];
    self.holdPassword = holdPassword;
    [self.view addSubview:holdPassword];
    
    
    
    UISwitch * switchPassword = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.58 + 70,CGRectGetMaxY(login.frame) +5, 51, 31)];
    switchPassword.onTintColor =  [UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1];
    switchPassword.tintColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1];
    [switchPassword addTarget:self action:@selector(switchChanged) forControlEvents:UIControlEventValueChanged];
    [switchPassword setOn:NO];
    //[switchPassword setOn:YES animated:YES];
    self.switchPassword = switchPassword;
    [self.view addSubview:switchPassword];
    
    //    //离线模式
    UILabel * logoutLabel = [[UILabel alloc ]initWithFrame:CGRectMake(self.view.frame.size.width * 0.06, CGRectGetMaxY(login.frame) +5, 70, 30)];
    logoutLabel.text = @"离线模式";
    logoutLabel.textColor = [UIColor whiteColor];
    self.logoutLabel = logoutLabel;
    [self.view addSubview:logoutLabel];
    
    
    UISwitch * switchLogout = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.06 +70,CGRectGetMaxY(login.frame) +5, 80, 31)];
    switchLogout.onTintColor =  [UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1];
    switchLogout.tintColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1];
    [switchLogout addTarget:self action:@selector(switchLogouted) forControlEvents:UIControlEventValueChanged];
    [switchLogout setOn:NO];
    //[switchLogout setOn:YES animated:YES];
    self.switchLogout = switchLogout;
    [self.view addSubview:switchLogout];
    
    
    //隐藏离线
    logoutLabel.hidden = YES;
    switchLogout.hidden = YES;
    
    
    //隐私政策
    UIButton * yBut = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.15, CGRectGetMaxY(switchPassword.frame) +8, 20, 20)];
    [yBut setBackgroundImage:[UIImage imageNamed:@"ybtnNO.png"] forState:UIControlStateNormal];
    [yBut setBackgroundImage:[UIImage imageNamed:@"ybtn.png"] forState:UIControlStateSelected];
    [yBut addTarget:self action:@selector(ysBut) forControlEvents:UIControlEventTouchUpInside];
    //点击选中时，颜色不改变
    yBut.adjustsImageWhenHighlighted = NO;
    yBut.selected = YES;
    self.yBut = yBut;
    [self.view addSubview:yBut];
    
    
    UILabel * sLabel = [[UILabel alloc ]initWithFrame:CGRectMake(self.view.frame.size.width * 0.15 +25, CGRectGetMaxY(switchPassword.frame) +5, 105, 30)];
    sLabel.text = @"我已经阅读并同意";
    sLabel.font = [UIFont systemFontOfSize:13];
    sLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:sLabel];
    
    UIButton * sBut = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.15 + 132, CGRectGetMaxY(switchPassword.frame) +5, 120, 30)];
    [sBut setTitle:@"使用条款和隐私政策" forState:UIControlStateNormal];
    [sBut setTitleColor:[UIColor colorWithRed:0/255.0 green:100/255.0 blue:252/255.0 alpha:1] forState:UIControlStateNormal];
    sBut.titleLabel.font = [UIFont systemFontOfSize:13];
    [sBut addTarget:self action:@selector(tosBut) forControlEvents:UIControlEventTouchUpInside];
    self.sBut = sBut;
    [self.view addSubview:sBut];
    
    
    
    //自定义文本框的键盘工具
    [name setInputAccessoryView:[self keyToolbar]];
    [password setInputAccessoryView:[self keyToolbar]];
    [captchaYZM setInputAccessoryView:[self keyToolbar]];
    
    
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    //判断是否有存储帐号，如果有，就显示出来
    if ([defaults valueForKey:@"name"])
    {
        self.name.text = [defaults valueForKey:@"name"];
    }
    
    
    //判断开关，如果开关开了，就显示密码
    if ([defaults boolForKey:@"switchPassword"])
    {
        [self.switchPassword setOn:[defaults boolForKey:@"switchPassword"]];
        self.password.text = [defaults valueForKey:@"password"];
        self.holdPassword.text = @"已记密码";
    }
    else
    {
        self.password.text = @"";
        
    }
    
    //判断是否离线模式，如果不是就加载验证码，否则隐藏验证码框和背景
    if (![defaults boolForKey:@"switchLogout"])
    {
        //加载验证码
        //        [self loadYZM];
        //1秒后，加载验证码
        // self performSelector:@selector(loadYZM) withObject:self afterDelay:1];
        [self performSelectorInBackground:@selector(loadYZM) withObject:nil];
        
    }
    else
    {
        [switchLogout setOn:YES];
        self.logoutLabel.text = @"正在离线";
        [self.captchaYZM setHidden:YES];
        [self.imageYZM setHidden:YES];
        [self.l4 setHidden:YES];
        [self.l5 setHidden:YES];
        
    }
}

#pragma mark - back 
- (void)backNavi{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 勾选协议按钮
-(void)ysBut
{
    if (! self.yBut.selected){
        self.yBut.selected = YES;
        self.loginBut.enabled = YES;
        self.loginBut.backgroundColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1];
        
    }else{
        self.yBut.selected = NO;
        self.loginBut.enabled = NO;
        self.loginBut.backgroundColor = TCCoror(210, 210, 213);
    }
    
}

#pragma mark - 查看协议内容
-(void)tosBut
{
    TCProtocolViewController * toPController = [[TCProtocolViewController alloc]init];
    [self presentViewController:toPController animated:YES completion:^{
        
    }];
}

#pragma mark - viewDidAppear
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    DXAlertView * userProtocol = [[DXAlertView alloc]initWithTitle:@"教务在线" contentText:@"欢迎使用校园通教务在线，期待您到AppStore评价本应用" leftButtonTitle:@"不谢" rightButtonTitle:@"谢谢"];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    //如果是第一次和用户不接受协议，启动时，显示协议提示框
    if (![defaults boolForKey:@"userProtocol"])
    {
        [userProtocol show];
    }
    
    //点击接受后，不要显示提示框
    userProtocol.rightBlock = ^()
    {
        [defaults setBool:YES forKey:@"userProtocol"];
        [defaults synchronize];
    };
    
    //点击拒绝，下次在提示
    userProtocol.leftBlock = ^()
    {
        [defaults setBool:NO forKey:@"userProtocol"];
        [defaults synchronize];
    };
    
    
}



#pragma mark - 记住密码开关改变，并存储起来
-(void)switchChanged
{
    HUDUtil * hud = [HUDUtil sharedHUDUtil];
    
    if ([self.name.text isEqualToString:@""] && [self.password.text isEqualToString:@""]){
        [hud showErrorHUDWithText:@"学号和密码不能为空" inView:self.view];
        [self.switchPassword setOn:NO];
        return;
        
    }
    else if ([self.name.text isEqualToString:@""])
    {
        [hud showErrorHUDWithText:@"学号不能为空" inView:self.view];
        [self.switchPassword setOn:NO];
        return;
    }
    else if ([self.password.text isEqualToString:@""])
    {
        [hud showErrorHUDWithText:@"密码不能为空" inView:self.view];
        [self.switchPassword setOn:NO];
        return;
    }
    
    
    
    NSUserDefaults * defaults =[NSUserDefaults standardUserDefaults];
    [defaults setBool:self.switchPassword.isOn forKey:@"switchPassword"];
    [defaults synchronize];
    
    //如果开关打开，就是记住密码
    if (self.switchPassword.isOn)
    {
        [defaults setValue:self.password.text forKey:@"password"];
        [defaults synchronize];
        self.holdPassword.text = @"已记密码";
    }
    else
    {
        
        self.holdPassword.text = @"记住密码";
        
    }
    
}

#pragma mark - 监听密码栏，密码被改变时，记住密码功能自动取消
-(void)passwordTextChanged
{
    [self.switchPassword setOn:NO animated:YES];
    
    NSUserDefaults * defaults =[NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"switchPassword"];
    [defaults synchronize];
}

#pragma mark - 监听学号栏，当文字改变，就存储帐号，当帐号改变时，记住密码功能自己取消
-(void)nameChanged
{
    [self.switchPassword setOn:NO animated:YES];
    
    NSUserDefaults * defaults =[NSUserDefaults standardUserDefaults];
    [defaults setValue:self.name.text forKey:@"name"];
    [defaults synchronize];
    
}

#pragma mark -
-(void)switchLogouted
{
    NSUserDefaults * defaults =[NSUserDefaults standardUserDefaults];
    
    BOOL show = [defaults boolForKey:@"neverShow"];
    
    
    
    
    //如果开关打开，就是离线模式
    if (self.switchLogout.isOn && !show)
    {
        
        DXAlertView * logoutAlert = [[DXAlertView alloc]initWithTitle:@"离线模式" contentText:@"亲，在离线模式下，即使手机没有网络，也可以登陆哦，妈妈在也不用担心我的花流量不够花啦！" leftButtonTitle:@"不再提醒" rightButtonTitle:@"确定"];
        
        
        
        [logoutAlert show];
        
        self.logoutLabel.text = @"正在离线";
        [self.captchaYZM setHidden:YES];
        [self.imageYZM setHidden:YES];
        [self.l4 setHidden:YES];
        [self.l5 setHidden:YES];
        
        [defaults setBool:self.switchLogout.isOn forKey:@"switchLogout"];
        [defaults synchronize];
        
        logoutAlert.leftBlock = ^()
        {
            [defaults setBool:YES forKey:@"neverShow"];
            [defaults synchronize];
        };
        
        return;
        
    }
    else if(self.switchLogout.isOn && show)//判断,提示离线模式的功能
    {
        self.logoutLabel.text = @"正在离线";
        [self.captchaYZM setHidden:YES];
        [self.imageYZM setHidden:YES];
        [self.l4 setHidden:YES];
        [self.l5 setHidden:YES];
        
        [defaults setBool:self.switchLogout.isOn forKey:@"switchLogout"];
        [defaults synchronize];
        
        return;
        
    }
    else if(! self.switchLogout.isOn)
    {
        //加载验证码
        //[self loadYZM];
        //1秒后，加载验证码
        //[self performSelector:@selector(loadYZM) withObject:self afterDelay:1];
        [self performSelectorInBackground:@selector(loadYZM) withObject:nil];
        
        
        self.captchaYZM.text = @"";
        
        self.logoutLabel.text = @"离线模式";
        [self.captchaYZM setHidden:NO];
        [self.imageYZM setHidden:NO];
        [self.l4 setHidden:NO];
        [self.l5 setHidden:NO];
        
        [defaults setBool:self.switchLogout.isOn forKey:@"switchLogout"];
        [defaults synchronize];
        
        return;
        
    }
    
    
}


#pragma mark - 自定义键盘的初始化
-(UIToolbar *)keyToolbar
{
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    [topView setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem* oneBen = [[UIBarButtonItem alloc]initWithTitle:@"隐藏" style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboard)];
    oneBen.tintColor = [UIColor redColor];
    
    UIBarButtonItem* spaceBn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * done = [[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(toLogin)];
    
    NSArray * doneArray = [NSArray arrayWithObjects:oneBen, spaceBn, done,nil];
    
    [topView setItems:doneArray];
    
    return topView;
    
}


#pragma mark - 重新加载验证码
-(void)loadYZM
{
    
    //    NSURL *url = [NSURL URLWithString:@"http://202.193.80.58/academic/getCaptcha.do"];
    //
    //
    //    NSData * imageDate = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://202.193.80.58/academic/getCaptcha.do"]];
    //
    //    UIImage * newImage = [UIImage  imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://202.193.80.58/academic/getCaptcha.do"]]];http://202.193.80.58:81
    
    self.imageYZM.image = [self imageFromImage:[UIImage  imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://202.193.80.58:81/academic/getCaptcha.do"]]]inRect:CGRectMake(0, 0,70, 17)];
    
    
}



#pragma mark - YZM截图方法
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}


#pragma mark - 点击键盘左边隐藏按钮，隐藏键盘
-(void)hideKeyboard
{
    
    [self.view endEditing:YES];
    
}


#pragma mark - 点击空白区域，隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
}


#pragma mark - 键盘登陆
-(void)toLogin
{
    [self loginVeb];
    
}


#pragma mark - 登陆
-(void)loginVeb
{
    HUDUtil * hud = [HUDUtil sharedHUDUtil];
    
    //判断是否离线模式，如果不是，就加载对应的学生信息
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"switchLogout"])
    {
        if(![self.name.text length])
        {
            
            [hud showErrorHUDWithText:@"学号不能为空！"inView:self.view];
            return ;
        }
        if(![self.password.text length])
        {
            [hud showErrorHUDWithText:@"密码不能为空！" inView:self.view];
            return ;
        }
        if(![self.captchaYZM.text length])
        {
            [hud showErrorHUDWithText:@"验证码不能为空！" inView:self.view];
            return ;
        }
        
    }
    
    
    [hud showLoadingWithText:@"加载中..." HUDInTheView:self.view];
    
    [self.captchaYZM resignFirstResponder];
    [self.name resignFirstResponder];
    [self.password resignFirstResponder];
    
    //判断离线开关是否打开，如果打开，直接离线登陆
    if (self.switchLogout.isOn)
    {
        [hud dismissAllHUD];
        JWTableViewController * jw = [[JWTableViewController alloc]init];
        jw.isStudent = self.isStudent;
        [self.navigationController pushViewController:jw animated:YES];
        [hud dismissAllHUD];
        
    }else{
        
        [self postLogon];
    }
    
    //[self accessToken];
    
}


#pragma mark - 请求网络
- (void)postLogon
{
    // 1. URL
    NSURL *url = [NSURL URLWithString:@"http://202.193.80.58:81/academic/j_acegi_security_check"];
    
    // 2. 请求(可以改的请求)
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 10.0f;
    
    // ? POST
    // 默认就是GET请求
    request.HTTPMethod = @"POST";
    // ? 数据体
    NSString *str = [NSString stringWithFormat:@"j_username=%@&j_password=%@&j_captcha=%@",self.name.text,self.password.text,self.captchaYZM.text];
    
    // NSString *str = [NSString stringWithFormat:@"j_username=%@&j_password=%@&j_captcha=%@&button1=%@",@"3110757101",@"1",captchaYZM.text,@"登录"];
    // 将字符串转换成数据
    
    
    // NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    
    request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    // 3. 连接,异步
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        HUDUtil * hud = [HUDUtil sharedHUDUtil];
        
        if (connectionError == nil) {
            // 网络请求结束之后执行!
            // 将Data转换成字符串
            NSString * loginUrl =[NSString stringWithFormat:@"%@",response.URL];
            
            NSRange range = [loginUrl rangeOfString:@"index_new"];
            
            //判断字符串是否包含
            if (range.length >0)//包含,登陆成功
            {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                //判断记住密码功能，不记住就清空
                if (![defaults boolForKey:@"switchPassword"]){
                    self.password.text = @"";
                }
                
                self.captchaYZM.text = @"";
                [hud dismissAllHUD];
                JWTableViewController * jw = [[JWTableViewController alloc]init];
                jw.isStudent = self.isStudent;
                self.navigationController.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:jw animated:YES];
                
            }else{//不包含
                
                DXAlertView * alert = [[DXAlertView alloc]initWithTitle:@"提示" contentText:@"您输入的帐号或密码有误，请重新登陆" comfirmTitle:@"确定"];
                
                [alert show];
                
                [hud dismissAllHUD];
                
                //由于密码和验证码不能自己记录，所以出错后，自己清空，刷新验证码，这就是用户体验
                self.password.text = @"";
                self.captchaYZM.text = @"";
                [self loadYZM];
                
                
            }
            
        }else {
            
            
            DXAlertView * alert = [[DXAlertView alloc]initWithTitle:@"提示" contentText:@"网络繁忙，请重新登陆，或稍后在尝试" comfirmTitle:@"确定"];
            
            [alert show];
            [hud dismissAllHUD];
            alert.comfirmBlock = ^() {
                NSLog(@"comfirm button clicked");
            };
            
            alert.dismissBlock = ^() {
                NSLog(@"Do something interesting after dismiss block");
            };
            
            
            //刷新验证码，并且将文本框清空
            [self loadYZM];
            self.captchaYZM.text = @"";
            
        }
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
