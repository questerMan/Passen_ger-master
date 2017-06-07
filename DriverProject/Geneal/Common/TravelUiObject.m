//
//  TravelUiObject.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/10.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "TravelUiObject.h"

@implementation TravelUiObject
{
    UIImageView *driverImg;
    UILabel *driverName;
    UILabel *driverMessage;
    UIImageView *starImg;
    UILabel *orderCount;
    UIButton *callBtn;
    
    BOOL isDriver;
    UILabel *cancelReason;
    NSDictionary *dataDic;
}

-(void)initUiObjectWith:(NSDictionary *)dic
{
    dataDic = [NSDictionary dictionaryWithDictionary:dic];
    int status = [[dic objectForKey:@"status"] intValue];
    BOOL isCancel =  ([[dic objectForKey:@"canceld"] intValue] == 1)?YES:NO;
    NSString *type = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"type"] intValue]];
    self.viewArrays = [NSMutableArray array];
    
    /**
     司机信息View
     */
    self.driverView = [[UIView alloc]initWithFrame:CGRectZero];
    _driverView.backgroundColor = [UIColor whiteColor];
    
    NSURL *imageUrl = [NSURL URLWithString:[[dic objectForKey:@"driver"] objectForKey:@"avatar"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    driverImg = [[UIImageView alloc]initWithImage:image];
//    driverImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dirver"]];
    
    driverName = [UIFactory createLabel:[dic objectForKey:DRIVER_NAME_KEY] Font:[UIFont systemFontOfSize:15]];
    
    driverMessage = [UIFactory createLabel:[dic objectForKey:DRIVER_CAR_KEY] Font:[UIFont systemFontOfSize:12]];
    driverMessage.textColor = [UIColor lightGrayColor];
    
    starImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"star_half_yellow"]];
    
    orderCount = [UIFactory createLabel:[dic objectForKey:DRIVER_ORDER_COUNT_KEY] Font:[UIFont systemFontOfSize:12]];
    orderCount.textColor = [UIColor lightGrayColor];
    
    callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [callBtn setImage:[UIImage imageNamed:@"phone_yellow"] forState:UIControlStateNormal];
    callBtn.tag = [[dic objectForKey:DRIVER_PHONE_NUMBER_KEY] integerValue];
    [callBtn addTarget:self action:@selector(callTheDriverPhoneWith:) forControlEvents:UIControlEventTouchUpInside];
    
    [_driverView addSubview:driverImg];
    [_driverView addSubview:driverName];
    [_driverView addSubview:driverMessage];
    [_driverView addSubview:starImg];
    [_driverView addSubview:orderCount];
    [_driverView addSubview:callBtn];
    
    if ([dic objectForKey:@"driver"] == nil) {
        
        isDriver = NO;
        self.driverView.frame = CGRectMake(0, 56, 0, 0);
        
    }else{
        
        isDriver = YES;
        self.driverView.frame = CGRectMake(0, 66, KScreenWidth, 80);
    }
    
    if (self.isBook) {
        
#pragma - mark 预约成功状态
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(10, _driverView.bottom + 20, KScreenWidth - 20, 130)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [_bgView.layer setCornerRadius:5];
        [_bgView.layer setBorderColor:COLOR_LINE.CGColor];
        [_bgView.layer setBorderWidth:0.5f];
        
        self.statusImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"check_circle_yellow"]];
        
        self.statusLabel = [UIFactory createLabel:@"正在为您指派司机" Font:[UIFont systemFontOfSize:15]];
        
        [_bgView addSubview:_statusImage];
        [_bgView addSubview:_statusLabel];
        
        self.phoneView = [[UIView alloc]initWithFrame:CGRectMake(10, _bgView.bottom + 20, KScreenWidth - 20, 40)];
        
        UILabel *firstLabel = [UIFactory createLabel:@"我们会在您出行前30分钟为您发送司机资料" Font:[UIFont systemFontOfSize:13]];
        firstLabel.textColor = [UIColor lightGrayColor];
        firstLabel.textAlignment = NSTextAlignmentLeft;
        //修改了隐藏该消息标签
        firstLabel.hidden = YES;
        firstLabel.frame = CGRectMake(0, 0, _phoneView.width, _phoneView.height/2 -1);
        
        UILabel *tipsLabel = [UIFactory createLabel:@"如有疑问请拨打客服电话：" Font:[UIFont systemFontOfSize:13]];
        tipsLabel.textColor = [UIColor lightGrayColor];
        tipsLabel.textAlignment = NSTextAlignmentLeft;
        tipsLabel.frame = CGRectMake(0, firstLabel.bottom + 2, _phoneView.width/2 + 10, _phoneView.height/2 - 1);
        
        UIImageView *phoneImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"call_yellow"]];
        phoneImg.frame = CGRectMake(tipsLabel.right, tipsLabel.origin.y, 15, tipsLabel.height);
        
        UILabel *phoneNumber = [UIFactory createLabel:@"4008-228-846" Font:[UIFont systemFontOfSize:13]];
        phoneNumber.textColor = RGB(244, 148, 45);
        phoneNumber.frame = CGRectMake(phoneImg.right + 3, tipsLabel.origin.y, tipsLabel.width - 20, tipsLabel.height);
        
        tipsLabel.hidden = YES;
        phoneImg.hidden = YES;
        phoneNumber.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callTheCustomerServicePhone)];
        
        [_phoneView addGestureRecognizer:tap];
        [_phoneView addSubview:firstLabel];
        [_phoneView addSubview:tipsLabel];
        [_phoneView addSubview:phoneImg];
        [_phoneView addSubview:phoneNumber];
        
        [self.viewArrays addObject:_bgView];
        [self.viewArrays addObject:_phoneView];
        
        return;
    }
    
    if (status == ORDER_STATUS_A && isCancel == NO) {
        
#pragma - mark 未接单未取消
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, _driverView.bottom + 8, KScreenWidth, 130)];
        _bgView.backgroundColor = [UIColor whiteColor];
        
        self.statusImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"account_circle_darkgray"]];
        
        self.statusLabel = [UIFactory createLabel:@"正在为您指派司机" Font:[UIFont systemFontOfSize:15]];
        
        [_bgView addSubview:_statusImage];
        [_bgView addSubview:_statusLabel];
        
        self.phoneView = [[UIView alloc]initWithFrame:CGRectMake(10, _bgView.bottom + 20, KScreenWidth - 20, 15)];
        
        UILabel *tipsLabel = [UIFactory createLabel:@"如有疑问请拨打客服电话：" Font:[UIFont systemFontOfSize:13]];
        tipsLabel.textColor = [UIColor lightGrayColor];
        tipsLabel.textAlignment = NSTextAlignmentRight;
        tipsLabel.frame = CGRectMake(0, 0, _phoneView.width/2 + 10, _phoneView.height);
        
        UIImageView *phoneImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"call_yellow"]];
        phoneImg.frame = CGRectMake(tipsLabel.right, 0, 15, tipsLabel.height);
        
        UILabel *phoneNumber = [UIFactory createLabel:@"4008-228-846" Font:[UIFont systemFontOfSize:13]];
        phoneNumber.textColor = RGB(244, 148, 45);
        phoneNumber.frame = CGRectMake(phoneImg.right + 3, 0, tipsLabel.width - 20, tipsLabel.height);
        tipsLabel.hidden = YES;
        phoneImg.hidden = YES;
        phoneNumber.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callTheCustomerServicePhone)];
        
        [_phoneView addGestureRecognizer:tap];
        [_phoneView addSubview:tipsLabel];
        [_phoneView addSubview:phoneImg];
        [_phoneView addSubview:phoneNumber];
        
        [self.viewArrays addObject:_bgView];
        [self.viewArrays addObject:_phoneView];
        
    }else if ((status == ORDER_STATUS_B || status == ORDER_STATUS_C || status == ORDER_STATUS_D) && isCancel == NO){
        
#pragma - mark 已接单未取消
        
        /**
         订单状态View
         */
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, _driverView.bottom + 8, KScreenWidth, 150)];
        _bgView.backgroundColor = [UIColor whiteColor];
        
        self.statusImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"account"]];
        
        self.statusLabel = [UIFactory createLabel:@"已指派司机" Font:[UIFont systemFontOfSize:15]];
        
        [_bgView addSubview:_statusImage];
        [_bgView addSubview:_statusLabel];
        
        self.phoneView = [[UIView alloc]initWithFrame:CGRectMake(10, _bgView.bottom + 20, KScreenWidth - 20, 15)];
        
        UILabel *tipsLabel = [UIFactory createLabel:@"如有疑问请拨打客服电话：" Font:[UIFont systemFontOfSize:13]];
        tipsLabel.textColor = [UIColor lightGrayColor];
        tipsLabel.textAlignment = NSTextAlignmentRight;
        tipsLabel.frame = CGRectMake(0, 0, _phoneView.width/2 + 10, _phoneView.height);
        tipsLabel.hidden = YES;
        
        UIImageView *phoneImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"call_yellow"]];
        phoneImg.frame = CGRectMake(tipsLabel.right, 0, 15, tipsLabel.height);
        phoneImg.hidden = YES;
        
        UILabel *phoneNumber = [UIFactory createLabel:@"4008-228-846" Font:[UIFont systemFontOfSize:13]];
        phoneNumber.textColor = RGB(244, 148, 45);
        phoneNumber.frame = CGRectMake(phoneImg.right + 3, 0, tipsLabel.width - 25, tipsLabel.height);
        phoneNumber.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callTheCustomerServicePhone)];
        
        [_phoneView addGestureRecognizer:tap];
        [_phoneView addSubview:tipsLabel];
        [_phoneView addSubview:phoneImg];
        [_phoneView addSubview:phoneNumber];
        
        [self.viewArrays addObject:_driverView];
        [self.viewArrays addObject:_bgView];
        [self.viewArrays addObject:_phoneView];

    }else if (isCancel == YES && status != ORDER_STATUS_A){
        
#pragma - mark 已接单已取消
        
        /**
         订单状态View
         */
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, _driverView.bottom + 8, KScreenWidth, 180)];
        _bgView.backgroundColor = [UIColor whiteColor];
        
        self.statusImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"off_darkgray"]];
        
        self.statusLabel = [UIFactory createLabel:@"行程已取消" Font:[UIFont systemFontOfSize:15]];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        
        cancelReason = [UIFactory createLabel:[NSString stringWithFormat:@"%@",[[dic objectForKey:@"cancel_body"] objectForKey:@"reason"]] Font:[UIFont systemFontOfSize:12]];
        cancelReason.textAlignment = NSTextAlignmentCenter;
        
        [_bgView addSubview:_statusImage];
        [_bgView addSubview:_statusLabel];
        [_bgView addSubview:cancelReason];
        
        [self.viewArrays addObject:_driverView];
        [self.viewArrays addObject:_bgView];
        
    }else if (isCancel == YES && status == ORDER_STATUS_A){
#pragma - mark 未接单已取消
        /**
         订单状态View
         */
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, _driverView.bottom + 8, KScreenWidth, 180)];
        _bgView.backgroundColor = [UIColor whiteColor];
        
        self.statusImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"off_darkgray"]];
        
        self.statusLabel = [UIFactory createLabel:@"行程已取消" Font:[UIFont systemFontOfSize:15]];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        
        cancelReason = [UIFactory createLabel:[NSString stringWithFormat:@"%@",[[dic objectForKey:@"cancel_body"] objectForKey:@"reason"]] Font:[UIFont systemFontOfSize:12]];
        cancelReason.textAlignment = NSTextAlignmentCenter;
        
        [_bgView addSubview:_statusImage];
        [_bgView addSubview:_statusLabel];
        [_bgView addSubview:cancelReason];
        
        [self.viewArrays addObject:_bgView];
    }
}

