//
//  AccountModel.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/22.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "AccountModel.h"

@implementation AccountModel

-(NSDictionary *)attributeMapDictionary{
    
    NSDictionary *mapAtt = @{
                             @"name":@"remark",
                             @"time":@"log_time",
                             @"amount":@"money",
                             @"accountID":@"id",
                             @"order_no":@"order_no",
                             @"type":@"type",
                             };
    return mapAtt;
}



-(void)setAttributes:(NSDictionary *)dataDic{
    
    //将字典的映射关系填充到当前的对象属性上
    [super setAttributes:dataDic];
    
}

@end
