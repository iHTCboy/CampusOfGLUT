//
//  FocusImageView.m
//  CampusOfGLUt
//
//  Created by HTC on 15/2/12.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "FocusImageView.h"
#import "UIImageView+WebCache.h"

@interface FocusImageView()

@property (weak, nonatomic) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger imageCounts;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray * images;

/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation FocusImageView

- (instancetype)initWithFrame:(CGRect)frame backGroudImages:(NSArray *)images titles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.images = images;
        
        self.backgroundColor = [UIColor redColor];
        
        UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:frame];
        self.scrollView = scrollView;
        [self addSubview:scrollView];
        
 
        UIPageControl * pageControl = [[UIPageControl alloc]init];
        pageControl.center = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame) - 10);
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000];
        self.pageControl = pageControl;
        [self addSubview:pageControl];
        self.scrollView.delegate = self;
        
        // 0.一些固定的尺寸参数
        self.imageCounts = images.count;
        CGFloat imageW = self.scrollView.frame.size.width;
        CGFloat imageH = self.scrollView.frame.size.height;
        CGFloat imageY = 0;
        
        
        // 设置循环图片第一张为最后一张
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageY, imageW, imageH)];
        NSString *name = [NSString stringWithFormat:@"%@",images[self.imageCounts -1]];
        imageV.image = [UIImage imageNamed:name];
        [self.scrollView addSubview:imageV];
        
        // 1.添加图片到scrollView中
        for (int i = 0; i<self.imageCounts; i++) {
            
            
            UIImageView *imageView = [[UIImageView alloc] init];
            // 设置frame
            CGFloat imageX = (i +1) * imageW;
            imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
            // 设置图片
            NSString *name = [NSString stringWithFormat:@"%@",images[i]];
            imageView.image = [UIImage imageNamed:name];
            [self.scrollView addSubview:imageView];
            
            if (i == self.imageCounts - 1)
            {
                UIImageView *lastImage = [[UIImageView alloc] init];
                CGFloat imageX = (i +2) * imageW;
                lastImage.frame = CGRectMake(imageX, imageY, imageW, imageH);
                NSString *name = [NSString stringWithFormat:@"%@",images[0]];
                lastImage.image = [UIImage imageNamed:name];
                [self.scrollView addSubview:lastImage];
            }
        }
        
        // 2.设置内容尺寸
        CGFloat contentW = (self.imageCounts + 2)* imageW;
        self.scrollView.contentSize = CGSizeMake(contentW, 0);
        
        // 3.隐藏水平滚动条
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
        //[self.scrollView scrollRectToVisible:CGRectMake(imageW * 2,imageH,self.scrollView.bounds.size.width,scrollView.bounds.size.height) animated:NO];
        
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width,0) animated:NO];
        
        // 4.分页
        self.scrollView.pagingEnabled = YES;
        //    self.scrollView.delegate = self;
        
        // 5.设置pageControl的总页数
        self.pageControl.numberOfPages = self.imageCounts;
        
        // 6.添加定时器(每隔2秒调用一次self 的nextImage方法)
        [self addTimer];

    }
    
    return self;

}



- (instancetype)initWithFrame:(CGRect)frame forcusImages:(NSArray *)imagesArr titles:(NSArray *)titles tag:(NSInteger)tag
{

    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.images = imagesArr;
        
        NSArray * images = imagesArr[tag-1];
        
        UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:frame];
        self.scrollView = scrollView;
        [self addSubview:scrollView];
        scrollView.tag = tag;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToImage)];
        
        [scrollView addGestureRecognizer:tap];
        
        
        UIPageControl * pageControl = [[UIPageControl alloc]init];
        pageControl.center = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame) - 10);
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.192 green:0.518 blue:0.984 alpha:1.000];
        pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        self.pageControl = pageControl;
        [self addSubview:pageControl];
        self.scrollView.delegate = self;
        
        // 0.一些固定的尺寸参数
        self.imageCounts = images.count;
        CGFloat imageW = self.scrollView.frame.size.width;
        CGFloat imageH = self.scrollView.frame.size.height;
        CGFloat imageY = 0;
        
        
        // 设置循环图片第一张为最后一张
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageY, imageW, imageH)];
        NSURL * url = [NSURL URLWithString:images[self.imageCounts -1]];
        [imageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        [self.scrollView addSubview:imageV];
        
        // 1.添加图片到scrollView中
        for (int i = 0; i<self.imageCounts; i++) {
            
            
            UIImageView *imageView = [[UIImageView alloc] init];
            // 设置frame
            CGFloat imageX = (i +1) * imageW;
            imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
            // 设置图片
            NSURL * url = [NSURL URLWithString:images[i]];
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            [self.scrollView addSubview:imageView];
            
            if (i == self.imageCounts - 1)
            {
                UIImageView *lastImage = [[UIImageView alloc] init];
                CGFloat imageX = (i +2) * imageW;
                lastImage.frame = CGRectMake(imageX, imageY, imageW, imageH);
                NSURL * url = [NSURL URLWithString:images[0]];
                [lastImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                [self.scrollView addSubview:lastImage];
            }
        }
        
        // 2.设置内容尺寸
        CGFloat contentW = (self.imageCounts + 2)* imageW;
        self.scrollView.contentSize = CGSizeMake(contentW, 0);
        
        // 3.隐藏水平滚动条
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
        //[self.scrollView scrollRectToVisible:CGRectMake(imageW * 2,imageH,self.scrollView.bounds.size.width,scrollView.bounds.size.height) animated:NO];
        
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width,0) animated:NO];
        
        // 4.分页
        self.scrollView.pagingEnabled = YES;
        //    self.scrollView.delegate = self;
        
        // 5.设置pageControl的总页数
        self.pageControl.numberOfPages = self.imageCounts;
        
        // 6.添加定时器(每隔2秒调用一次self 的nextImage方法)
        [self addTimer];
        
    }
    
    return self;
    
}


