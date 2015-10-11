//
//  FocusImageView.h
//  CampusOfGLUt
//
//  Created by HTC on 15/2/12.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FocusImageViewDelegate <NSObject>

@optional

-(void)focusImageWithtouchImagePage:(NSInteger)page imageurl:(NSString *)url scrollView:(UIScrollView *)scrollview;

@end

@interface FocusImageView : UIView<UIScrollViewDelegate>

@property (weak, nonatomic)  UIPageControl *pageControl;
@property (weak, nonatomic) id<FocusImageViewDelegate>delegate;


- (instancetype)initWithFrame:(CGRect)frame backGroudImages:(NSArray *)images titles:(NSArray *)titles;

- (instancetype)initWithFrame:(CGRect)frame forcusImages:(NSArray *)images titles:(NSArray *)titles tag:(NSInteger)tag;


@end
