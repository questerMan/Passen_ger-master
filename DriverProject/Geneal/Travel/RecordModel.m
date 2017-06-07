//
//  RecordModel.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/13.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "RecordModel.h"

@implementation RecordModel

-(NSDictionary *)attributeMapDictionary{
    
    NSDictionary *mapAtt = @{
                             @"recordID":@"id",
                             @"timeString":@"time",
                             @"orderType":@"type",
                             @"orderStatus":@"status",
                             @"startAddress":@"origin",
                             @"endAddress":@"dest",
                             @"is_canceld":@"is_canceld",
                             @"is_comment":@"is_comment"
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
