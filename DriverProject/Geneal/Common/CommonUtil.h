//
//  CommonUtil.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/8.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNPPopupController.h"

@interface CommonUtil : NSObject<CNPPopupControllerDelegate>

@property (nonatomic, strong)NSDictionary *utilDic;
+(CommonUtil *)shareUtil;

@end
