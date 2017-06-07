//
//  CommonUtil.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/8.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "CommonUtil.h"

@implementation CommonUtil

+(CommonUtil *)shareUtil
{
    static CommonUtil *shareUtilManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareUtilManager = [[self alloc] init];
    });
    return shareUtilManager;
}

-(void)useCarServeRightNow
{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 60)];
    title.text = [self.utilDic objectForKey:UTIL_TITLE_KEY];
    title.textAlignment = NSTextAlignmentCenter;
    [title setFont:[UIFont systemFontOfSize:17]];
    
//    CNPPopupController *popupController = [CNPPopupController alloc]initWithContents:<#(NSArray *)#>
}

@end
