//
//  CommonPopView.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/17.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "CommonPopView.h"
#import "BesaViewController.h"

#define TITLE_LABEL_FONT        [UIFont systemFontOfSize:16]
#define ITEMS_LABEL_FONT        [UIFont systemFontOfSize:14]

@implementation CommonPopView
{
    UIImageView *driverImg;
    UILabel *driverName;
    UILabel *driverMessage;
    UIImageView *starImg;
    UILabel *orderCount;
    UIButton *callBtn;
    NSString *driverPhone;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(instancetype)initPopViewFrame:(CGRect)frame AndDriverData:(NSDictionary *)data
{
    driverPhone = [data objectForKey:@"phone"];
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        NSURL *imageUrl = [NSURL URLWithString:[data objectForKey:@"avatar"]];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        driverImg = [[UIImageView alloc]initWithImage:image];
        
        driverName = [UIFactory createLabel:[data objectForKey:@"nickname"] Font:[UIFont systemFontOfSize:15]];
        
        NSString *message = [NSString stringWithFormat:@"%@ %@",[data objectForKey:@"license"],[data objectForKey:@"brand"]];
        driverMessage = [UIFactory createLabel:message Font:[UIFont systemFontOfSize:12]];
        driverMessage.textColor = [UIColor lightGrayColor];
        
        int starNum = [[data objectForKey:DRIVER_STAR_KEY] intValue];
        NSString *starStr = [NSString stringWithFormat:@"star_%d",(starNum * 2) + 1];
        starImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:starStr]];
        
        NSString *count = [NSString stringWithFormat:@"%d单",[[data objectForKey:@"order_num"] intValue]];
        orderCount = [UIFactory createLabel:count Font:[UIFont systemFontOfSize:12]];
        orderCount.textColor = [UIColor lightGrayColor];
        
        callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [callBtn setImage:[UIImage imageNamed:@"phone_yellow"] forState:UIControlStateNormal];
        callBtn.tag = [[data objectForKey:DRIVER_PHONE_NUMBER_KEY] integerValue];
        [callBtn addTarget:self action:@selector(callTheDriverPhone) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:driverImg];
        [self addSubview:driverName];
        [self addSubview:driverMessage];
        [self addSubview:starImg];
        [self addSubview:orderCount];
        [self addSubview:callBtn];
        
        [self drawView:frame];
    }
    
    return self;
}

-(void)drawView:(CGRect)frame
{
    [driverImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [driverName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(driverImg.mas_right).with.offset(10);
        make.top.equalTo(driverImg).with.offset(3);
        make.size.mas_equalTo(CGSizeMake(170, 15));
    }];
    
    [driverMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(driverName.mas_left);
        make.top.equalTo(driverName.mas_bottom).with.offset(3);
        make.size.mas_equalTo(CGSizeMake(170, 15));
    }];
    
    [starImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(driverName.mas_left);
        make.top.equalTo(driverMessage.mas_bottom).with.offset(3);
        make.size.mas_equalTo(CGSizeMake(70, 12));
    }];
    
    [orderCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(starImg.mas_right).with.offset(5);
        make.top.equalTo(starImg.mas_top);
        make.size.mas_equalTo(CGSizeMake(100, 12));
    }];
    
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];

}

-(void)callTheDriverPhone
{
    [self.popDelegate popBtnDidRingUpByDriverPhoneNumber:driverPhone];
}

@end
