//
//  TypeCell.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/20.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "TypeCell.h"
#define TITLE_TYPE_FONT                  [UIFont systemFontOfSize:15]
@implementation TypeCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self _initView];
    }
    
    return self;
}

-(void)_initView
{
    _logoImg = [[UIImageView alloc]init];
    
    _typeTitle = [UIFactory createLabel:nil Font:TITLE_TYPE_FONT];
    
    _statusImg = [[UIImageView alloc]init];
    
    [self.contentView addSubview:_logoImg];
    [self.contentView addSubview:_typeTitle];
    [self.contentView addSubview:_statusImg];
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    [_logoImg setImage:self.typeModel.logo];
    
    _typeTitle.text = self.typeModel.title;
    
    if ([self.typeModel.status isEqualToString:@"YES"]) {
        
        [_statusImg setImage:[UIImage imageNamed:@"check_circle_yellow"]];
        
        _typeTitle.textColor = RGB(241, 148, 46);
        
    }else{
        
        [_statusImg setImage:nil];
        
        _typeTitle.textColor = [UIColor blackColor];
    }
    
    [_logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.width.mas_equalTo(@20);
        make.height.mas_equalTo(@20);
    }];
    
    [_typeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_logoImg.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(_logoImg);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.8f);
    }];
    
    [_statusImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(_logoImg);
        make.height.equalTo(_logoImg);
    }];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
