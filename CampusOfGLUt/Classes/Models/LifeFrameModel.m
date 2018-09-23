//
//  LifeFrameModel.m
//  CampusOfGLUT
//
//  Created by HTC on 15/3/1.
//  Copyright (c) 2015年 HTC. All rights reserved.
//



#import "LifeFrameModel.h"
#import "LifeModel.h"

@implementation LifeFrameModel

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


- (void)setLifeModel:(LifeModel *)lifeModel
{
    _lifeModel = lifeModel;
    
    // 子控件之间的间距
    CGFloat padding = 10;
    
    // 1.topView
    CGFloat topViewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat topViewH = 0;
    CGFloat topViewX = 0;
    CGFloat topViewY = 0;
    
    // 1.头像
    CGFloat iconX = padding;
    CGFloat iconY = padding;
    CGFloat iconW = 42;
    CGFloat iconH = 42;
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    // 2.昵称
    // 文字的字体
    CGSize nameSize = [self sizeWithText:self.lifeModel.name font:LifeNameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat nameX = CGRectGetMaxX(_iconF) + padding;
    CGFloat nameY = iconY;
    _nameF = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    
    // 3.时间
    CGSize timeSize = [self sizeWithText:self.lifeModel.createtime font:LifeTimeFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat timeX = CGRectGetMaxX(_iconF) + padding;
    CGFloat timeY = (CGRectGetHeight(_iconF) - CGRectGetHeight(_nameF) - timeSize.height)/2 + CGRectGetMaxY(_nameF);
    _timeF = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
    
    
    // 4.正文
    CGFloat textX = iconX;
    CGFloat textY = CGRectGetMaxY(_iconF) + padding;
    CGSize textSize = [self sizeWithText:self.lifeModel.contents font:LifeTextFont maxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2* padding , MAXFLOAT)];
    _textF = CGRectMake(textX, textY, textSize.width, textSize.height);
    
    
    // 5.配图
    //(NSNull *)self.lifeModel.images != [NSNull null]
    if ((NSNull *)self.lifeModel.images != [NSNull null]) {// 有配图
        CGFloat pictureX = textX;
        CGFloat pictureY = CGRectGetMaxY(_textF) + padding;
        float ScreenW = [UIScreen mainScreen].bounds.size.width;
        
        CGFloat pictureW = ScreenW-2*pictureX;
        //CGFloat pictureH = pictureW*4/3;
        _pictureF = CGRectMake(pictureX, pictureY, pictureW, pictureW);
        
        //6.来源机型
        CGFloat comfromY = CGRectGetMaxY(_pictureF) +5;
        CGSize comefromSize = [self sizeWithText:self.lifeModel.comefrom font:ComeFromFont maxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2* padding , MAXFLOAT)];
        
        _comefromF = CGRectMake(topViewW - comefromSize.width -padding,comfromY, comefromSize.width, comefromSize.height);
        

    } else {
        
        //6.来源机型
        CGFloat comfromY = CGRectGetMaxY(_textF) +5;
        CGSize comefromSize = [self sizeWithText:self.lifeModel.comefrom font:ComeFromFont maxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2* padding , MAXFLOAT)];
        _comefromF = CGRectMake(topViewW - comefromSize.width -padding, comfromY, comefromSize.width, comefromSize.height);
    }
    
    
    topViewH = CGRectGetMaxY(_comefromF) + padding;
    
    _topViewF = CGRectMake(topViewX, topViewY, topViewW, topViewH);
    
    // 7.工具条
    CGFloat lifeToolbarX = topViewX;
    CGFloat lifeToolbarY = CGRectGetMaxY(_topViewF);
    CGFloat lifeToolbarW = topViewW;
    CGFloat lifeToolbarH = 35;
    _lifeToolbarF = CGRectMake(lifeToolbarX, lifeToolbarY, lifeToolbarW, lifeToolbarH);
    
    // 8.cell的高度
    _cellHeight = CGRectGetMaxY(_lifeToolbarF) + padding;
    
}
@end
