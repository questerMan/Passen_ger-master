//
//  driverModel.h
//  DriverProject
//
//  Created by 开涛 on 15/10/18.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface driverModel : BaseModel

@property(strong, nonatomic)NSString *iconName;//照片名字

@property(strong, nonatomic)NSString *brand;   //车型品牌

@property(assign, nonatomic)CarType  carType;  //用车类型

@property(strong, nonatomic)NSString *dirverID;//司机id

@property(strong, nonatomic)NSString *license; //许可证

@property(strong, nonatomic)NSString *nickname;//昵称

@property(strong, nonatomic)NSString *orderID; //订单号

@property(strong, nonatomic)NSString *dirverPhone;//司机电话

@property(strong, nonatomic)NSString *star;    //星
@end
