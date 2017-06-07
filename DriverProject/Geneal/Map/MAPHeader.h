//
//  MAPHeader.h
//  DriverProject
//
//  Created by 开涛 on 15/9/28.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#ifndef DriverProject_MAPHeader_h
#define DriverProject_MAPHeader_h

//#define MAPAPIKEY (@"9dec0d2590f9c8068bc6ad026c462661")//测试
#define MAPAPIKEY (@"7addf48bb8156bd6de2ea6038328e73f")//正式
#define CLOUDTABLEID (@"561cd9d7e4b093dac913b5e8")
#define CLOUDRDIUS 10000

#define kArrorHeight    10

//搜索类型
typedef NS_ENUM(NSUInteger, MyMapType) {
    MyMapTypeHome = 0,  //home
    MyMapTypeOrder        //order
};

//搜索类型
typedef NS_ENUM(NSUInteger, SearchType) {
    SearchStart = 0, //起始
    SearchEnd        //结束
};


//乘车状态
typedef NS_ENUM(NSUInteger, RideState) {
    RideStartState     = 0,  //起始状态
    RideWaitingState   = 1,  //等待中
    RideArriveState    = 2,  //司机到达
    RideDrivingState   = 3,  //行驶中
};


//预约类型
typedef NS_ENUM(NSUInteger, OrderType) {
    OrderTypeImmediately = 1,       //立即呼叫
    OrderTypeBook = 2,        //预约
    OrderTypePick = 3,        //接机
    OrderTypeGive = 4,        //送机
};

//用车类型
typedef NS_ENUM(NSUInteger, CarType) {
    CarTypeEconomic    = 1,        //经济
    CarTypeComfortable = 2,        //舒适
    CarTypeBusiness    = 3,        //商务
};
#endif
