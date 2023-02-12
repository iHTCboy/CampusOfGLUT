//
//  LifesTableViewCell.m
//  CampusOfGLUT
//
//  Created by HTC on 15/3/1.
//  Copyright (c) 2015年 HTC. All rights reserved.
//


#import "LifesTableViewCell.h"


@interface LifesTableViewCell()

@end

@implementation LifesTableViewCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"lifeCell";
    LifesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LifesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 1.添加顶部的view
        [self setupTopView];
        [self setupLifeToolbar];
        
    }
    return self;
}


/**
 *  添加顶部的view
 */
- (void)setupTopView
{
    // 0.设置cell选中时的背景
    self.selectedBackgroundView = [[UIView alloc] init];
    self.backgroundColor = [UIColor clearColor];
    
    /** 1.顶部的view */
    LifeTopView *topView = [[LifeTopView alloc] init];
    [self.contentView addSubview:topView];
    self.topView = topView;
}


/**
 *  添加说说的工具条
 */
- (void)setupLifeToolbar
{
    /** 工具条 */
    LifeToolBarView *lifeToolbar = [[LifeToolBarView alloc] init];
    [self.contentView addSubview:lifeToolbar];
    self.lifeToolbar = lifeToolbar;
    
}


- (UIImage *)resizedImageWithName:(NSString *)name
{
    return [self resizedImageWithName:name left:1.0 top:0.5];
}

- (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}

/**
 *  在这个方法中设置子控件的frame和显示数据
 */
- (void)setLifeFrameModel:(LifeFrameModel *)lifeFrameModel
{
    _lifeFrameModel = lifeFrameModel;
    
    // 1.设置顶部view的数据
    [self setupTopViewData];
    
    // 2.设置工具条的数据
    [self setupLifeToolbarData];
}


/**
 *  设置顶部view的数据
 */
- (void)setupTopViewData
{
    // 1.topView
    self.topView.frame = self.lifeFrameModel.topViewF;
    
    // 2.传递模型数据
    self.topView.lifeFrameModel = self.lifeFrameModel;
}

/**
 *  设置工具条的数据
 */
- (void)setupLifeToolbarData
{
    self.lifeToolbar.frame = self.lifeFrameModel.lifeToolbarF;
    self.lifeToolbar.lifeFrameModel = self.lifeFrameModel;
    
}

@end