-(void)tapToImage
{
    if ([self.delegate respondsToSelector:@selector(focusImageWithtouchImagePage:imageurl:scrollView:)])
    {
        [self.delegate focusImageWithtouchImagePage:self.currentPage imageurl:self.images[self.scrollView.tag][self.currentPage-1] scrollView:self.scrollView];
    }

}



/**
 *  添加定时器
 */
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *  移除定时器
 */
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextImage
{
    // 1.增加pageControl的页码
    NSInteger page = 1;
    if (self.currentPage == self.imageCounts +1) {
        page = 1;
    }
    else
    {
       page = self.currentPage + 1;
    }
    
    //NSLog(@"page-----%ld",(long)page);
    
    // 2.计算scrollView滚动的位置
    CGFloat offsetX = page * self.scrollView.frame.size.width;
    CGPoint offset = CGPointMake(offsetX, 0);
    
   
    [self.scrollView setContentOffset:offset animated:YES];
    
}

#pragma mark - 代理方法
/**
 *  当scrollView正在滚动就会调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 根据scrollView的滚动位置决定pageControl显示第几页
    CGFloat scrollW = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + scrollW * 0.5) / scrollW;
    self.currentPage = page;
    self.pageControl.currentPage = page-1;
    //NSLog(@"pageControl----%d",page);
}



- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{

    if (self.currentPage == self.imageCounts + 1 )
    {
         //NSLog(@"scrollViewDidEndScrollingAnimation----%d",4);
        
         [self.scrollView setContentOffset:CGPointMake(scrollView.bounds.size.width,0) animated:NO];
    }
    
}

/**
 *  开始拖拽的时候调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 停止定时器(一旦定时器停止了,就不能再使用)
    [self removeTimer];
    //NSLog(@"scrollViewWillBeginDragging");
}

/**
 *  停止拖拽的时候调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 开启定时器
    [self addTimer];
    //NSLog(@"scrollViewDidEndDragging");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDecelerating");
    
    if (scrollView.contentOffset.x == 0) {
        // 用户滑动到1号位置，此时必须跳转到倒二的位置
        //[scrollView scrollRectToVisible:CGRectMake(scrollView.contentSize.width - 2 * scrollView.bounds.size.width,0,scrollView.bounds.size.width,scrollView.bounds.size.height) animated:NO];
        
        
        [self.scrollView setContentOffset:CGPointMake(scrollView.contentSize.width - 2 * scrollView.bounds.size.width,0) animated:NO];
    }
    else if (scrollView.contentOffset.x == scrollView.contentSize.width - scrollView.bounds.size.width) {
        // 用户滑动到最后的位置，此时必须跳转到2号位置
        //[scrollView scrollRectToVisible:CGRectMake(scrollView.bounds.size.width,0,scrollView.bounds.size.width,scrollView.bounds.size.height) animated:NO];
        
       [self.scrollView setContentOffset:CGPointMake(scrollView.bounds.size.width,0) animated:NO];
    }
    
    
}


-(void)drawRect:(CGRect)rect
{

//    NSLog(@"##%@",self.scrollView);
//    CGRect frame = CGRectMake(0, 0, self.frame.size.width,self.scrollView.frame.size.height);
//    
//    self.scrollView.frame = frame;
    
    
    //[self set];
    

}


- (void)set
{

    // 0.一些固定的尺寸参数
    self.imageCounts = self.images.count;
    CGFloat imageW = self.scrollView.frame.size.width;
    CGFloat imageH = self.scrollView.frame.size.height;
    CGFloat imageY = 0;
    
    
    // 设置循环图片第一张为最后一张
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageY, imageW, imageH)];
    NSURL * url = [NSURL URLWithString:self.images[self.imageCounts -1]];
    [imageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    [self.scrollView addSubview:imageV];
    
    // 1.添加图片到scrollView中
    for (int i = 0; i<self.imageCounts; i++) {
        
        
        UIImageView *imageView = [[UIImageView alloc] init];
        // 设置frame
        CGFloat imageX = (i +1) * imageW;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        // 设置图片
        NSURL * url = [NSURL URLWithString:self.images[i]];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        [self.scrollView addSubview:imageView];
        
        if (i == self.imageCounts - 1)
        {
            UIImageView *lastImage = [[UIImageView alloc] init];
            CGFloat imageX = (i +2) * imageW;
            lastImage.frame = CGRectMake(imageX, imageY, imageW, imageH);
            NSURL * url = [NSURL URLWithString:self.images[0]];
            [lastImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            [self.scrollView addSubview:lastImage];
        }
    }
    
    // 2.设置内容尺寸
    CGFloat contentW = (self.imageCounts + 2)* imageW;
    self.scrollView.contentSize = CGSizeMake(contentW, 0);
}

@end
