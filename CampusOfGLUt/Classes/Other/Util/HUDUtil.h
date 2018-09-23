//
//  HUDUtil.h
//  Trendpower
//
//  Created by HTC on 15/4/30.
//  Copyright (c) 2015年 trendpower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if JGProgressHUD_Framework
#import <JGProgressHUD/JGProgressHUD.h>
#else
#import "JGProgressHUD.h"
#endif


@protocol HUDAlertViewDelegate <NSObject>

@optional
- (void)hudAlertView:(BOOL)isAlertView clickedAtIndex:(NSInteger)buttonIndex tag:(NSInteger)tag;
- (void)showActionSheetInView:(UIView *)view tag:(NSInteger)tag title:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... ;
@end


@interface HUDUtil : NSObject

@property (nonatomic,weak) id<HUDAlertViewDelegate>delegate;

+ (instancetype)sharedHUDUtil;

- (void)dismissAllHUD;

/**  UIAlertView */
- (void)showAlertViewWithTitle:(NSString *)title mesg:(NSString *)mesg cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle tag:(NSInteger)tag;
- (void)showActionSheetInView:(UIView *)view tag:(NSInteger)tag title:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... ;

/**  JGProgressHUD */
// CustomTextHUD
- (void)showTextHUDWithText:(NSString *)text inView:(UIView *)view;
- (void)showLoadingWithText:(NSString *)text HUDInTheView:(UIView *)view;
- (void)showTextHUDWithText:(NSString *)text delay:(NSTimeInterval)delay inView:(UIView *)view;
- (void)showTextHUDWithText:(NSString *)text font:(UIFont *)font position:(JGProgressHUDPosition)position delay:(NSTimeInterval)delay inView:(UIView *)view;
- (void)showTextHUDWithText:(NSString *)text font:(UIFont *)font position:(JGProgressHUDPosition)position marginInsets:(UIEdgeInsets)marginInsets delay:(NSTimeInterval)delay inView:(UIView *)view;
- (void)showTextHUDWithText:(NSString *)text position:(JGProgressHUDPosition)position marginInsets:(UIEdgeInsets)marginInsets delay:(NSTimeInterval)delay zoom:(BOOL)zoom inView:(UIView *)view;
- (void)showTextHUDWithStyle:(JGProgressHUDStyle)style interactionType:(JGProgressHUDInteractionType)interaction zoom:(BOOL)zoom dim:(BOOL)dim shadow:(BOOL)shadow text:(NSString *)text font:(UIFont *)font position:(JGProgressHUDPosition)position marginInsets:(UIEdgeInsets)marginInsets delay:(NSTimeInterval)delay inView:(UIView *)view;
// LoadingHUD
- (void)showLoadingHUDInTheView:(UIView *)view ;
- (void)showLoadingHUDInTheView:(UIView *)view delay:(NSTimeInterval)delay;
// SuccessTextHUD
- (void)showSuccessHUDWithText:(NSString *)text inView:(UIView *)view;
- (void)showSuccessHUDWithText:(NSString *)text inView:(UIView *)view delay:(NSTimeInterval)delay;
// ErrorTextHUD
- (void)showErrorHUDWithText:(NSString *)text inView:(UIView *)view;
- (void)showErrorHUDWithText:(NSString *)text inView:(UIView *)view delay:(NSTimeInterval)delay;

@end
