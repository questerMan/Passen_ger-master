//
//  RecordModel.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/13.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BaseModel.h"
#import "UserModel.h"

@interface RecordModel : BaseModel

@property(nonatomic,retain)UserModel *userModel;

@property(nonatomic, copy)NSString *recordID;
@property(nonatomic, copy)NSString *timeString;
@property(nonatomic, copy)NSString *orderType;
@property(nonatomic, copy)NSString *orderStatus;
@property(nonatomic, copy)NSString *startAddress;
@property(nonatomic, copy)NSString *endAddress;
@property(nonatomic, copy)NSString *is_canceld;
@property(nonatomic, copy)NSString *is_comment;
@end
