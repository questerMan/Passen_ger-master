//
//  AccountModel.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/22.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface AccountModel : BaseModel

@property(nonatomic, copy)NSString *accountID;
@property(nonatomic, copy)NSString *order_no;
@property(nonatomic, copy)NSString *type;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *time;
@property(nonatomic, copy)NSString *amount;
@end
