//
//  driverModel.m
//  DriverProject
//
//  Created by 开涛 on 15/10/18.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "driverModel.h"

@implementation driverModel

-(NSDictionary *)attributeMapDictionary{
    
    NSDictionary *mapAtt = @{
                             @"iconName":@"iconName",
                             @"brand":@"brand",
                             @"carType":@"carType",
                             @"dirverID":@"dirverID",
                             @"license":@"license",
                             @"nickname":@"nickname",
                             @"orderID":@"orderID",
                             @"dirverPhone":@"dirverPhone",
                             @"star":@"star",
                             };
    return mapAtt;
}



-(void)setAttributes:(NSDictionary *)dataDic{
    
    //将字典的映射关系填充到当前的对象属性上
    [super setAttributes:dataDic];
    
}

@end
