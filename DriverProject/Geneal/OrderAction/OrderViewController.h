//
//  OrderViewController.h
//  DriverProject
//
//  Created by 林镇杰 on 15/10/8.
//  Copyright © 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BesaViewController.h"
#import "MapView.h"
#import "OrderModel.h"
#import "driverModel.h"

@protocol OrderViewControllerDlegate <NSObject>

-(void)backSuperView:(NSInteger)tag;

@end

@interface OrderViewController : BesaViewController<MyMapVieDidDelegate>

@property(retain, nonatomic)MapView  *mapView;
//@property(strong, nonatomic)RideModel *rideModel;
@property(strong, nonatomic)OrderModel *ordermodel;//订单
@property(strong, nonatomic)driverModel *driModel;//司机信息
@property(assign)id<OrderViewControllerDlegate>delegate;

-(void)setOrdermodelData:(OrderModel *)ordermodel;

-(void)setRideModelData:(RideModel *)rideModel;

@end
