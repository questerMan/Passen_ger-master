//
//  OrderModel.h
//  DriverProject
//
//  Created by 开涛 on 15/10/15.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BaseModel.h"
/*
 封装了 订单信息
 */
@interface OrderModel : BaseModel
/*
 //订单状态
 #define ORDER_STATUS_A              0        //已下单未接单
 #define ORDER_STATUS_B              1        //司机接单
 #define ORDER_STATUS_C              2        //司机发车
 #define ORDER_STATUS_D              3        //司机到达上车点
 #define ORDER_STATUS_E              4        //乘客上车行驶
 #define ORDER_STATUS_F              5        //等待付款
 #define ORDER_STATUS_G              6        //已付款
 */
@property(nonatomic, assign)NSInteger orderState;   //订单状态
@property(nonatomic, strong)NSString *orderID;      //订单id
@property(nonatomic, assign)BOOL      newOrder;     //是否是新的订单
@property(nonatomic, strong)NSString *freeCancel;   //是否可以免费取消
@property(nonatomic, strong)NSString *totalPrice;   //此次订单总价格
@end
