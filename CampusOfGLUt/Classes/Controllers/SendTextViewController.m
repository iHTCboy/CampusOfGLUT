//
//  SendTextViewController.m
//  CampusOfGLUT
//
//  Created by HTC on 15/3/15.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "SendTextViewController.h"
#import "CustomTextView.h"
#import "Utility.h"
#import "FetchLifeCircleTool.h"
#import "CRToastTool.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "KxMenu.h"
#import "HUDUtil.h"

@interface SendTextViewController ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,weak) UIImageView * headerImageView;
@property (nonatomic,weak) UITextField * nameFieldView;
@property (nonatomic,weak) CustomTextView * contentTextView;
@property (nonatomic,weak) UIImageView * addImageView;
@property (nonatomic,weak) UILabel * fromLabelView;
//发送按钮
@property (nonatomic,weak) UIButton * sendBn;
/**
 *  发送失败的信息通知
 */
@property (nonatomic,weak) UILabel * infoLaabelView;
@property (nonatomic,copy) NSString * imageURL;

@property (nonatomic,assign) BOOL isSendSuccess;


/**
 是否有图片发送
 */
@property (nonatomic, assign) BOOL hasImage;

@end

@implementation SendTextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self naviBarinit];
    
    [self initContentView];

}


#pragma mark - 发送
- (void)sendText
{
    [self.view endEditing:YES];
    
    HUDUtil * hud = [HUDUtil sharedHUDUtil];
    
    //判断
    if (self.contentTextView.text.length == 0){
        
        [hud showTextHUDWithText:@"主人说点什么吧！" delay:2.0 inView:self.view];
        
        //[CRToastTool showNotificationWithTitle:@"主人说点什么吧！" backgroundColor:[UIColor colorWithRed:1.000 green:0.401 blue:0.436 alpha:1.000] timeInterval:@(2.5) completionBlock:^{   }];;
        return;
    }
    
    self.sendBn.enabled = NO;
    FetchLifeCircleTool *tool = [FetchLifeCircleTool sharedFetchNewsTool];
    
    
    if (self.hasImage) {
        if (self.imageURL.length) {
            [self setTEXT];
        }else{
            [hud showLoadingHUDInTheView:self.view];
            [tool sendImages:self.addImageView.image success:^(NSDictionary *dic) {
                if([[dic objectForKey:@"status"] intValue] == 1 ){
                    self.imageURL = [dic objectForKey:@"pic_name"];
                    FetchLifeCircleTool *tool = [FetchLifeCircleTool sharedFetchNewsTool];
                    [tool sendTextToLifeCircleWithTableID:self.tableID icon:[NSString stringWithFormat:@"%ld",(long)self.headerImageView.tag] name:self.nameFieldView.text contents:self.contentTextView.text images:nil imageURL:self.imageURL commets:nil comefrom:self.fromLabelView.text praises:@"0" reports:@"0" success:^(NSArray *fetchArray) {
                        [hud dismissAllHUD];
                        self.isSendSuccess = YES;
                        [self dismissVC];
                        
                    } failure:^(NSError *error) {
                        [self.view endEditing:YES];
                        
                        self.sendBn.enabled = YES;
                        [hud dismissAllHUD];
                        
                        if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
                            
                            [hud showTextHUDWithText:@"网络好像出了点问题" delay:2.0 inView:self.view];
                            //[CRToastTool showNotificationWithTitle:@"网络好像出了点问题" backgroundColor:[UIColor colorWithRed:1.000 green:0.435 blue:0.812 alpha:1.000] timeInterval:@(2.5) completionBlock:^{   }];
                        }else{
                            self.infoLaabelView.text = [NSString stringWithFormat:@"发送失败，可能含有敏感词，\n 参考错误：%@\n \n 请“修改”后在发送啊😱🙈",error.domain];
                            
                            [hud showTextHUDWithText:@"可能含有敏感词" delay:2.0 inView:self.view];
                            
                            //[CRToastTool showNotificationWithTitle:@"可能含有敏感词" backgroundColor:[UIColor colorWithRed:1.000 green:0.237 blue:0.374 alpha:1.000] timeInterval:@(2.5) completionBlock:^{   }];
                        }
                        
                        //NSLog(@"----%@", error.domain);
                    }];

                }else{
                    [hud dismissAllHUD];
                    [hud showTextHUDWithText:@"网络好像出了点问题" delay:2.0 inView:self.view];
                    // [CRToastTool showNotificationWithTitle:@"网络好像出了点问题" backgroundColor:[UIColor colorWithRed:1.000 green:0.435 blue:0.812 alpha:1.000] timeInterval:@(2.5) completionBlock:^{   }];
                }
            } failure:^(NSError *error) {
                [hud dismissAllHUD];
                [hud showTextHUDWithText:@"网络好像出了点问题" delay:2.0 inView:self.view];
                //[CRToastTool showNotificationWithTitle:@"网络好像出了点问题" backgroundColor:[UIColor colorWithRed:1.000 green:0.435 blue:0.812 alpha:1.000] timeInterval:@(2.5) completionBlock:^{   }];
            }];
        }
        
    }else{
        [self setTEXT];
    }

}


