//
//  HUDUtil.m
//  Trendpower
//
//  Created by HTC on 15/4/30.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//


// JGProgressHUD 默认风格 为灰黑色，没有交互，动画，没有背影和阴影
#define K_JGProgressHUD_Default_Style JGProgressHUDStyleDark
#define K_JGProgressHUD_InteractionType JGProgressHUDInteractionTypeBlockNoTouches
#define K_JGProgressHUD_Zoom YES
#define K_JGProgressHUD_Dim NO
#define K_JGProgressHUD_Shadow NO
#define K_JGProgressHUD_Delay 2.0


#import "HUDUtil.h"

@interface HUDUtil()<JGProgressHUDDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) UIAlertView * alertView;
@property (nonatomic,strong) UIActionSheet * actionSheet;
@property (nonatomic,strong) JGProgressHUD *HUD;

@end

@implementation HUDUtil
// 定义一份变量(整个程序运行过程中, 只有1份)
static id _instance;

- (id)init
{
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // 加载资源
            self.alertView = [[UIAlertView alloc]init];
            self.HUD = [JGProgressHUD progressHUDWithStyle:K_JGProgressHUD_Default_Style];
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

+ (instancetype)sharedHUDUtil
{
    // 里面的代码永远只执行1次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    // 返回对象
    return _instance;
}


- (void)dismissAllHUD{
    [self.HUD dismiss];
}

#pragma mark - UIAlertView
- (void)showAlertViewWithTitle:(NSString *)title mesg:(NSString *)mesg cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle tag:(NSInteger)tag{
    self.alertView = [[UIAlertView alloc]initWithTitle:title message:mesg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:confirmTitle, nil];
    self.alertView.tag = tag;
    self.alertView.delegate = self;
    [self.alertView show];
}

- (void)showActionSheetInView:(UIView *)view tag:(NSInteger)tag title:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    self.actionSheet = [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles, nil];
    self.actionSheet.tag = tag;
    self.actionSheet.delegate = self;
    self.actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [self.actionSheet showInView:view];
}

#pragma mark UIAlerViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([self.delegate respondsToSelector:@selector(hudAlertView:clickedAtIndex:tag:)]) {
        [self.delegate hudAlertView:YES clickedAtIndex:buttonIndex tag:alertView.tag];
    }
}


#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([self.delegate respondsToSelector:@selector(hudAlertView:clickedAtIndex:tag:)]) {
        [self.delegate hudAlertView:NO clickedAtIndex:buttonIndex tag:actionSheet.tag];
    }

}


#pragma mark - JGProgressHUD
// init
- (JGProgressHUD *)prototypeHUDStyle:(JGProgressHUDStyle)style interactionType:(JGProgressHUDInteractionType)interaction zoom:(BOOL)zoom dim:(BOOL)dim shadow:(BOOL)shadow{
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:style];
    HUD.interactionType = interaction;
    if (zoom) {
        JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
        HUD.animation = an;
    }
    
    if (dim) {
        HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    }
    
    if (shadow) {
        HUD.HUDView.layer.shadowColor = [UIColor blackColor].CGColor;
        HUD.HUDView.layer.shadowOffset = CGSizeZero;
        HUD.HUDView.layer.shadowOpacity = 0.4f;
        HUD.HUDView.layer.shadowRadius = 8.0f;
    }
    
    HUD.delegate = self;
    return HUD;
}

#pragma mark 文字提示
- (void)showTextHUDWithText:(NSString *)text inView:(UIView *)view{
    self.HUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:K_JGProgressHUD_Zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    self.HUD.indicatorView = nil;
    self.HUD.textLabel.font = [UIFont systemFontOfSize:18.0f];
    self.HUD.textLabel.text = text;
    self.HUD.position = JGProgressHUDPositionCenter;
    [self.HUD showInView:view];
    [self.HUD dismissAfterDelay:K_JGProgressHUD_Delay];
}

- (void)showTextHUDWithText:(NSString *)text delay:(NSTimeInterval)delay inView:(UIView *)view{
    self.HUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:K_JGProgressHUD_Zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    self.HUD.indicatorView = nil;
    self.HUD.textLabel.font = [UIFont systemFontOfSize:18.0f];
    self.HUD.textLabel.text = text;
    self.HUD.position = JGProgressHUDPositionCenter;
    [self.HUD showInView:view];
    [self.HUD dismissAfterDelay:delay];
}

- (void)showTextHUDWithText:(NSString *)text font:(UIFont *)font position:(JGProgressHUDPosition)position delay:(NSTimeInterval)delay inView:(UIView *)view{
    self.HUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:K_JGProgressHUD_Zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    self.HUD.indicatorView = nil;
    self.HUD.textLabel.font = font;
    self.HUD.textLabel.text = text;
    self.HUD.position = position;
    [self.HUD showInView:view];
    [self.HUD dismissAfterDelay:delay];
}

- (void)showTextHUDWithText:(NSString *)text font:(UIFont *)font position:(JGProgressHUDPosition)position marginInsets:(UIEdgeInsets)marginInsets delay:(NSTimeInterval)delay inView:(UIView *)view{
    self.HUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:K_JGProgressHUD_Zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    self.HUD.indicatorView = nil;
    self.HUD.textLabel.text = text;
    self.HUD.textLabel.font = font;
    self.HUD.position = position;
    self.HUD.marginInsets = marginInsets;
//    self.HUD.marginInsets = (UIEdgeInsets) {
//        .top = 0.0f,
//        .bottom = 20.0f,
//        .left = 0.0f,
//        .right = 0.0f,
//    };
    [self.HUD showInView:view];
    [self.HUD dismissAfterDelay:delay];
}

