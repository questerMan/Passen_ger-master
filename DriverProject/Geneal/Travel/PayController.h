//
//  PayController.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/22.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BesaViewController.h"
#import "driverModel.h"

@interface PayController : BesaViewController

@property(nonatomic, retain)NSMutableArray *payArray;

@property(nonatomic, copy)NSString *pageType;

@property(nonatomic, copy)NSString *orderNum;

@property(nonatomic, copy)NSString *allCost;

@property(nonatomic, strong)NSDictionary *driverDic;

@property(nonatomic, strong)driverModel *driverModel;


@end