- (void)setTEXT{
    
    HUDUtil* hud = [HUDUtil sharedHUDUtil];
    
    [hud showLoadingHUDInTheView:self.view];
    
    FetchLifeCircleTool *tool = [FetchLifeCircleTool sharedFetchNewsTool];
    [tool sendTextToLifeCircleWithTableID:self.tableID icon:[NSString stringWithFormat:@"%ld",(long)self.headerImageView.tag] name:self.nameFieldView.text contents:self.contentTextView.text images:nil imageURL:self.imageURL commets:nil comefrom:self.fromLabelView.text praises:@"0" reports:@"0" success:^(NSArray *fetchArray) {
        [hud dismissAllHUD];
        self.isSendSuccess = YES;
        [self dismissVC];
        
    } failure:^(NSError *error) {
        [self.view endEditing:YES];
        
        self.sendBn.enabled = YES;
        [hud dismissAllHUD];
        
        if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
            
            [hud showTextHUDWithText:@"网络好像出了点问题" delay:2.0 inView:self.view];
            //[CRToastTool showNotificationWithTitle:@"网络好像出了点问题" backgroundColor:[UIColor colorWithRed:1.000 green:0.435 blue:0.812 alpha:1.000] timeInterval:@(2.5) completionBlock:^{   }];
        }else{
            self.infoLaabelView.text = [NSString stringWithFormat:@"发送失败，可能含有敏感词，\n 参考错误：%@\n \n 请“修改”后在发送啊😱🙈",error.domain];
            
            [hud showTextHUDWithText:@"可能含有敏感词" delay:2.0 inView:self.view];
            
            //[CRToastTool showNotificationWithTitle:@"可能含有敏感词" backgroundColor:[UIColor colorWithRed:1.000 green:0.237 blue:0.374 alpha:1.000] timeInterval:@(2.5) completionBlock:^{   }];
        }
        
        //NSLog(@"----%@", error.domain);
    }];

}

#pragma mark - 选择图片
-(void)addPicture
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择添加图片方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 添加按钮
     __weak typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf pickerFromCamera];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf pickerFromPhotoLibrary];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"图片链接" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf showImageURL];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];;
}

#pragma mark - 打开拍照
- (void)pickerFromCamera
{
    UIImagePickerController * camera = [[UIImagePickerController alloc]init];
    
    camera.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    camera.delegate = self;
    
    //camera.allowsEditing = YES;
    
    [self presentViewController:camera animated:YES completion:^{
        
        
    }];
    
}

#pragma mark - 从相册选择
- (void)pickerFromPhotoLibrary
{
    UIImagePickerController * photo = [[UIImagePickerController alloc]init];
    
    photo.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    photo.delegate = self;
    
    //photo.allowsEditing = YES;
    
    [self presentViewController:photo animated:YES completion:^{
        
    }];
}



