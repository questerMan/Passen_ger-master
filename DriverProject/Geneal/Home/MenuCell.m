//
//  MenuCell.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/6.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "MenuCell.h"
#define CELLFONT        [UIFont systemFontOfSize:15]
@implementation MenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.lineView.backgroundColor=Dividingline_COLOR;
        [self initView];
        
    }
    return self;
}

- (void)initView
{
    
    self.titleLabel = [UIFactory createLabel:nil Font:CELLFONT];
    self.titleImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_titleImage];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleImage.mas_right).offset(10);
        make.height.equalTo(_titleImage);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)seperateLineIndentationWidth
{
    return 0;
}

@end
