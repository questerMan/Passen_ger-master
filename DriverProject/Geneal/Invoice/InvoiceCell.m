//
//  InvoiceCell.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/15.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "InvoiceCell.h"

#define NAME_LABEL_FONT                     [UIFont systemFontOfSize:15]
#define TIME_AND_STATUS_FONT                [UIFont systemFontOfSize:12]
#define MONEY_LABEL_FONT                    [UIFont systemFontOfSize:20]
#define MONEY_LABEL_FONT_17                    [UIFont systemFontOfSize:17]

@implementation InvoiceCell

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
    self.name = [UIFactory createLabel:nil Font:NAME_LABEL_FONT];
    
    self.time = [UIFactory createLabel:nil Font:TIME_AND_STATUS_FONT];
    _time.textColor = RGB(150, 151, 152);
    
    self.status = [UIFactory createLabel:nil Font:TIME_AND_STATUS_FONT];
    _status.textColor = RGB(150, 151, 152);
    
    self.amount = [UIFactory createLabel:nil Font:MONEY_LABEL_FONT_17];
    _amount.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:self.name];
    [self.contentView addSubview:self.time];
    [self.contentView addSubview:self.status];
    [self.contentView addSubview:self.amount];
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    self.name.text = self.invoiceModel.name;
    self.time.text = self.invoiceModel.time;
    
    NSString *statusStr = [NSString stringWithFormat:@"%@",self.invoiceModel.status];
    if ([statusStr isEqualToString:@"1"]) {
        
        self.status.text = [NSString stringWithFormat:@"（%@：%@）",self.invoiceModel.send_method,self.invoiceModel.send_no];
        
    }else{
        
        self.status.text = @"待处理";
        
    }
    
    self.amount.text = self.invoiceModel.amount;
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.height.equalTo(self.contentView.mas_height).multipliedBy(0.4f);
        make.right.equalTo(self.amount.mas_left);
    }];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_left);
        make.top.equalTo(self.name.mas_bottom).offset(5);
        make.height.equalTo(self.name.mas_height).multipliedBy(0.7f);
        make.width.mas_equalTo(@70);
    }];
    
    [self.amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(self.contentView.mas_height).multipliedBy(0.4f);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.15f);
    }];
    
    [self.status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.time.mas_right);
        make.top.and.height.equalTo(self.time);
        make.right.equalTo(self.amount.mas_left);
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