#pragma mark - 提供图片链接
- (void)showImageURL
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"图片链接" message:@"请在文本框中粘贴图片的链接" preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加按钮
    __weak typeof(alert) weakAlert = alert;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.imageURL = [weakAlert.textFields.firstObject text];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];

    // 添加文本框
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.textColor = [UIColor colorWithRed:0.192 green:0.518 blue:0.984 alpha:1.000];
        textField.placeholder = @"图片链接";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //[textField addTarget:self action:@selector(usernameDidChange:) forControlEvents:UIControlEventEditingChanged];
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usernameDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark - 照片处理

//处理头像
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = info[UIImagePickerControllerOriginalImage];
    self.addImageView.image = image;
    
    self.hasImage = YES;
    
    [self clearImageView];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    //获取照片实例
    //UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //获取缩放和移动后的图片
    //UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    
//    UIImage * newImage  = [self ellipseImage:image withInset:0 withBorderWidth:15 withBorderColor:TCCoror(38, 141, 252)];
//    [self.imageHead setImage:newImage];
//    
//    
//    //存储头像图片
//    //Document
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    
//    /*写入图片*/
//    //帮文件起个名
//    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"image.png"];
//    //将图片写到Documents文件中
//    [UIImagePNGRepresentation(newImage) writeToFile:uniquePath atomically:YES];
    
}

#pragma mark - clearImageView
- (void)clearImageView
{
    
    UIImageView *clearV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.addImageView.frame) - 30, 0, 20, 20)];
    clearV.userInteractionEnabled = YES;
    clearV.image = [UIImage imageNamed:@"image_clear"];
    [self.addImageView addSubview:clearV];
    
    UITapGestureRecognizer * tapclear = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clearImageV)];
    [clearV addGestureRecognizer:tapclear];
}

#pragma mark - 删除照片
- (void)clearImageV
{
    [self.addImageView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [obj removeFromSuperview];
    }];
    
    
    self.hasImage = NO;
    
    self.addImageView.image = [UIImage imageNamed:@"addPictureBgImage"];
}

#pragma mark - 点击头像
- (void)tapHeaderImageView
{
    NSArray *titleArray=@[@"男童鞋",@"女童鞋",@"男老师",@"女老师"];
    
    //生成菜单项
    NSMutableArray *menuItems=[NSMutableArray array];
    for (int i=1; i<=titleArray.count; i++) {
        KxMenuItem *menuItem=[KxMenuItem menuItem:titleArray[i-1] index:i image:nil target:self action:@selector(menuItemSelected:)];
        NSString *imageNamge = [NSString stringWithFormat:@"iconView_%d",i];
        menuItem.image= [UIImage imageNamed:imageNamge];
        [menuItems addObject:menuItem];
    }
    //
    KxMenuItem *first = menuItems[self.headerImageView.tag -1];
    first.foreColor = [UIColor colorWithRed:0.046 green:0.674 blue:1.000 alpha:1.000];

    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(20, 64, 40, 40)
                 menuItems:menuItems];

}

#pragma mark - 更换头像
-(void) menuItemSelected:(KxMenuItem*) item{
    
    NSString *imageNamge = [NSString stringWithFormat:@"iconView_%d",(int)item.index];
    self.headerImageView.image= [UIImage imageNamed:imageNamge];
    self.headerImageView.tag = item.index;
    
    NSLog(@"--%ld",(long)item.index);
    
}


#pragma mark - 关闭
- (void)dismissVC{
    
    //提示不保存
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.isSendSuccess) {
         [CRToastTool showNotificationWithTitle:@"说说发送成功" backgroundColor:[UIColor colorWithRed:0.251 green:0.796 blue:0.518 alpha:1.000] timeInterval:@(2.5) completionBlock:^{     }];
        }
    }];
}


