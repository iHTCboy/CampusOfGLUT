//
//  InformationHandleTool.m
//  CampusOfGLUT
//
//  Created by HTC on 15/2/23.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "InformationHandleTool.h"
#import "CRToastTool.h"
@import SafariServices;

UIWebView * _webView;

@implementation InformationHandleTool

+ (instancetype)sharedInfoTool
{
    static InformationHandleTool *infoTool;
    @synchronized(self) {
        if (!infoTool)
            infoTool = [[self alloc] init];
    }
    return infoTool;
}

/**
 *  发短信
 */
- (void)sendSMSWithBody:(NSString *)body recipients:(NSArray *)recipients controller:(UIViewController *)vc
{
    MFMessageComposeViewController *SMS = [[MFMessageComposeViewController alloc] init];
    // 设置短信内容
    SMS.body = body;
    // 设置收件人列表
    SMS.recipients = recipients;
    // 设置代理
    SMS.messageComposeDelegate = self;
    
    // 显示控制器
    [vc presentViewController:SMS animated:YES completion:nil];
}


/**
 *  代理方法，当短信界面关闭的时候调用，发完后会自动回到原应用
 */
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    // 关闭短信界面
    [controller dismissViewControllerAnimated:YES completion:nil];

    /**
     MessageComposeResultCancelled,
     MessageComposeResultSent,
     MessageComposeResultFailed
     */
    if (result == MessageComposeResultCancelled) {
        NSLog(@"取消发送");
        [CRToastTool showNotificationWithTitle:@"发送取消" backgroundColor:[UIColor colorWithRed:0.975 green:0.358 blue:0.421 alpha:1.000] timeInterval:@1 completionBlock:nil];
    } else if (result == MessageComposeResultSent) {
        NSLog(@"已经发出");
        [CRToastTool showNotificationWithTitle:@"发送成功" backgroundColor:[UIColor colorWithRed:0.251 green:0.796 blue:0.518 alpha:1.000] timeInterval:@1 completionBlock:nil];
    }else if(result == MessageComposeResultFailed){
        NSLog(@"发送失败");
        [CRToastTool showNotificationWithTitle:@"发送失败" backgroundColor:[UIColor colorWithRed:0.975 green:0.630 blue:0.061 alpha:1.000] timeInterval:@1 completionBlock:nil];
    }
}



/**
 *  发送邮件
 */
- (void)sendEmailWithSubject:(NSString *)subject MessageBody:(NSString *)MessageBody isHTML:(BOOL)isHTML toRecipients:(NSArray *)recipients  ccRecipients:(NSArray *)ccRecipients bccRecipients:(NSArray *)bccRecipients Image:(UIImage *)image imageQuality:(CGFloat)quality Controller:(UIViewController *)vc
{

    // 不能发邮件
    if (![MFMailComposeViewController canSendMail]) return;
    
    MFMailComposeViewController *email = [[MFMailComposeViewController alloc] init];
    
    // 设置邮件主题
    [email setSubject:subject];
    // 设置邮件内容
    [email setMessageBody:MessageBody isHTML:isHTML];
    // 设置收件人列表
    [email setToRecipients:recipients];
    // 设置抄送人列表
    [email setCcRecipients:ccRecipients];
    // 设置密送人列表
    [email setBccRecipients:bccRecipients];
    
    // 添加附件（一张图片）
    if (image)
    {
        NSData *data = UIImageJPEGRepresentation(image, quality);
        [email addAttachmentData:data mimeType:@"image/jepg" fileName:@"lufy.jpeg"];
    }

    // 设置代理
    email.mailComposeDelegate = self;
    // 显示控制器
    [vc presentViewController:email animated:YES completion:nil];
    
}

