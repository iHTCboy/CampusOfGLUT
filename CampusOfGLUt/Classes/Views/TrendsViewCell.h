//
//  TrendsViewCell.h
//  CampusOfGLUt
//
//  Created by HTC on 15/2/12.
//  Copyright (c) 2015年 HTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrendsViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthor;
@property (weak, nonatomic) IBOutlet UILabel *lblClicks;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@end
