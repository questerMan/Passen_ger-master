//
//  NSDate+TimeConversion.m
//  DriverProject
//
//  Created by 开涛 on 15/10/19.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "NSDate+TimeConversion.h"

@implementation NSDate (TimeConversion)

+ (NSTimeInterval)getTimeFor1970WithTimeSting:(NSString *)timeStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *date = [formatter dateFromString:timeStr];
    NSTimeInterval time = [date timeIntervalSince1970];
    return time;
}

+ (NSString *)getStingTimeWithTime1970:(NSTimeInterval)time1970
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time1970];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

@end
