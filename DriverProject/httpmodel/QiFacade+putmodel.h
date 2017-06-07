//
//  QiFacade+putmodel.h
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "QiFacade.h"
#import "QiFacade+http.h"
@interface QiFacade (putmodel)

#pragma - mark 更新个人资料

-(NSInteger)putAccountData:(NSString *)nickname Home_address:(NSString *)home_address Company_address:(NSString *)company_address Home_address_lon:(NSString *)home_address_lon Home_address_lat:(NSString *)home_address_lat Company_address_lat:(NSString *)company_address_lat Company_address_lon:(NSString *)company_address_lon;

#pragma - mark 取消行程

-(NSInteger)putOrder:(NSString *)reason WithID:(NSString *)orderID;



@end
