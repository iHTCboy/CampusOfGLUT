//
//  WeixinSDKTool.m
//  CampusOfGLUT
//
//  Created by HTC on 15/2/21.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "WeixinSDKTool.h"
#import "CRToastTool.h"

@implementation WeixinSDKTool

+ (void) sendImageContent:(UIImage *)image scene:(WXSceneType)scene
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"shareThumbImage"]];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImagePNGRepresentation(image);
    
    message.mediaObject = ext;
    message.mediaTagName = @"CampusOfGLUT_APP";
    message.messageExt = @"桂林理工大学-校园通";
    message.messageAction = @"<action>dotalist</action>";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}


#pragma mark- WXApiDelegate
-(void) onReq:(BaseReq*)req
{
    
}


/**
 *  发送一个sendReq后，收到微信的回应
 */
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
     /**
        WXSuccess           = 0,    < 成功
        WXErrCodeCommon     = -1,   < 普通错误类型
        WXErrCodeUserCancel = -2,   < 用户点击取消并返回
        WXErrCodeSentFail   = -3,   < 发送失败
        WXErrCodeAuthDeny   = -4,   < 授权失败
        WXErrCodeUnsupport  = -5,   < 微信不支持
        */
        
        switch (resp.errCode) {
            case 0:
                [CRToastTool showNotificationWithTitle:@"分享成功" backgroundColor:[UIColor colorWithRed:0.251 green:0.796 blue:0.518 alpha:1.000] timeInterval:@1 completionBlock:nil];
                break;
            case -1:
                [CRToastTool showNotificationWithTitle:@"未知错误" backgroundColor:[UIColor colorWithRed:1.000 green:0.243 blue:0.306 alpha:1.000] timeInterval:@1 completionBlock:nil];
                break;
            case -2:
                [CRToastTool showNotificationWithTitle:@"分享取消" backgroundColor:[UIColor colorWithRed:0.975 green:0.358 blue:0.421 alpha:1.000] timeInterval:@1 completionBlock:nil];
                break;
            case -3:
                [CRToastTool showNotificationWithTitle:@"分享失败" backgroundColor:[UIColor colorWithRed:0.975 green:0.630 blue:0.061 alpha:1.000] timeInterval:@1 completionBlock:nil];
                break;
            case -4:
                [CRToastTool showNotificationWithTitle:@"授权失败" backgroundColor:[UIColor colorWithRed:0.351 green:0.467 blue:0.998 alpha:1.000] timeInterval:@1 completionBlock:nil];
                break;
            case -5:
                [CRToastTool showNotificationWithTitle:@"微信不支持" backgroundColor:[UIColor colorWithRed:0.149 green:0.796 blue:0.263 alpha:1.000] timeInterval:@1 completionBlock:nil];
                break;
            default:
                break;
        }
        
        
//        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
//        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
    }
//    else if([resp isKindOfClass:[SendAuthResp class]])
//    {
//        SendAuthResp *temp = (SendAuthResp*)resp;
//        
//        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
//        NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", temp.code, temp.state, temp.errCode];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//    else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]])
//    {
//        AddCardToWXCardPackageResp* temp = (AddCardToWXCardPackageResp*)resp;
//        NSMutableString* cardStr = [[NSMutableString alloc] init];
//        for (WXCardItem* cardItem in temp.cardAry) {
//            [cardStr appendString:[NSString stringWithFormat:@"cardid:%@ cardext:%@ cardstate:%u\n",cardItem.cardId,cardItem.extMsg,(unsigned int)cardItem.cardState]];
//        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"add card resp" message:cardStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
}



@end
