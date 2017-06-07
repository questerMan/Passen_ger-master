//
//  AccountBalanceController.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/22.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BesaViewController.h"
#import "AccountCell.h"
#import "AccountModel.h"
#import <MJRefresh.h>
#import "QiFacade+getmodel.h"

@interface AccountBalanceController : BesaViewController<QiFacadeHttpRequestDelegate>

@property(nonatomic, copy)NSString *amountString;

@property(nonatomic, retain)NSMutableArray *accountArray;

@property(nonatomic, retain)NSMutableArray *accountListArray;

@end
