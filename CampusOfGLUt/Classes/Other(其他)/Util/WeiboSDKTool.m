//
//  WeiboSDKTool.m
//  CampusOfGLUT
//
//  Created by HTC on 15/2/21.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "WeiboSDKTool.h"

#import "AppDelegate.h"

#import "CRToastTool.h"

#define kRedirectURI    @"http://www.sina.com"

@implementation WeiboSDKTool




+ (void)shareToWeiboWithContent:(NSString *)text image:(UIImage *)image media:(NSDictionary *)dic
{
    //AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI;
    authRequest.scope = @"CampusOfGLUT";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShareWithContent:text image:image media:dic] authInfo:authRequest access_token:nil];
    request.userInfo = @{@"ShareMessageFrom": @"BaseWebViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],};
//    request.userInfo = @{@"ShareMessageFrom": @"BaseWebViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];

}


#pragma mark -
#pragma Internal Method

+ (WBMessageObject *)messageToShareWithContent:(NSString *)text image:(UIImage *)image media:(NSDictionary *)dic
{
    WBMessageObject *message = [WBMessageObject message];
    
    if (text)
    {
        message.text = text;
    }
    
    if (image)
    {
        
        WBImageObject *images = [WBImageObject object];
        images.imageData = UIImagePNGRepresentation(image);
        message.imageObject = images;
    }
    
    if (dic)
    {
//        WBWebpageObject *webpage = [WBWebpageObject object];
//        webpage.objectID = @"identifier1";
//        webpage.title = NSLocalizedString(@"分享网页标题", nil);
//        webpage.description = [NSString stringWithFormat:NSLocalizedString(@"分享网页内容简介-%.0f", nil), [[NSDate date] timeIntervalSince1970]];
//        webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_2" ofType:@"jpg"]];
//        webpage.webpageUrl = @"http://sina.cn?a=1";
//        message.mediaObject = webpage;
    }
    
    return message;
}


#pragma mark- WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        /**
         *
         WeiboSDKResponseStatusCodeSuccess               = 0,//成功
         WeiboSDKResponseStatusCodeUserCancel            = -1,//用户取消发送
         WeiboSDKResponseStatusCodeSentFail              = -2,//发送失败
         WeiboSDKResponseStatusCodeAuthDeny              = -3,//授权失败
         WeiboSDKResponseStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
         WeiboSDKResponseStatusCodePayFail               = -5,//支付失败
         WeiboSDKResponseStatusCodeShareInSDKFailed      = -8,//分享失败 详情见response UserInfo
         WeiboSDKResponseStatusCodeUnsupport             = -99,//不支持的请求
         WeiboSDKResponseStatusCodeUnknown               = -100,
         */
        
        switch (response.statusCode) {
            case 0:
                [CRToastTool showNotificationWithTitle:@"分享成功" backgroundColor:[UIColor colorWithRed:0.251 green:0.796 blue:0.518 alpha:1.000] timeInterval:@1 completionBlock:nil];
                break;
            case -1:
                [CRToastTool showNotificationWithTitle:@"分享取消" backgroundColor:[UIColor colorWithRed:0.975 green:0.358 blue:0.421 alpha:1.000] timeInterval:@1 completionBlock:nil];
                break;
            case -2:
                [CRToastTool showNotificationWithTitle:@"分享失败" backgroundColor:[UIColor colorWithRed:0.975 green:0.630 blue:0.061 alpha:1.000] timeInterval:@1 completionBlock:nil];
                break;
            case -3:
                [CRToastTool showNotificationWithTitle:@"授权失败" backgroundColor:[UIColor colorWithRed:0.351 green:0.467 blue:0.998 alpha:1.000] timeInterval:@1 completionBlock:nil];
                break;
            case -4:
                [CRToastTool showNotificationWithTitle:@"安装取消" backgroundColor:[UIColor colorWithRed:0.896 green:0.399 blue:0.998 alpha:1.000] timeInterval:@1 completionBlock:nil];
                break;
            case -5:
                [CRToastTool showNotificationWithTitle:@"支付失败" backgroundColor:[UIColor colorWithRed:0.149 green:0.796 blue:0.263 alpha:1.000] timeInterval:@1 completionBlock:nil];
                break;
            default:
                [CRToastTool showNotificationWithTitle:@"未知错误" backgroundColor:[UIColor colorWithRed:1.000 green:0.243 blue:0.306 alpha:1.000] timeInterval:@1 completionBlock:nil];
                break;
                
        }
        //        NSString *title = NSLocalizedString(@"发送结果", nil);
        //        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
        //                                                        message:message
        //                                                       delegate:nil
        //                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
        //                                              otherButtonTitles:nil];
        //        
        //        [alert show];
    }
    
}

@end
