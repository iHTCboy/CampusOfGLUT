//
//  LifeTopView.m
//  CampusOfGLUT
//
//  Created by HTC on 15/3/27.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "LifeTopView.h"
#import "LifeFrameModel.h"
#import "LifeModel.h"
#import "UIImageView+WebCache.h"


@interface LifeTopView()

/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;
/**
 *  昵称
 */
@property (nonatomic, weak) UILabel *nameView;
/**
 *  时间
 */
@property (nonatomic, weak) UILabel *timeView;
/**
 *  正文
 */
@property (nonatomic, weak) UILabel *textView;
/**
 *  配图
 */
@property (nonatomic, weak) UIImageView *pictureView;

/** 来源机型 */
@property (nonatomic, weak) UILabel *comefromView;

@end

@implementation LifeTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 0.设置图片
        self.userInteractionEnabled = YES;
        self.image = [self resizedImageWithName:@"timeline_card_top_background"];
        self.highlightedImage = [self resizedImageWithName:@"timeline_card_top_background_highlighted"];
        
        // 1.头像
        UIImageView *iconView = [[UIImageView alloc] init];
        [self addSubview:iconView];
        self.iconView = iconView;
        
        // 2.昵称
        UILabel *nameView = [[UILabel alloc] init];
        nameView.font = LifeNameFont;
        nameView.textColor = [UIColor colorWithRed:66/255.0 green:156/255.0 blue:249/255.0 alpha:1.000];
        [self addSubview:nameView];
        self.nameView = nameView;
        
        // 3.时间图标
        UILabel *timeView = [[UILabel alloc] init];
        timeView.font = LifeTimeFont;
        timeView.textColor = [UIColor colorWithWhite:0.498 alpha:1.000];
        [self addSubview:timeView];
        self.timeView = timeView;
        
        // 4.正文
        UILabel *textView = [[UILabel alloc] init];
        textView.numberOfLines = 0;
        textView.font = LifeTextFont;
        [self addSubview:textView];
        self.textView = textView;

        // 5.配图
        UIImageView *pictureView = [[UIImageView alloc] init];
        pictureView.backgroundColor = [UIColor colorWithRed:0.937255 green:0.937255 blue:0.956863 alpha:1.000];
        pictureView.contentMode = UIViewContentModeScaleAspectFit;
        pictureView.userInteractionEnabled = YES;
        [self addSubview:pictureView];
        self.pictureView = pictureView;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPicture:)];
        [self.pictureView addGestureRecognizer:tap];
        
        
        // 6.来源机型
        UILabel *comefromView = [[UILabel alloc]init];
        comefromView.font = ComeFromFont;
        comefromView.textColor = [UIColor colorWithWhite:0.543 alpha:1.000];
        [self addSubview:comefromView];
        self.comefromView = comefromView;
    }
    return self;
}

#pragma mark - 图片点击
- (void)tapPicture:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(lifeTopViewClickedImageView:)])
    {
        [self.delegate lifeTopViewClickedImageView:self.lifeFrameModel.lifeModel];
        
    }
}


#pragma mark - 图片处理
- (UIImage *)resizedImageWithName:(NSString *)name
{
    return [self resizedImageWithName:name left:0.5 top:0.5];
}

- (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}


#pragma mark - set模型
- (void)setLifeFrameModel:(LifeFrameModel *)lifeFrameModel
{
    _lifeFrameModel = lifeFrameModel;
    
    // 1.取出模型数据
    LifeModel *lifeModel = lifeFrameModel.lifeModel;
    
    // 1.头像
    self.iconView.frame = self.lifeFrameModel.iconF;
    NSString * imagename = [NSString stringWithFormat:@"iconView_%d",[lifeModel.icon intValue]];
    self.iconView.image = [UIImage imageNamed:imagename];
    
    // 2.昵称
    self.nameView.frame = self.lifeFrameModel.nameF;
    self.nameView.text = lifeModel.name;
    
    // 3.时间
    self.timeView.frame = self.lifeFrameModel.timeF;
    self.timeView.text = lifeModel.createtime;
    
    // 4.正文
    self.textView.frame = self.lifeFrameModel.textF;
    self.textView.text = lifeModel.contents;
    
    // 5.配图
    if ((NSNull *)self.lifeFrameModel.lifeModel.images != [NSNull null])
    {// 有配图
        //http开头,有效url才显示
        if([self.lifeFrameModel.lifeModel.images hasPrefix:@"http"]){
            self.pictureView.frame = self.lifeFrameModel.pictureF;
        }
    }
    if ((NSNull *)lifeModel.images != [NSNull null]) { // 有配图
         //http开头才显示
        if([self.lifeFrameModel.lifeModel.images hasPrefix:@"http"]){
            self.pictureView.hidden = NO;
            NSArray * array = [lifeModel.images componentsSeparatedByString:@"|"];
            [self.pictureView sd_setImageWithURL:[NSURL URLWithString:array[0]] placeholderImage:nil];
        }
    } else { // 没有配图
        self.pictureView.hidden = YES;
    }
    
    // 6.来源机型
    self.comefromView.frame = self.lifeFrameModel.comefromF;
    self.comefromView.text = lifeModel.comefrom;
    
}

@end
