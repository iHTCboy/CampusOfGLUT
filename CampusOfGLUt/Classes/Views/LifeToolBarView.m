//
//  LifeToolBarView.m
//  CampusOfGLUT
//
//  Created by HTC on 15/3/27.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import "LifeToolBarView.h"
#import "LifeFrameModel.h"
#import "LifeModel.h"

@interface LifeToolBarView()

@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSMutableArray *dividers;
@property (nonatomic, weak) UIButton *reweetBtn;
@property (nonatomic, weak) UIButton *commentBtn;
@property (nonatomic, weak) UIButton *attitudeBtn;

@end


@implementation LifeToolBarView


- (NSMutableArray *)btns
{
    if (_btns == nil) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

- (NSMutableArray *)dividers
{
    if (_dividers == nil) {
        _dividers = [NSMutableArray array];
    }
    return _dividers;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.设置图片
        self.userInteractionEnabled = YES;
       self.image = [self resizedImageWithName:@"timeline_card_bottom_background"];
        self.highlightedImage = [self resizedImageWithName:@"timeline_card_bottom_background_highlighted"];
        
        // 2.添加按钮
        self.reweetBtn = [self setupBtnWithTitle:@"分享" image:@"timeline_icon_retweet" bgImage:@"timeline_card_leftbottom_highlighted"];
        self.commentBtn = [self setupBtnWithTitle:@"评论" image:@"timeline_icon_comment" bgImage:@"timeline_card_middlebottom_highlighted"];
        self.attitudeBtn = [self setupBtnWithTitle:@"赞" image:@"timeline_icon_unlike" bgImage:@"timeline_card_rightbottom_highlighted"];
        //单独设置
        [self.attitudeBtn setImage:[UIImage imageNamed:@"timeline_icon_like"] forState:UIControlStateSelected];
        
        // 3.添加分割线
        [self setupDivider];
        [self setupDivider];
        
    }
    return self;
}


- (UIImage *)resizedImageWithName:(NSString *)name
{
    return [self resizedImageWithName:name left:0.5 top:0.5];
}

- (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}

/**
 *  初始化分割线
 */
- (void)setupDivider
{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    [self addSubview:divider];
    [self.dividers addObject:divider];
}

/**
 *  初始化按钮
 *
 *  @param title   按钮的文字
 *  @param image   按钮的小图片
 *  @param bgImage 按钮的背景
 */
- (UIButton *)setupBtnWithTitle:(NSString *)title image:(NSString *)image bgImage:(NSString *)bgImage
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    btn.adjustsImageWhenHighlighted = NO;
    [btn setBackgroundImage:[self resizedImageWithName:bgImage] forState:UIControlStateHighlighted];
    [self addSubview:btn];
    
    // 添加按钮到数组
    [self.btns addObject:btn];
    
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.设置按钮的frame
    NSInteger dividerCount = self.dividers.count; // 分割线的个数
    CGFloat dividerW = 1; // 分割线的宽度
    NSInteger btnCount = self.btns.count;
    CGFloat btnW = (self.frame.size.width - dividerCount * dividerW) / btnCount;
    CGFloat btnH = self.frame.size.height;
    CGFloat btnY = 0;
    for (int i = 0; i<btnCount; i++) {
        UIButton *btn = self.btns[i];
        btn.tag = i;
        [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        // 设置frame
        CGFloat btnX = i * (btnW + dividerW);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    
    // 2.设置分割线的frame
    CGFloat dividerH = btnH;
    CGFloat dividerY = 0;
    for (int j = 0; j<dividerCount; j++) {
        UIImageView *divider = self.dividers[j];
        
        // 设置frame
        UIButton *btn = self.btns[j];
        CGFloat dividerX = CGRectGetMaxX(btn.frame);
        divider.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
    }
    
    //增加底部分隔线
    UIImageView *separator = [[UIImageView alloc]initWithFrame:CGRectMake(0,btnH + btnY - 3.5, self.frame.size.width, 15)];
    //separator.backgroundColor = [UIColor redColor];
    // separator.image = [self resizedImageWithName:@"timeline_cell_separator"];
    separator.image = [self resizedImageWithName:@"timeline_card_top_background_highlighted"];
    [self addSubview:separator];
    
}

- (void)setLifeFrameModel:(LifeFrameModel *)lifeFrameModel
{
    _lifeFrameModel = lifeFrameModel;
     LifeModel * lifeModel = lifeFrameModel.lifeModel;
    
    // 1.设置转发数
   // [self setupBtn:self.reweetBtn originalTitle:@"转发" count:lifeModel.];

    
    
    NSInteger counts = 0;
    if ((NSNull *)lifeModel.commets != [NSNull null]) {
        
        //网络来的空
        if (![[[lifeModel.commets class] description] isEqualToString:@"__NSCFConstantString"]) {
             counts = [lifeModel.commets componentsSeparatedByString:@"{3}"].count;
        }
    }
    [self setupBtn:self.commentBtn originalTitle:@"评论" count:(int)counts];
    
    [self setupBtn:self.attitudeBtn originalTitle:@"赞" count:[lifeModel.praises intValue]];
    
    // 2.是否已经点赞
    if(lifeModel.isLicked){
        self.attitudeBtn.selected = YES;
    }else{
        self.attitudeBtn.selected = NO;
    }
}

/**
 *  设置按钮的显示标题
 *
 *  @param btn           哪个按钮需要设置标题
 *  @param originalTitle 按钮的原始标题(显示的数字为0的时候, 显示这个原始标题)
 *  @param count         显示的个数
 */
- (void)setupBtn:(UIButton *)btn originalTitle:(NSString *)originalTitle count:(int)count
{
    /**
     0 -> @"转发"
     <10000  -> 完整的数量, 比如个数为6545,  显示出来就是6545
     >= 10000
     * 整万(10100, 20326, 30000 ....) : 1万, 2万
     * 其他(14364) : 1.4万
     */
    
    if (count) { // 个数不为0
        NSString *title = nil;
        if (count < 10000) { // 小于1W
            title = [NSString stringWithFormat:@"%d", count];
        } else { // >= 1W
            // 42342 / 1000 * 0.1 = 42 * 0.1 = 4.2
            // 10742 / 1000 * 0.1 = 10 * 0.1 = 1.0
            // double countDouble = count / 1000 * 0.1;
            
            // 42342 / 10000.0 = 4.2342
            // 10742 / 10000.0 = 1.0742
            double countDouble = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万", countDouble];
            
            // title == 4.2万 4.0万 1.0万 1.1万
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
        [btn setTitle:title forState:UIControlStateNormal];
    } else {
        [btn setTitle:originalTitle forState:UIControlStateNormal];
    }
}

- (void) clickedBtn:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(lifeToolBarClicked: lifeMode: superviewCell:)]) {
        [self.delegate lifeToolBarClicked:btn lifeMode:_lifeFrameModel superviewCell:[self superview]];
    }

}


@end
