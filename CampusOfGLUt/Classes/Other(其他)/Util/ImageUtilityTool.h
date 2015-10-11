//
//  ImageUtilityTool.h
//  CampusOfGLUT
//
//  Created by HTC on 15/2/23.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ImageUtilityTool : NSObject

+ (UIImage *)screenShots;

+ (UIImage *)imageFromScreenWindow;

//截取ScrollView的内容
+ (UIImage *)imageFromScrollView:(UIScrollView *)scrollView;

+ (UIImage *)imageFromScrollView:(UIScrollView *)scrollView withFrame:(CGRect)frame;

//获得屏幕图像
+ (UIImage *)imageFromView: (UIView *) theView;

//获得某个范围内的屏幕图像
+ (UIImage *)imageFromView: (UIView *)theView  atFrame:(CGRect)frame;

//调整图片大小(分辨率）
+ (UIImage *)scaleFromImage: (UIImage *)image toSize:(CGSize)size;
@end
