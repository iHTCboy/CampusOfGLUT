//
//  QQSKDTool.m
//  CampusOfGLUT
//
//  Created by HTC on 15/2/27.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "QQSDKTool.h"
#import "CRToastTool.h"

@implementation QQSDKTool

+ (void)shareToWeiboWithImage:(UIImage *)image title:(NSString *)title description:(NSString *)description
{
    //开发者分享图片数据
    NSData *imgData = UIImagePNGRepresentation(image);
    NSData *previewImage = UIImageJPEGRepresentation(image, 0.2);
    
    //用于分享图片内容的对象
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
                                               previewImageData:previewImage
                                                          title:title
                                                    description:description];
    //请求帮助类
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    //将内容分享到qq
    //QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [QQApiInterface sendReq:req];
}

#pragma mark -  QQApiInterfaceDelegate
/**
 处理来至QQ的请求
 */
- (void)onReq:(QQBaseReq *)req
{
    
}

/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp;
{
    NSLog(@"%@",resp.result);
    switch (resp.type){
        case ESENDMESSAGETOQQRESPTYPE:
        {
            //0 为发送成功
            if ([resp.result intValue] == 0) {
                [CRToastTool showNotificationWithTitle:@"分享成功" backgroundColor:[UIColor colorWithRed:0.251 green:0.796 blue:0.518 alpha:1.000] timeInterval:@1 completionBlock:nil];
            }else if ([resp.result intValue] == -4){
                [CRToastTool showNotificationWithTitle:@"分享取消" backgroundColor:[UIColor colorWithRed:0.975 green:0.358 blue:0.421 alpha:1.000] timeInterval:@1 completionBlock:nil];
            }else{
                [CRToastTool showNotificationWithTitle:@"未知错误" backgroundColor:[UIColor colorWithRed:1.000 green:0.243 blue:0.306 alpha:1.000] timeInterval:@1 completionBlock:nil];
            }
            
            //-4 为取消发送（the user give up the current operation）
            
            
//            NSLog(@"--%@ - --%@ --%@ -%d ",resp.result,resp.extendInfo,resp.errorDescription,resp.type);
//            
//            SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp;
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:sendResp.result message:sendResp.errorDescription delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
            break;
        }
        default:
        {
            break;
        }
    }
}


/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response
{
    
}
@end
