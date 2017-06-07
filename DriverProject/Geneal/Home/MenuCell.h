//
//  MenuCell.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/6.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FETableViewCell.h"

@interface MenuCell :FETableViewCell

@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UIImageView *titleImage;
@property (nonatomic, copy)NSString *titleString;
@end