#pragma mark 初始化视图
- (void)initContentView
{
    UIColor * bgColor = [UIColor colorWithWhite:0.947 alpha:0.530];
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64)];
    scrollView.alwaysBounceVertical = YES;
    scrollView.backgroundColor = bgColor;
    [self.view addSubview:scrollView];
    
    CGFloat marginW = 10;
    CGFloat marginH = 5;
    
    CGFloat headerWH = 40;
    
    UIImageView * headerV = [[UIImageView alloc]initWithFrame:CGRectMake(marginW, marginH, headerWH, headerWH)];
    headerV.image = [UIImage imageNamed:@"iconView_1"];
    headerV.tag = 1;
    headerV.userInteractionEnabled = YES;
    UITapGestureRecognizer * taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeaderImageView)];
    [headerV addGestureRecognizer:taps];
    [scrollView addSubview:headerV];
    self.headerImageView = headerV;
    
    UITextField * nameV = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headerV.frame) + marginW, marginH, UI_SCREEN_WIDTH - CGRectGetMaxX(headerV.frame) - marginW, 30)];
    nameV.placeholder = @"匿名昵称";
    [scrollView addSubview:nameV];
    self.nameFieldView = nameV;
    
    
    CGFloat textH = 80;
    
    CustomTextView * textView = [[CustomTextView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(headerV.frame), UI_SCREEN_WIDTH -10, textH)];
    textView.placeholder = @"来，发个说说吧";
    textView.backgroundColor = bgColor;
    textView.font = [UIFont systemFontOfSize:17];
    [scrollView addSubview:textView];
    self.contentTextView = textView;
    
    
    CGFloat imageHW = 80;
//    UIView * imageCV = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(textView.frame) + 5, imageHW, imageHW)];
//    imageCV.backgroundColor = bgColor;
//    [scrollView addSubview:imageCV];
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(textView.frame) + 5, imageHW, imageHW)];
    imageV.image = [UIImage imageNamed:@"addPictureBgImage"];
    imageV.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPicture)];
    [imageV addGestureRecognizer:tap];
    [scrollView addSubview:imageV];
    self.addImageView = imageV;

    
    UILabel * fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame) + marginW, CGRectGetMaxY(textView.frame) + marginH, UI_SCREEN_WIDTH - CGRectGetMaxX(imageV.frame) - 2*marginW, 30)];
    fromLabel.textAlignment = NSTextAlignmentRight;
    fromLabel.font = [UIFont systemFontOfSize:13];
    fromLabel.textColor = kMianColor;
    //fromLabel.backgroundColor = bgColor;
    fromLabel.text =[@"来自：" stringByAppendingString:[Utility getCurrentDeviceModel]];
    [scrollView addSubview:fromLabel];
    self.fromLabelView = fromLabel;
    
    
    UILabel * infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(imageV.frame), UI_SCREEN_WIDTH -20, 200)];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = [UIColor redColor];
    infoLabel.numberOfLines = 0;
    
    self.infoLaabelView = infoLabel;
    
    [scrollView addSubview:infoLabel];
    
}

#pragma mark NaviInit
- (void)naviBarinit
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView * topColor = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    
    topColor.backgroundColor  = kMianColor;
    
    [self.view addSubview:topColor];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleLabel.center = CGPointMake(self.view.frame.size.width /2, 41);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"说说";
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:titleLabel];

    UIButton * backBn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBn  setFrame:CGRectMake(12, 30, 25, 25)];
    [backBn  setBackgroundImage:[UIImage imageNamed:@"navi_close_normol"] forState:UIControlStateNormal];
    [backBn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBn];

    
    UIButton * sendBn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendBn  setFrame:CGRectMake(self.view.frame.size.width - 50, 30, 40, 30)];
    [sendBn setTitle:@"发送" forState:UIControlStateNormal];
    sendBn.tintColor = [UIColor whiteColor];
    sendBn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [sendBn addTarget:self action:@selector(sendText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBn];
    
    self.sendBn = sendBn;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
