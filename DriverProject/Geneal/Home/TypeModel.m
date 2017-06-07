//
//  TypeModel.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/20.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "TypeModel.h"

@implementation TypeModel

-(NSDictionary *)attributeMapDictionary{
    
    NSDictionary *mapAtt = @{
                             @"logo":@"logo",
                             @"title":@"title",
                             @"status":@"status",

                             
                             };
    return mapAtt;
}



-(void)setAttributes:(NSDictionary *)dataDic{
    
    //将字典的映射关系填充到当前的对象属性上
    [super setAttributes:dataDic];
    
}

@end