-(void)doAutoLayout:(int)status AndStatus:(BOOL)isCancel AndType:(int)type
{
    if (isDriver) {
        driverName.text = [[dataDic objectForKey:@"driver"] objectForKey:@"nickname"];
        driverMessage.text = [NSString stringWithFormat:@"%@ %@",[[dataDic objectForKey:@"driver"] objectForKey:@"license"],[[dataDic objectForKey:@"driver"] objectForKey:@"brand"]];
        
        if (![[[dataDic objectForKey:@"driver"] objectForKey:@"star"] isEqual:[NSNull null]])// && [[[dataDic objectForKey:@"driver"] objectForKey:@"brand"] length] > 0)
        {
            
            starImg.image = [self driverStarImageBy:[[[dataDic objectForKey:@"driver"] objectForKey:@"star"] intValue]*2 + 1];
        }else{
            
            starImg.image = [UIImage imageNamed:@"star_11"];
        }
        
        orderCount.text = [NSString stringWithFormat:@"%@单",[[dataDic objectForKey:@"driver"] objectForKey:@"order_num"]];
    }
    
    [driverImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_driverView);
        make.left.equalTo(_driverView).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [driverName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(driverImg.mas_right).with.offset(10);
        make.top.equalTo(driverImg).with.offset(3);
        make.size.mas_equalTo(CGSizeMake(170, 15));
    }];
    
    [driverMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(driverName.mas_left);
        make.top.equalTo(driverName.mas_bottom).with.offset(2);
        make.size.mas_equalTo(CGSizeMake(170, 15));
    }];
    
    [starImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(driverName.mas_left);
        make.top.equalTo(driverMessage.mas_bottom).with.offset(2);
        make.size.mas_equalTo(CGSizeMake(70, 13));
    }];
    
    [orderCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(starImg.mas_right).with.offset(5);
        make.top.equalTo(starImg.mas_top);
        make.size.mas_equalTo(CGSizeMake(100, 13));
    }];
    
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_driverView).with.offset(-15);
        make.centerY.equalTo(_driverView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    if (status == ORDER_STATUS_A && isCancel == NO && (type == 2 || type == 3 || type == 4)) {
#pragma - mark 预约成功
        [_statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_bgView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bgView);
            make.top.equalTo(_statusImage.mas_bottom).with.offset(5);
        }];
        
        return;
    }
    
    if (status == ORDER_STATUS_A && isCancel == YES) {
#pragma - mark 未接单已取消
        [_statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_bgView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bgView);
            make.top.equalTo(_statusImage.mas_bottom).with.offset(5);
        }];
        
        [cancelReason mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bgView);
            make.top.equalTo(_statusLabel.mas_bottom).with.offset(15);
            make.size.equalTo(_statusLabel);
        }];
        
        return;
    }
    
    if (status == ORDER_STATUS_A && isCancel == NO){
#pragma - mark 未接单未取消
        
        [_statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_bgView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bgView);
            make.top.equalTo(_statusImage.mas_bottom).with.offset(5);
        }];
        
    }else if ((status == ORDER_STATUS_B || status == ORDER_STATUS_C || status == ORDER_STATUS_D) && isCancel == NO){
#pragma - mark 已接单未取消
        
        [_statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_bgView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bgView);
            make.top.equalTo(_statusImage.mas_bottom).with.offset(5);
        }];
    }else if ((status == ORDER_STATUS_B || status == ORDER_STATUS_C || status == ORDER_STATUS_D || status == ORDER_STATUS_E || status == ORDER_STATUS_G || status == ORDER_STATUS_H) && isCancel == YES){
#pragma - mark 已接单已取消
        
        [_statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_bgView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.equalTo(_statusImage.mas_bottom).with.offset(5);
        }];
        
        [cancelReason mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bgView);
            make.top.equalTo(_statusLabel.mas_bottom).with.offset(15);
            make.size.equalTo(_statusLabel);
        }];
    }
    
}

