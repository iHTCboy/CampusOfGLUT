//
//  CommentView.m
//  CampusOfGLUT
//
//  Created by HTC on 15/3/29.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "CommentView.h"
#import "CommentFrameModel.h"
#import "CommentModel.h"

@interface CommentView()


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
@property (nonatomic, weak) UILabel *commentView;
/**
 *  楼层
 */
@property (nonatomic, weak) UILabel *storeyView;

/** 来源机型 */
@property (nonatomic, weak) UILabel *comefromView;

@end

@implementation CommentView

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
        nameView.font = NameFont;
        nameView.textColor = [UIColor colorWithRed:66/255.0 green:156/255.0 blue:249/255.0 alpha:1.000];
        [self addSubview:nameView];
        self.nameView = nameView;
        
        // 3.时间图标
        UILabel *timeView = [[UILabel alloc] init];
        timeView.font = TimeFont;
        timeView.textColor = [UIColor colorWithWhite:0.498 alpha:1.000];
        [self addSubview:timeView];
        self.timeView = timeView;
        
        // 4.正文
        UILabel *commentView = [[UILabel alloc] init];
        commentView.numberOfLines = 0;
        commentView.font = CommetsFont;
        [self addSubview:commentView];
        self.commentView = commentView;
        
        // 5.楼层
        UILabel *storeyView = [[UILabel alloc]init];
        storeyView.font = StoreyFont;
        storeyView.textColor = [UIColor colorWithRed:1.000 green:0.153 blue:0.306 alpha:1.000];
        [self addSubview:storeyView];
        self.storeyView = storeyView;
        
        
        // 6.来源机型
        UILabel *comefromView = [[UILabel alloc]init];
        comefromView.font = ComeFromFont;
        comefromView.textColor = [UIColor colorWithWhite:0.543 alpha:1.000];
        [self addSubview:comefromView];
        self.comefromView = comefromView;
    }
    return self;
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
- (void)setCommentFrameModel:(CommentFrameModel *)commentFrameModel
{
    _commentFrameModel = commentFrameModel;
    
    // 1.取出模型数据
    CommentModel *commentModel = commentFrameModel.commentModel;
    
    // 1.头像
    self.iconView.frame = self.commentFrameModel.iconF;
    NSString * imagename = [NSString stringWithFormat:@"iconView_%d",[commentModel.icon intValue]];
    self.iconView.image = [UIImage imageNamed:imagename];
    
    // 2.昵称
    self.nameView.frame = self.commentFrameModel.nameF;
    self.nameView.text = commentModel.name;
    
    // 3.时间
    self.timeView.frame = self.commentFrameModel.timeF;
    self.timeView.text = commentModel.time;
    
    // 4.正文
    self.commentView.frame = self.commentFrameModel.commetsF;
    self.commentView.text = commentModel.contents;
    
    // 5.配图
    self.storeyView.frame = self.commentFrameModel.storeyF;
    self.storeyView.text = [NSString stringWithFormat:@"%@楼",commentModel.ID];
    
    // 6.来源机型
    self.comefromView.frame = self.commentFrameModel.comefromF;
    self.comefromView.text = commentModel.comefrom;
    
}


@end