- (void)showTextHUDWithText:(NSString *)text position:(JGProgressHUDPosition)position marginInsets:(UIEdgeInsets)marginInsets delay:(NSTimeInterval)delay zoom:(BOOL)zoom inView:(UIView *)view{
    self.HUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    self.HUD.indicatorView = nil;
    self.HUD.textLabel.text = text;
    self.HUD.position = position;
    self.HUD.marginInsets = marginInsets;
    //    self.HUD.marginInsets = (UIEdgeInsets) {
    //        .top = 0.0f,
    //        .bottom = 20.0f,
    //        .left = 0.0f,
    //        .right = 0.0f,
    //    };
    [self.HUD showInView:view];
    [self.HUD dismissAfterDelay:delay];
}

- (void)showTextHUDWithStyle:(JGProgressHUDStyle)style interactionType:(JGProgressHUDInteractionType)interaction zoom:(BOOL)zoom dim:(BOOL)dim shadow:(BOOL)shadow text:(NSString *)text font:(UIFont *)font position:(JGProgressHUDPosition)position marginInsets:(UIEdgeInsets)marginInsets delay:(NSTimeInterval)delay inView:(UIView *)view{
    self.HUD = [self prototypeHUDStyle:style interactionType:interaction zoom:zoom dim:dim shadow:shadow];
    self.HUD.indicatorView = nil;
    self.HUD.textLabel.text = text;
    self.HUD.textLabel.font = font;
    self.HUD.position = position;
    self.HUD.marginInsets = marginInsets;
    //    self.HUD.marginInsets = (UIEdgeInsets) {
    //        .top = 0.0f,
    //        .bottom = 20.0f,
    //        .left = 0.0f,
    //        .right = 0.0f,
    //    };
    [self.HUD showInView:view];
    [self.HUD dismissAfterDelay:delay];
}

#pragma mark 加载中...
- (void)showLoadingHUDInTheView:(UIView *)view  {
    self.HUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:K_JGProgressHUD_Zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    [self.HUD showInView:view];
    [self.HUD dismissAfterDelay:K_JGProgressHUD_Delay];
}

- (void)showLoadingWithText:(NSString *)text HUDInTheView:(UIView *)view  {
    self.HUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:K_JGProgressHUD_Zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    self.HUD.textLabel.text = text;
    [self.HUD showInView:view];
    [self.HUD dismissAfterDelay:K_JGProgressHUD_Delay];
}

- (void)showLoadingHUDInTheView:(UIView *)view delay:(NSTimeInterval)delay {
    self.HUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:K_JGProgressHUD_Zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    [self.HUD showInView:view];
    [self.HUD dismissAfterDelay:delay];
}

#pragma mark 成功！
- (void)showSuccessHUDWithText:(NSString *)text inView:(UIView *)view{
    self.HUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:K_JGProgressHUD_Zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    self.HUD .textLabel.text = text;
    self.HUD .indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
    self.HUD .square = YES;
    [self.HUD  showInView:view];
    [self.HUD  dismissAfterDelay:K_JGProgressHUD_Delay];
}

- (void)showSuccessHUDWithText:(NSString *)text inView:(UIView *)view delay:(NSTimeInterval)delay {
    self.HUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:K_JGProgressHUD_Zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    self.HUD .textLabel.text = text;
    self.HUD .indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
    self.HUD .square = YES;
    [self.HUD  showInView:view];
    [self.HUD  dismissAfterDelay:delay];
}

#pragma mark 失败！
- (void)showErrorHUDWithText:(NSString *)text inView:(UIView *)view {
    self.HUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:K_JGProgressHUD_Zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    self.HUD .textLabel.text = text;
    self.HUD .indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    self.HUD .square = YES;
    [self.HUD  showInView:view];
    [self.HUD  dismissAfterDelay:K_JGProgressHUD_Delay];
}

- (void)showErrorHUDWithText:(NSString *)text inView:(UIView *)view  delay:(NSTimeInterval)delay {
    self.HUD = [self prototypeHUDStyle:K_JGProgressHUD_Default_Style interactionType:K_JGProgressHUD_InteractionType zoom:K_JGProgressHUD_Zoom dim:K_JGProgressHUD_Dim shadow:K_JGProgressHUD_Shadow];
    self.HUD .textLabel.text = text;
    self.HUD .indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    self.HUD .square = YES;
    [self.HUD  showInView:view];
    [self.HUD  dismissAfterDelay:delay];
}

#pragma mark 进度HUD


#pragma mark - JGProgressHUDDelegate

- (void)progressHUD:(JGProgressHUD *)progressHUD willPresentInView:(UIView *)view {
    NSLog(@"HUD %p will present in view: %p", progressHUD, view);
}

- (void)progressHUD:(JGProgressHUD *)progressHUD didPresentInView:(UIView *)view {
    NSLog(@"HUD %p did present in view: %p", progressHUD, view);
}

- (void)progressHUD:(JGProgressHUD *)progressHUD willDismissFromView:(UIView *)view {
    NSLog(@"HUD %p will dismiss from view: %p", progressHUD, view);
}

- (void)progressHUD:(JGProgressHUD *)progressHUD didDismissFromView:(UIView *)view {
    NSLog(@"HUD %p did dismiss from view: %p", progressHUD, view);
}



@end
