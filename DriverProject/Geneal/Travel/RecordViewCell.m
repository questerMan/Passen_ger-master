//
//  RecordViewCell.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/11.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "RecordViewCell.h"

#define TIME_LABEL_FONT         [UIFont systemFontOfSize:12]
#define ADDRESS_LABEL_FONT      [UIFont systemFontOfSize:14]
#define RECORDTYPE_FONT         [UIFont systemFontOfSize:13]
#define LABEL_COLOR_GREEN       RGB(56, 180, 143)
#define LABEL_COLOR_ORANGE      RGB(242, 148, 44)
#define LABEL_COLOR_LIGHTGRAY   RGB(188, 189, 190)

//typedef enum{
//    
//};

@implementation RecordViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self _initView];
    }
    
    return self;
}

/*
 UILabel *timeLabel;
 UILabel *orderType;
 UIImageView *startImg;
 UIImageView *endImg;
 UILabel *startLabel;
 UILabel *endLabel;
 UILabel *recordType;
 */

-(void)_initView
{    
    timeLabel = [UIFactory createLabel:nil Font:TIME_LABEL_FONT];
    
    orderType = [[UIImageView alloc]init];
//    orderType = [self createTheCustomViewByOrderType:self.recordModel.orderType AndRecordType:self.recordModel.recordType];
    
    orederStatus = [UIFactory createLabel:nil Font:RECORDTYPE_FONT];
    orederStatus.textAlignment = NSTextAlignmentRight;
    
    startImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"start"]];
    
    startLabel = [UIFactory createLabel:nil Font:ADDRESS_LABEL_FONT];
    
    endImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pin_drop"]];
    
    endLabel = [UIFactory createLabel:nil Font:ADDRESS_LABEL_FONT];
    
    [self.contentView addSubview:timeLabel];
    [self.contentView addSubview:orderType];
    [self.contentView addSubview:orederStatus];
    [self.contentView addSubview:startImg];
    [self.contentView addSubview:startLabel];
    [self.contentView addSubview:endImg];
    [self.contentView addSubview:endLabel];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    timeLabel.text = self.recordModel.timeString;
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.3f);
        make.height.equalTo(self.contentView.mas_height).multipliedBy(0.15f);
    }];
    

    UILabel *label = [UIFactory createLabel:nil Font:[UIFont systemFontOfSize:8]];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    if ([self.recordModel.is_canceld intValue] == 0) {
        
        if ([self.recordModel.orderType isEqualToString:ORDER_TYPE_A]) {
            label.text = @"即时";
            [orderType setImage:[UIImage imageNamed:@"text_green"]];
        }else if ([self.recordModel.orderType isEqualToString:ORDER_TYPE_B]){
            label.text = @"预约";
            [orderType setImage:[UIImage imageNamed:@"text_yellow"]];
        }else if ([self.recordModel.orderType isEqualToString:ORDER_TYPE_C]){
            label.text = @"接机";
            [orderType setImage:[UIImage imageNamed:@"text_yellow"]];
        }else if ([self.recordModel.orderType isEqualToString:ORDER_TYPE_D]){
            label.text = @"送机";
            [orderType setImage:[UIImage imageNamed:@"text_yellow"]];
        }
        
    }else if([self.recordModel.is_canceld isEqualToString:@"1"]){
        
        if ([self.recordModel.orderType isEqualToString:ORDER_TYPE_A]) {
            label.text = @"即时";
        }else if ([self.recordModel.orderType isEqualToString:ORDER_TYPE_B]){
            label.text = @"预约";
        }else if ([self.recordModel.orderType isEqualToString:ORDER_TYPE_C]){
            label.text = @"接机";
        }else if ([self.recordModel.orderType isEqualToString:ORDER_TYPE_D]){
            label.text = @"送机";
        }
        [orderType setImage:[UIImage imageNamed:@"text_gray"]];
    }
    
    [orderType addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(orderType.mas_centerX);
        make.top.equalTo(orderType.mas_top).offset(1);
        make.height.equalTo(orderType.mas_height).with.offset(-3);
    }];
    
    [orderType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.mas_right);
        make.centerY.equalTo(timeLabel.mas_centerY);
        make.width.equalTo(timeLabel.mas_width).multipliedBy(0.25f);
        make.height.equalTo(timeLabel.mas_height).offset(3);
    }];
    
    [orederStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.centerY.equalTo(timeLabel.mas_centerY);
        make.height.equalTo(timeLabel.mas_height);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.25f);
    }];

    [startImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.mas_left);
        make.top.equalTo(timeLabel.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    startLabel.text = self.recordModel.startAddress;
    [startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(startImg.mas_centerY);
        make.left.equalTo(startImg.mas_right).with.offset(5);
        make.height.equalTo(startImg.mas_height);
        make.right.equalTo(orederStatus.mas_right);
    }];
    
    [endImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startImg.mas_left);
        make.top.equalTo(startImg.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    endLabel.text = self.recordModel.endAddress;
    [endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(endImg.mas_centerY);
        make.left.equalTo(endImg.mas_right).with.offset(5);
        make.height.equalTo(endImg.mas_height);
        make.width.equalTo(startLabel.mas_width);
    }];
    
    int statusNum = [self.recordModel.orderStatus intValue];
    if (statusNum == ORDER_STATUS_A) {
        orederStatus.text = @"未开始";
        orederStatus.textColor = kUIColorFromRGB(0xf4942d);
    }else if (statusNum == ORDER_STATUS_B){
        orederStatus.text = @"未开始";
        orederStatus.textColor = kUIColorFromRGB(0xf4942d);
    }else if (statusNum == ORDER_STATUS_C){
        orederStatus.text = @"行程中";
        orederStatus.textColor = kUIColorFromRGB(0x3ab48f);
    }else if (statusNum == ORDER_STATUS_D){
        orederStatus.text = @"行程中";
        orederStatus.textColor = kUIColorFromRGB(0x3ab48f);
    }else if (statusNum == ORDER_STATUS_E){
        orederStatus.text = @"行程中";
        orederStatus.textColor = kUIColorFromRGB(0x3ab48f);
    }else if (statusNum == ORDER_STATUS_G){
        orederStatus.text = @"行程中";
        orederStatus.textColor = kUIColorFromRGB(0x3ab48f);
    }else if (statusNum == ORDER_STATUS_H){
        orederStatus.text = @"已完成";
        orederStatus.textColor = kUIColorFromRGB(0x212121);
    }
    if ([self.recordModel.is_canceld intValue] == 1){
        orederStatus.text = @"已关闭";
        orederStatus.textColor = LABEL_COLOR_LIGHTGRAY;
        timeLabel.textColor = LABEL_COLOR_LIGHTGRAY;
        startLabel.textColor = LABEL_COLOR_LIGHTGRAY;
        endLabel.textColor = LABEL_COLOR_LIGHTGRAY;
        [startImg setImage:[UIImage imageNamed:@"place_darkgray"]];
        [endImg setImage:[UIImage imageNamed:@"pin_drop_garkgray"]];
    }
    
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
