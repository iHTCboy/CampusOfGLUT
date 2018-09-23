//
//  InformationHandleTool.h
//  CampusOfGLUT
//
//  Created by HTC on 15/2/23.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "AFNetworking.h"

@interface InformationHandleTool : NSObject<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

+ (instancetype)sharedInfoTool;

/**
 *  发送短信
 */
- (void)sendSMSWithBody:(NSString *)body recipients:(NSArray *)recipients controller:(UIViewController *)vc;

/**
 *  发送邮件
 */
- (void)sendEmailWithSubject:(NSString *)subject MessageBody:(NSString *)MessageBody isHTML:(BOOL)isHTML toRecipients:(NSArray *)recipients  ccRecipients:(NSArray *)ccRecipients bccRecipients:(NSArray *)bccRecipients Image:(UIImage *)image imageQuality:(CGFloat)quality Controller:(UIViewController *)vc;

/**
 *  打电话
 */
- (void)makeCallPhoneNumber:(NSString *)phoneNumber;

/**
 *  从Safari打开
 */
- (void)inSafariOpenWithURL:(NSString *)url;

/**
 *  从AppStore打开
 */
- (void)inAppStoreWithID:(NSString *)ID;

/**
 *  //打开系统拍照机
 */
- (void)openCamera:(UIViewController *)vc;

/**
 *  //打开系统照片库
 */
- (void)openPhotoLibrary:(UIViewController *)vc;

/**
 *  查看版本更新
 */
- (void)checkUpdateWithAppID:(NSString *)appID success:(void (^)(NSDictionary *resultDic , BOOL isNewVersion , NSString * newVersion))success failure:(void (^)(NSError *error))failure;


/**
 *  是否为iPhone
 */
- (BOOL)isDeviceOfiPhone;

@end
