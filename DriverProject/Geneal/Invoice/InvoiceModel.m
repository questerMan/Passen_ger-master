//
//  InvoiceModel.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/15.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "InvoiceModel.h"

@implementation InvoiceModel

-(NSDictionary *)attributeMapDictionary{
    
    NSDictionary *mapAtt = @{
                             @"name":@"title",
                             @"time":@"create_time",
                             @"status":@"status",
                             @"amount":@"amount",
                             @"send_method":@"send_method",
                             @"send_no":@"send_no",
                             };
    return mapAtt;
}



-(void)setAttributes:(NSDictionary *)dataDic{
    
    //将字典的映射关系填充到当前的对象属性上
    [super setAttributes:dataDic];
    
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    
    if (userDic != nil) {
        UserModel *userModel = [[UserModel alloc] initWithDataDic:userDic];
        self.userModel = userModel;
        NSLog(@"userModel is :%@",self.userModel);
    }
    
}

@end