/**
 *  邮件发送后的代理方法回调，发完后会自动回到原应用
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    // 关闭邮件界面
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    /**
     *      
     MFMailComposeResultCancelled,
     MFMailComposeResultSaved,
     MFMailComposeResultSent,
     MFMailComposeResultFailed
     */
    if (result == MFMailComposeResultCancelled) {
        NSLog(@"取消发送");
        [CRToastTool showNotificationWithTitle:@"发送取消" backgroundColor:[UIColor colorWithRed:0.975 green:0.358 blue:0.421 alpha:1.000] timeInterval:@1 completionBlock:nil];
    } else if (result == MFMailComposeResultSaved) {
        NSLog(@"已经保存");
        [CRToastTool showNotificationWithTitle:@"保存成功" backgroundColor:[UIColor colorWithRed:0.325 green:0.691 blue:0.975 alpha:1.000] timeInterval:@1 completionBlock:nil];
    } else if (result == MFMailComposeResultSent) {
        NSLog(@"已经发出");
        [CRToastTool showNotificationWithTitle:@"发送成功" backgroundColor:[UIColor colorWithRed:0.251 green:0.796 blue:0.518 alpha:1.000] timeInterval:@1 completionBlock:nil];
    }else if(result == MFMailComposeResultFailed){
        NSLog(@"发送失败");
        [CRToastTool showNotificationWithTitle:@"发送失败" backgroundColor:[UIColor colorWithRed:0.975 green:0.630 blue:0.061 alpha:1.000] timeInterval:@1 completionBlock:nil];
    }

}


/**
 *  打电话
 *
 */
- (void)makeCallPhoneNumber:(NSString *)phoneNumber
{
    if (_webView == nil)
    {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]]]];
}



/**
 *  从Safari打开
 */
- (void)inSafariOpenWithURL:(NSString *)url
{
    if (@available(iOS 9.0, *)) {
        SFSafariViewController * sf = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
        if (@available(iOS 11.0, *)) {
            sf.preferredBarTintColor = [UIColor colorWithRed:(66)/255.0 green:(156)/255.0 blue:(249)/255.0 alpha:1];
            sf.dismissButtonStyle = SFSafariViewControllerDismissButtonStyleClose;
        }
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:sf animated:YES completion:nil];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}


/**
 *  从AppStore打开
 */
- (void)inAppStoreWithID:(NSString *)ID
{
    //评分 无法使用
    //NSString *str = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",ID];
    NSString *str = [NSString stringWithFormat: @"https://itunes.apple.com/cn/app/gui-lin-li-gong-da-xue-yun/id%@?mt=8&action=write-review", ID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

/**
 *  //打开系统拍照机
 */
- (void)openCamera:(UIViewController *)vc
{
    //拍照
    UIImagePickerController * camera = [[UIImagePickerController alloc]init];
    
    camera.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    camera.delegate = self;
    
    [vc presentViewController:camera animated:YES completion:^{
        
    }];
}



/**
 *  //打开系统照片库
 */
- (void)openPhotoLibrary:(UIViewController *)vc
{
    //从相册
    UIImagePickerController * photo = [[UIImagePickerController alloc]init];
    
    photo.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    photo.delegate = self;
    
    [vc presentViewController:photo animated:YES completion:^{
        
    }];
}

//处理头像
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage * image = info[UIImagePickerControllerOriginalImage];
    
    //存储头像图片
//    //Document
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
//    /*写入图片*/
//    //帮文件起个名
//    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"image.png"];
//    //将图片写到Documents文件中
//    [UIImagePNGRepresentation(newImage) writeToFile:uniquePath atomically:YES];
    
}


#pragma mark - 检查版本更新
- (void)checkUpdateWithAppID:(NSString *)appID success:(void (^)(NSDictionary *resultDic , BOOL isNewVersion , NSString * newVersion))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *encodingUrl=[[@"http://itunes.apple.com/lookup?id=" stringByAppendingString:appID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:encodingUrl parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
         NSString * versionStr =[[[resultDic objectForKey:@"results"] objectAtIndex:0] valueForKey:@"version"];
        
        float version =[versionStr floatValue];
        //self.iTunesLink=[[[resultDic objectForKey:@"results"] objectAtIndex:0] valueForKey:@"trackViewUrl"];
        NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
        float currentVersion = [[infoDic valueForKey:@"CFBundleShortVersionString"] floatValue];
        
        if(version>currentVersion){
            
            success(resultDic, YES, versionStr);
            
        }else{
            
            success(resultDic,NO ,versionStr);
            
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error);
    }];
}


- (BOOL)isDeviceOfiPhone
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return YES;
    }else{
        return NO;
    }
}

@end
