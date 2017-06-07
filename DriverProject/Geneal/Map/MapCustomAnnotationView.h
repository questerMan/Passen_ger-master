//
//  MapCustomAnnotationView.h
//  GDAPI
//
//  Created by 开涛 on 15/7/26.
//  Copyright (c) 2015年 com.LHW.TESTGDAPI. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "MapCustomCalloutStartView.h"
#import "MapCustomCalloutWatingView.h"
#import "MapCustomCalloutDrivingView.h"
#import "MapCustomCalloutEndView.h"

#import "RideModel.h"


@protocol MapCustomAnnotationViewDelegate <NSObject>

- (void)pushToSearchViewController:(SearchType)status andAddress:(NSString *)address;

@end

@interface MapCustomAnnotationView : MAAnnotationView

@property (nonatomic, strong) MapCustomCalloutStartView   *calloutView;//起点状态
@property (nonatomic, strong) MapCustomCalloutWatingView  *watingoutView;//等待司机到达
@property (nonatomic, strong) MapCustomCalloutDrivingView *drivingoutView;//司机行驶中
@property (nonatomic, strong) MapCustomCalloutEndView     *endCalloutView;//司机到达
@property (nonatomic, assign) RideState rideState;//乘车状态
@property (assign)id<MapCustomAnnotationViewDelegate>annotationDelegate;
//选择起点
//选择终点后
//@property (nonatomic, strong)NSString *startLocation;
//@property (nonatomic, strong)NSString *endLocation;
//@property (nonatomic, strong)NSString *subTitle;
//@property (strong, nonatomic)NSString *cost;//费用
//@property (strong, nonatomic)NSString *distance;//距离

@property (strong, nonatomic)RideModel *rideModel;

- (void)automaticAlignment;

-(void)setAnnotationRideState:(RideState)rideState;
@end
