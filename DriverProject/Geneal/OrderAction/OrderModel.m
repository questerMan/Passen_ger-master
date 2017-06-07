//
//  OrderModel.m
//  DriverProject
//
//  Created by 开涛 on 15/10/15.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

-(NSDictionary *)attributeMapDictionary{
    
    NSDictionary *mapAtt = @{
                             @"OrderState":@"OrderState",
                             @"orderID":@"orderID",
                             @"newOrder":@"newOrder",
                             @"freeCancel":@"freeCancel",
                             @"totalPrice":@"totalPrice",
                             };
    return mapAtt;
}



-(void)setAttributes:(NSDictionary *)dataDic{
    
    //将字典的映射关系填充到当前的对象属性上
    [super setAttributes:dataDic];
    
}

@end
