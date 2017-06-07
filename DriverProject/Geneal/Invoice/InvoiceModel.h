//
//  InvoiceModel.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/15.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BaseModel.h"
#import "UserModel.h"

@interface InvoiceModel : BaseModel

@property(nonatomic,retain)UserModel *userModel;

@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *time;
@property(nonatomic, copy)NSString *status;
@property(nonatomic, copy)NSString *amount;
@property(nonatomic, copy)NSString *send_method;
@property(nonatomic, copy)NSString *send_no;
@end
