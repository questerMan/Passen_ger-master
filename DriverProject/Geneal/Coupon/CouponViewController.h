//
//  CouponViewController.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/13.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BesaViewController.h"
#import "QiFacade+getmodel.h"

@interface CouponViewController : BesaViewController<QiFacadeHttpRequestDelegate>

@property(nonatomic,retain)NSMutableArray *couponArray;
@property(nonatomic,retain)NSMutableArray *couponListArray;

@end
