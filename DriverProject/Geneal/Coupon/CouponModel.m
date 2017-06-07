//
//  CouponModel.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/14.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "CouponModel.h"

@implementation CouponModel

-(NSDictionary *)attributeMapDictionary{
    
    NSDictionary *mapAtt = @{
                             @"couponID":@"id",
                             @"title":@"title",
                             @"desc":@"desc",
                             @"money":@"money",
                             @"isexpire":@"is_expire",
                             @"expire":@"expire",
                             
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
