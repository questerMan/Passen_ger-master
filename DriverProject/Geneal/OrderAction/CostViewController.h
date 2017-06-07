//
//  CostViewController.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/21.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BesaViewController.h"
#import <AMapSearchKit/AMapSearchObj.h>
#import <MAMapKit/MAGeometry.h>
#import "DDSearchManager.h"
#import "RideModel.h"

@protocol CostDelegate <NSObject>

-(void)loadCostDataWith:(NSString *)money carType:(NSString *)cartype;

@end

@interface CostViewController : BesaViewController

@property(assign)id<CostDelegate>costDelegate;

@property(nonatomic, retain)RideModel *rideModel;
@end
