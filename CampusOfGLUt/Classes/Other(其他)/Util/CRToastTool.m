//
//  CRToastTool.m
//  CampusOfGLUT
//
//  Created by HTC on 15/3/2.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "CRToastTool.h"
#import "CRToast.h"

@implementation CRToastTool

+ (void)dismissAllNotifications
{
    [CRToastManager dismissAllNotifications:YES];
}

+ (void)showNotificationWithTitle:(NSString *)title backgroundColor:(UIColor *)color completionBlock:(void (^)(void))completion
{
    [CRToastManager showNotificationWithOptions:[self optionsWithMessage:title backgroundColor:color timeInterval:nil] completionBlock:completion];
}

+ (void)showNotificationWithTitle:(NSString *)title backgroundColor:(UIColor *)color timeInterval:(NSNumber*)timeInterval completionBlock:(void (^)(void))completion
{
    [CRToastManager showNotificationWithOptions:[self optionsWithMessage:title backgroundColor:color timeInterval:timeInterval] completionBlock:completion];
}


+ (NSDictionary*)optionsWithMessage:(NSString *)message  backgroundColor:(UIColor *)backgroundColor timeInterval:(NSNumber*)timeInterval
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
                                      kCRToastTimeIntervalKey : timeInterval?timeInterval:@(2),
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
