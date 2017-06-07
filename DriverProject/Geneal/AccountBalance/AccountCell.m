//
//  AccountCell.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/22.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "AccountCell.h"
#define TIME_LABEL_FONT                     [UIFont systemFontOfSize:12]
#define NAME_AND_AMOUT_FONT                [UIFont systemFontOfSize:14]

@implementation AccountCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self _initView];
    }
    
    return self;
}

-(void)_initView
{
    self.name = [UIFactory createLabel:nil Font:NAME_AND_AMOUT_FONT];
    
    self.time = [UIFactory createLabel:nil Font:TIME_LABEL_FONT];
    _time.textColor = [UIColor lightGrayColor];
    
    self.amount = [UIFactory createLabel:nil Font:NAME_AND_AMOUT_FONT];
    _amount.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:_name];
    [self.contentView addSubview:_time];
    [self.contentView addSubview:_amount];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.name.text = self.accountModel.name;
    self.time.text = self.accountModel.time;
    self.amount.text = self.accountModel.amount;
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(@14);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.7f);
    }];
    
    [self.amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.left.equalTo(self.name.mas_right).offset(2);
        make.height.equalTo(self.contentView.mas_height).multipliedBy(0.5f);
    }];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_left);
        make.top.equalTo(self.name.mas_bottom).offset(2);
        make.height.mas_equalTo(@10);
        make.width.equalTo(self.name);
    }];
}

- (CGFloat)seperateLineIndentationWidth
{
    return 0;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
