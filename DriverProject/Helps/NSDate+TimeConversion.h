//
//  NSDate+TimeConversion.h
//  DriverProject
//
//  Created by 开涛 on 15/10/19.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TimeConversion)

//YYYY-MM-dd HH:mm:ss 转1970
+ (NSTimeInterval)getTimeFor1970WithTimeSting:(NSString *)timeStr;

//1970 转 YYYY-MM-dd HH:mm:ss
+ (NSString *)getStingTimeWithTime1970:(NSTimeInterval)time1970;
@end
