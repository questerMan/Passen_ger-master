//
//  UserModel.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/13.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel

@property(nonatomic,copy)NSString *homeID;
@property(nonatomic,copy)NSString *message;       //消息
@property(nonatomic,copy)NSString *nick;          //昵称
@property(nonatomic,retain)NSArray *img_urls;                               //图片地址
@property(nonatomic,retain)NSArray *thumbimg_urls;                          //压缩图片地址
@property(nonatomic,retain)UIImage *headImg;  //头像

@end
