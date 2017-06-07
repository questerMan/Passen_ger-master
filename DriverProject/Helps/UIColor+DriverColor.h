//
//  UIColor+DriverColor.h
//  DriverProject
//
//  Created by 开涛 on 15/10/7.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (DriverColor)

//颜色转换
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
@end
