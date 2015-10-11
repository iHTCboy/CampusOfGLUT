//
//  JGProgressHUDErrorIndicatorView.m
//  JGProgressHUD
//
//  Created by Jonas Gessner on 19.08.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#import "JGProgressHUDErrorIndicatorView.h"
#import "JGProgressHUD.h"

@implementation JGProgressHUDErrorIndicatorView

- (instancetype)initWithContentView:(UIView *__unused)contentView {
    NSBundle *fwBundle = [NSBundle bundleForClass:[JGProgressHUD class]];
    if ([fwBundle isEqual:[NSBundle mainBundle]]) {
        fwBundle = nil;
    }
    
    NSString *imgPath = [(fwBundle ? : [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"JGProgressHUD Resources" ofType:@"bundle"]]) pathForResource:@"jg_hud_error" ofType:@"png"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imgPath]];
    
    self = [super initWithContentView:imageView];
    
    return self;
}

- (instancetype)init {
    return [self initWithContentView:nil];
}

@end
