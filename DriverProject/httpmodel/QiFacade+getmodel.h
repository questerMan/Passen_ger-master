//
//  QiFacade+getmodel.h
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "QiFacade.h"
#import "QiFacade+http.h"


@interface QiFacade (getmodel)

#pragma - mark 获取司机公开信息

-(NSInteger)getDriverDataWithID:(NSString *)driverID;

#pragma - mark 获取车型列表

-(NSInteger)getCarData;

#pragma - mark 获取个人资料

-(NSInteger)getAccountData;

#pragma - mark 行程记录

-(NSInteger)getOrder:(NSString *)page Per_page:(NSString *)per_page;

#pragma - mark 行程详情

-(NSInteger)getOrderDetailsWithID:(NSString *)orderID;

#pragma - mark 费用明细

-(NSInteger)getOrderFeeWithID:(NSString *)orderID;

#pragma - mark 我的余额

-(NSInteger)getBalance:(NSString *)page Per_page:(NSString *)per_page;

#pragma - mark 获取优惠券

-(NSInteger)getCoupons:(NSString *)page Per_page:(NSString *)per_page;

#pragma - mark 开票历史

-(NSInteger)getInvoice:(NSString *)page Per_page:(NSString *)per_page;

#pragma - mark 微信支付

-(NSInteger)getWePay:(NSString *)orderID;

-(NSInteger)getTest;

@end
