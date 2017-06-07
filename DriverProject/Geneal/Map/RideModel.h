//
//  RideModel.h
//  DriverProject
//
//  Created by 开涛 on 15/9/29.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BaseModel.h"
//#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAGeometry.h>
#import "DDSearchManager.h"

/*
 封装了呼叫车辆的信息
 */
@interface RideModel : BaseModel

//位置信息
@property (assign)CLLocationCoordinate2D startLocation;

@property (assign)CLLocationCoordinate2D endLocation;

@property (nonatomic, copy)NSString *startAddress;

@property (nonatomic, copy)NSString *endAddress;

@property (nonatomic, copy)NSString *startAddressDetail;

@property (nonatomic, copy)NSString *endAddressDetail;

//必要信息
@property (nonatomic, assign)BOOL   isSend;         //是否发送短信

@property (nonatomic, copy)NSString *cost;          //费用

@property (nonatomic, copy)NSString *preferential;  //优惠费用

@property (nonatomic, copy)NSString *distance;      //距离

@property (nonatomic, copy)NSString *time;          //花费时间

@property (nonatomic, copy)NSString *preTime;       //用车时间(立即/预约)1970

@property (nonatomic, copy)NSString *passenger;     //乘客名

@property (nonatomic, copy)NSString *passengerPhone;//乘客号码

@property (nonatomic, assign)OrderType orderType;   //用车类型（即时，预约，接机，送机）

@property (nonatomic, strong)NSString *carType;      //车辆选型（根据服务端返回）

@property (nonatomic, strong)NSString *flightNum;   //航班号

@property (nonatomic, strong)NSString *flightDate;  //航班时间



//计算距离/时间
-(void)computationalDistanceAndTime:(CLLocationCoordinate2D)startLocation
                        endLocation:(CLLocationCoordinate2D)endLocation
                                successBlock:(void(^)(float distance,float duration))successBlock
                                     failure:(void(^)())failureBlock;

@end
