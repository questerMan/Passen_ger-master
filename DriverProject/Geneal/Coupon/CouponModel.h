//
//  CouponModel.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/14.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BaseModel.h"
#import "UserModel.h"

@interface CouponModel : BaseModel

@property(nonatomic,retain)UserModel *userModel;

@property(nonatomic, copy)NSString *couponID;
@property(nonatomic, copy)NSString *title;              //'优惠券名称'
@property(nonatomic, copy)NSString *desc;               //使用限制
@property(nonatomic, copy)NSString *money;              //0 不限制 ，多少天过期限制多少
@property(nonatomic, copy)NSString *isexpire;           //是否有效0 1
@property(nonatomic, copy)NSString *expire;             //有效日期

@end
