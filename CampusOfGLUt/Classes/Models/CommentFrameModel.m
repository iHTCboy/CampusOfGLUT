//
//  CommentFrameModel.m
//  CampusOfGLUT
//
//  Created by HTC on 15/3/29.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "CommentFrameModel.h"
#import "CommentModel.h"

@implementation CommentFrameModel

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


- (void)setCommentModel:(CommentModel *)commentModel
{
    _commentModel = commentModel;
    
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
    
    // 5.楼层
    CGFloat storeyY = iconY;
    CGSize storeySize = [self sizeWithText:[NSString stringWithFormat:@"%@楼",self.commentModel.ID] font:StoreyFont maxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width /2 -2*padding , MAXFLOAT)];
    _storeyF = CGRectMake([UIScreen mainScreen].bounds.size.width - padding - storeySize.width, storeyY, storeySize.width, storeySize.height);
    
    // 2.昵称
    CGSize nameSize = [self sizeWithText:self.commentModel.name font:NameFont maxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - padding - storeySize.width - CGRectGetWidth(_iconF), iconH/2)];
    CGFloat nameX = CGRectGetMaxX(_iconF) + padding;
    CGFloat nameY = iconY;
    _nameF = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    
    
    
    // 3.时间
    CGSize timeSize = [self sizeWithText:self.commentModel.time font:TimeFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat timeX = CGRectGetMaxX(_iconF) + padding;
    CGFloat timeY = (CGRectGetHeight(_iconF) - CGRectGetHeight(_nameF) - timeSize.height)/2 + CGRectGetMaxY(_nameF);
    _timeF = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
    
    
    // 4.正文
    CGFloat textX = iconX;
    CGFloat textY = CGRectGetMaxY(_iconF) + padding;
    CGSize textSize = [self sizeWithText:self.commentModel.contents font:CommetsFont maxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2* padding , MAXFLOAT)];
    _commetsF = CGRectMake(textX, textY, textSize.width, textSize.height);
    
        
    // 6.来源机型
    CGFloat comfromY = CGRectGetMaxY(_commetsF) +5;
    CGSize comefromSize = [self sizeWithText:self.commentModel.comefrom font:ComeFromFont maxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width /2 , MAXFLOAT)];
    _comefromF = CGRectMake([UIScreen mainScreen].bounds.size.width - padding - comefromSize.width, comfromY, comefromSize.width, comefromSize.height);
    

    topViewH = CGRectGetMaxY(_comefromF) + padding;
    
    _topViewF = CGRectMake(topViewX, topViewY, topViewW, topViewH);
    
    // 7.cell的高度
    _cellHeight = CGRectGetMaxY(_topViewF);
    
}
@end