-(UIImage *)driverStarImageBy:(int)starNum
{
    UIImage *starImgs = [[UIImage alloc]init];
    
    switch (starNum) {
        case 0:
            
            starImgs = [UIImage imageNamed:@"star_0"];
            break;
        
        case 1:
            
            starImgs = [UIImage imageNamed:@"star_1"];
            break;
            
        case 2:
            
            starImgs = [UIImage imageNamed:@"star_2"];
            break;
            
        case 3:
            
            starImgs = [UIImage imageNamed:@"star_3"];
            break;
            
        case 4:
            
            starImgs = [UIImage imageNamed:@"star_4"];
            break;
            
        case 5:
            
            starImgs = [UIImage imageNamed:@"star_5"];
            break;
            
        case 6:
            
            starImgs = [UIImage imageNamed:@"star_6"];
            break;
            
        case 7:
            
            starImgs = [UIImage imageNamed:@"star_7"];
            break;
            
        case 8:
            
            starImgs = [UIImage imageNamed:@"star_8"];
            break;
            
        case 9:
            
            starImgs = [UIImage imageNamed:@"star_9"];
            break;
            
        case 10:
            
            starImgs = [UIImage imageNamed:@"star_10"];
            break;
            
        case 11:
            
            starImgs = [UIImage imageNamed:@"star_11"];
            break;
            
        default:
            break;
    }
    return starImgs;
}

-(void)callTheCustomerServicePhone
{
    [UIFactory callThePhone:ServicePhone];
}

-(void)callTheDriverPhoneWith:(UIButton *)phoneNumer
{
    [UIFactory callThePhone:[[dataDic objectForKey:@"driver"] objectForKey:@"phone"]];
}

@end
