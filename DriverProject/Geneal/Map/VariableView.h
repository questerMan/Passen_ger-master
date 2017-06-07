//
//  VariableView.h
//  GDAPI
//
//  Created by 开涛 on 15/7/26.
//  Copyright (c) 2015年 com.LHW.TESTGDAPI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VariableView :UIView

//生成一个lable
+ (UILabel *)initLabelWithFrame:(CGRect)frame
                           text:(NSString *)text
                      textColor:(UIColor *)color
                       textFont:(NSInteger)font;
//宽度自动适应
+ (void)autoAdaptHeightWithLable:(UILabel *)lable font:(NSInteger)fontSize;
@end
