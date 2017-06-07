//
//  CouponCell.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/13.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "CouponCell.h"


#define TIME_CONDITION_LABEL_FONT         [UIFont systemFontOfSize:13]
#define COUPON_TYPE_FONT                  [UIFont systemFontOfSize:15]
#define MONEY_LABEL_FONT                  [UIFont systemFontOfSize:30]
#define COLOR_YELLOW_KEY                  RGB(242, 149, 41)
#define COLOR_RED_KEY                     RGB(251, 88, 33)
#define COLOR_LIGHTGARY_KEY               RGB(181, 182, 183)
#define COLOR_GREEN_KEY                   RGB(56, 180, 143)

@implementation CouponCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self _initView];
    }
    
    return self;
}

/*
UIView *customView;         //自定义的背景View
UIImageView *tipsImg;       //前端示意图片
UILabel *symbolLabel;       //人民币图标
UILabel *moneyLabel;        //金额
UIView *line;               //竖线
UILabel *couponType;        //优惠券类型
UILabel *timeLabel;         //有效期
UILabel *conditionLabel;    //使用条件
 */

-(void)_initView
{
    customView = [[UIView alloc]init];
    customView.backgroundColor = [UIColor whiteColor];
    
    tipsImg = [[UIImageView alloc]init];
    
    symbolLabel = [UIFactory createLabel:@"¥" Font:[UIFont systemFontOfSize:20]];
    
    moneyLabel = [UIFactory createLabel:nil Font:MONEY_LABEL_FONT];
    
    line = [[UIView alloc]init];
    
    couponType = [UIFactory createLabel:nil Font:COUPON_TYPE_FONT];
//    couponType.backgroundColor = [UIColor redColor];
    
    timeLabel = [UIFactory createLabel:nil Font:TIME_CONDITION_LABEL_FONT];
//    timeLabel.backgroundColor = [UIColor blueColor];
    
    conditionLabel = [UIFactory createLabel:nil Font:TIME_CONDITION_LABEL_FONT];
//    conditionLabel.backgroundColor = [UIColor yellowColor];
    
    [self.contentView addSubview:customView];
    [customView addSubview:tipsImg];
    [customView addSubview:symbolLabel];
    [customView addSubview:moneyLabel];
    [customView addSubview:line];
    [customView addSubview:couponType];
    [customView addSubview:timeLabel];
    [customView addSubview:conditionLabel];

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    
    [tipsImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.right.equalTo(customView);
    }];
    
    [symbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipsImg.mas_left).with.offset(50);
        make.bottom.equalTo(customView.mas_bottom).with.offset(-20);
        make.height.and.width.mas_equalTo(@20);
    }];
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(symbolLabel.mas_right);//.with.offset(20)
        make.top.equalTo(customView.mas_top).with.offset(20);
        make.bottom.equalTo(symbolLabel.mas_bottom);
        make.width.equalTo(customView.mas_width).multipliedBy(0.2f);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(customView);
        make.left.equalTo(moneyLabel.mas_right);
        make.width.mas_equalTo(@1);
        make.height.equalTo(customView.mas_height).multipliedBy(0.8);
    }];
    
    if (self.couponModel.desc == nil ||self.couponModel.desc.length == 0) {
        //代金券
        
        [couponType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line.mas_right).offset(20);
            make.right.equalTo(customView.mas_right).offset(-10);
            make.top.equalTo(line.mas_top).offset(10);
            make.height.equalTo(line.mas_height).multipliedBy(0.4f);
        }];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(couponType);
            make.right.equalTo(customView.mas_right).offset(-10);
            make.bottom.equalTo(line.mas_bottom).offset(-10);
            make.height.equalTo(couponType.mas_height).multipliedBy(0.5f);
        }];
        
    }else{
        //非代金券
        
        [couponType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line.mas_right).offset(20);
            make.right.equalTo(customView.mas_right).offset(-10);
            make.bottom.equalTo(timeLabel.mas_top).offset(-5);
            make.top.equalTo(line.mas_top);
        }];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(couponType);
            make.right.equalTo(customView.mas_right).offset(-10);
            make.centerY.equalTo(customView);
            make.height.equalTo(couponType.mas_height).multipliedBy(0.5f);
        }];
        
        [conditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(couponType);
            make.bottom.equalTo(line.mas_bottom);
            make.top.equalTo(timeLabel.mas_bottom).offset(5);
        }];
    }
    
    NSString *is_expire = [NSString stringWithFormat:@"%@",self.couponModel.isexpire];
    
    if ([is_expire isEqualToString:@"0"]) {
        
        [tipsImg setImage:[UIImage imageNamed:@"coupon_press"]];
        
        line.backgroundColor = [UIColor lightGrayColor];
        
        couponType.textColor = [UIColor blackColor];
        
        timeLabel.textColor = kUIColorFromRGB(0x3ab48f);
        
        if (self.couponModel.desc == nil ||self.couponModel.desc.length == 0) {
            
            symbolLabel.textColor = COLOR_YELLOW_KEY;
            moneyLabel.textColor = COLOR_YELLOW_KEY;
            
        }else{
            
            symbolLabel.textColor = COLOR_YELLOW_KEY;
            moneyLabel.textColor = COLOR_YELLOW_KEY;
            conditionLabel.textColor = [UIColor blackColor];
            conditionLabel.text = self.couponModel.desc;
        }
        
    }else{
        
        [tipsImg setImage:[UIImage imageNamed:@"coupon_normal"]];

        line.backgroundColor = COLOR_LIGHTGARY_KEY;
        
        couponType.textColor = COLOR_LIGHTGARY_KEY;
        
        timeLabel.textColor = COLOR_LIGHTGARY_KEY;
        
        if (self.couponModel.desc== nil ||self.couponModel.desc.length == 0) {
            
            symbolLabel.textColor = COLOR_LIGHTGARY_KEY;
            moneyLabel.textColor = COLOR_LIGHTGARY_KEY;
            
        }else{
            
            symbolLabel.textColor = COLOR_LIGHTGARY_KEY;
            moneyLabel.textColor = COLOR_LIGHTGARY_KEY;
            conditionLabel.textColor = COLOR_LIGHTGARY_KEY;
            conditionLabel.text = self.couponModel.desc;
        }
    }
    
    UIEdgeInsets insets = UIEdgeInsetsMake(1, 35, 1, 20);
    tipsImg.image = [tipsImg.image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    moneyLabel.text = self.couponModel.money;
    couponType.text = self.couponModel.title;
    timeLabel.text = self.couponModel.expire;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
